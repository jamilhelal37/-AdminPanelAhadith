-- Manual payment flow for pro upgrade
-- Adds payment verification fields and request status lifecycle.

-- 1) Extend payments table for manual transfer proof/verification.
alter table public.pro_upgrade_payments
  add column if not exists payment_method text not null default 'manual_transfer',
  add column if not exists payment_reference text,
  add column if not exists proof_file_path text,
  add column if not exists verification_status text not null default 'pending_verification',
  add column if not exists verified_by uuid null,
  add column if not exists verified_at timestamptz null,
  add column if not exists review_notes text null;

alter table public.pro_upgrade_payments
  drop constraint if exists fk_pro_upgrade_payments_verified_by;

alter table public.pro_upgrade_payments
  add constraint fk_pro_upgrade_payments_verified_by
  foreign key (verified_by)
  references public.app_user(id)
  on delete set null;

alter table public.pro_upgrade_payments
  drop constraint if exists chk_pro_upgrade_payments_verification_status;

alter table public.pro_upgrade_payments
  add constraint chk_pro_upgrade_payments_verification_status
  check (verification_status in ('pending_verification', 'verified', 'rejected'));

-- Keep backward compatibility for old integrations that still write provider_payment_id.
update public.pro_upgrade_payments
set payment_reference = provider_payment_id
where payment_reference is null
  and provider_payment_id is not null;

-- 2) Move request lifecycle to: pending_documents -> pending_payment_receipt -> under_review -> reviewed.
update public.pro_upgrade_requests
set status = 'under_review'
where status = 'pending_review';

alter table public.pro_upgrade_requests
  drop constraint if exists chk_pro_upgrade_requests_status;

alter table public.pro_upgrade_requests
  add constraint chk_pro_upgrade_requests_status
  check (
    status in ('pending_documents', 'pending_payment_receipt', 'under_review', 'reviewed')
  );

-- One active request (anything not reviewed) per user.
drop index if exists uq_pro_upgrade_requests_user_pending;

create unique index if not exists uq_pro_upgrade_requests_user_active
  on public.pro_upgrade_requests(user_id)
  where status <> 'reviewed';

-- 3) Rework request creation: user starts with document upload first.
create or replace function public.create_pro_upgrade_request(
  p_user_id uuid
)
returns json as $$
declare
  v_request_id uuid;
  v_existing_id uuid;
  v_existing_status text;
begin
  select id, status
    into v_existing_id, v_existing_status
  from public.pro_upgrade_requests
  where user_id = p_user_id
    and status <> 'reviewed'
  order by created_at desc
  limit 1;

  if v_existing_id is not null then
    return json_build_object(
      'request_id', v_existing_id,
      'status', v_existing_status,
      'need_payment', v_existing_status = 'pending_payment_receipt',
      'need_certificates', v_existing_status = 'pending_documents',
      'message', 'لديك طلب ترقية نشط بالفعل'
    );
  end if;

  insert into public.pro_upgrade_requests (user_id, payment_id, status)
  values (p_user_id, null, 'pending_documents')
  returning id into v_request_id;

  return json_build_object(
    'request_id', v_request_id,
    'status', 'pending_documents',
    'need_payment', false,
    'need_certificates', true,
    'message', 'تم إنشاء الطلب. يرجى رفع الشهادات أولاً.'
  );
exception when others then
  return json_build_object('error', SQLERRM);
end;
$$ language plpgsql security definer;

-- 4) After first certificate upload, request moves to pending_payment_receipt.
create or replace function public.handle_pro_upgrade_certificate_insert()
returns trigger
language plpgsql
security definer
as $$
begin
  update public.pro_upgrade_requests
  set status = 'pending_payment_receipt'
  where id = new.request_id
    and status = 'pending_documents';

  return new;
end;
$$;

drop trigger if exists trg_handle_pro_upgrade_certificate_insert on public.pro_upgrade_certificates;

create trigger trg_handle_pro_upgrade_certificate_insert
after insert on public.pro_upgrade_certificates
for each row execute function public.handle_pro_upgrade_certificate_insert();

-- Ensure payment proof uploads are not synced as certificates.
create or replace function public.sync_pro_upgrade_certificate_from_storage()
returns trigger
language plpgsql
security definer set search_path = public, storage
as $$
declare
  v_user_id uuid;
  v_request_id uuid;
begin
  if new.bucket_id <> 'scholar-certificates' then
    return new;
  end if;

  if split_part(new.name, '/', 3) = 'payment_proofs' then
    return new;
  end if;

  begin
    v_user_id := split_part(new.name, '/', 1)::uuid;
    v_request_id := split_part(new.name, '/', 2)::uuid;
  exception when others then
    return new;
  end;

  if exists (
    select 1
    from public.pro_upgrade_requests pr
    where pr.id = v_request_id
      and pr.user_id = v_user_id
  ) then
    insert into public.pro_upgrade_certificates (request_id, file_path)
    select v_request_id, new.name
    where not exists (
      select 1
      from public.pro_upgrade_certificates c
      where c.request_id = v_request_id
        and c.file_path = new.name
    );
  end if;

  return new;
end;
$$;

-- 5) Auto-link submitted payment to request and move to under_review.
create or replace function public.handle_pro_upgrade_payment_insert()
returns trigger
language plpgsql
security definer
as $$
declare
  v_has_certificates boolean;
begin
  select exists (
    select 1
    from public.pro_upgrade_certificates c
    where c.request_id = new.request_id
  ) into v_has_certificates;

  if not v_has_certificates then
    raise exception 'Cannot submit payment receipt before uploading certificates';
  end if;

  update public.pro_upgrade_requests
  set
    payment_id = new.id,
    status = 'under_review'
  where id = new.request_id
    and user_id = new.user_id
    and status in ('pending_payment_receipt', 'under_review');

  return new;
end;
$$;

drop trigger if exists trg_handle_pro_upgrade_payment_insert on public.pro_upgrade_payments;

create trigger trg_handle_pro_upgrade_payment_insert
after insert on public.pro_upgrade_payments
for each row execute function public.handle_pro_upgrade_payment_insert();

-- 6) RLS: users can insert payment only after certificates are uploaded for active request.
drop policy if exists pro_upgrade_payments_insert_own on public.pro_upgrade_payments;
create policy pro_upgrade_payments_insert_own
  on public.pro_upgrade_payments
  for insert
  to authenticated
  with check (
    public.owns_pro_upgrade_request(request_id)
    and exists (
      select 1
      from public.pro_upgrade_requests r
      where r.id = request_id
        and r.user_id = auth.uid()
        and r.status = 'pending_payment_receipt'
    )
    and exists (
      select 1
      from public.pro_upgrade_certificates c
      where c.request_id = request_id
    )
  );

-- 7) RLS: allow admin to verify/reject payment records.
drop policy if exists pro_upgrade_payments_update_admin on public.pro_upgrade_payments;
create policy pro_upgrade_payments_update_admin
  on public.pro_upgrade_payments
  for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

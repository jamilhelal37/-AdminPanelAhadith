-- Remove payments from pro-upgrade flow.
-- Final flow: request -> certificates -> under_review -> supervisor decision.

-- 1) Remove decision dependency on payments.
alter table public.pro_upgrade_decisions
  drop constraint if exists fk_pro_upgrade_decisions_payment_id;

alter table public.pro_upgrade_decisions
  drop constraint if exists uq_pro_upgrade_decisions_req_pay_user;

alter table public.pro_upgrade_decisions
  drop column if exists payment_id;

alter table public.pro_upgrade_decisions
  drop constraint if exists uq_pro_upgrade_decisions_req_user;

alter table public.pro_upgrade_decisions
  add constraint uq_pro_upgrade_decisions_req_user unique (request_id, user_id);

-- 2) Simplify requests table statuses and remove payment pointer.
alter table public.pro_upgrade_requests
  drop constraint if exists fk_pro_upgrade_requests_payment_id;

alter table public.pro_upgrade_requests
  drop column if exists payment_id;

update public.pro_upgrade_requests
set status = 'under_review'
where status in ('pending_payment_receipt', 'pending_review');

alter table public.pro_upgrade_requests
  drop constraint if exists chk_pro_upgrade_requests_status;

alter table public.pro_upgrade_requests
  add constraint chk_pro_upgrade_requests_status
  check (status in ('pending_documents', 'under_review', 'reviewed'));

-- Keep one active request per user.
drop index if exists uq_pro_upgrade_requests_user_pending;
drop index if exists uq_pro_upgrade_requests_user_active;
create unique index if not exists uq_pro_upgrade_requests_user_active
  on public.pro_upgrade_requests(user_id)
  where status <> 'reviewed';

-- 3) Remove payments policies/table.
drop policy if exists pro_upgrade_payments_select_own on public.pro_upgrade_payments;
drop policy if exists pro_upgrade_payments_insert_own on public.pro_upgrade_payments;
drop policy if exists pro_upgrade_payments_update_admin on public.pro_upgrade_payments;
drop policy if exists pro_upgrade_payments_delete_admin on public.pro_upgrade_payments;

drop trigger if exists trg_handle_pro_upgrade_payment_insert on public.pro_upgrade_payments;

-- Drop table at the end after dependencies are removed.
drop table if exists public.pro_upgrade_payments;

-- 4) Restrict request updates to admins only.
drop policy if exists pro_upgrade_requests_update_own_or_admin on public.pro_upgrade_requests;
drop policy if exists pro_upgrade_requests_update_admin_only on public.pro_upgrade_requests;
create policy pro_upgrade_requests_update_admin_only
  on public.pro_upgrade_requests
  for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

-- 5) Restrict certificate insert to pending_documents stage.
drop policy if exists pro_upgrade_certificates_insert_own on public.pro_upgrade_certificates;
create policy pro_upgrade_certificates_insert_own
  on public.pro_upgrade_certificates
  for insert
  to authenticated
  with check (
    public.owns_pro_upgrade_request(request_id)
    and exists (
      select 1
      from public.pro_upgrade_requests r
      where r.id = request_id
        and r.user_id = auth.uid()
        and r.status = 'pending_documents'
    )
  );

-- 6) Decisions visibility: owner or admin.
drop policy if exists pro_upgrade_decisions_select_all on public.pro_upgrade_decisions;
drop policy if exists pro_upgrade_decisions_select_own_or_admin on public.pro_upgrade_decisions;
create policy pro_upgrade_decisions_select_own_or_admin
  on public.pro_upgrade_decisions
  for select
  to authenticated
  using (
    user_id = auth.uid() or
    public.is_admin()
  );

-- 7) Request creation RPC (no payment fields).
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
      'need_certificates', v_existing_status = 'pending_documents',
      'message', 'لديك طلب ترقية نشط بالفعل'
    );
  end if;

  insert into public.pro_upgrade_requests (user_id, status)
  values (p_user_id, 'pending_documents')
  returning id into v_request_id;

  return json_build_object(
    'request_id', v_request_id,
    'status', 'pending_documents',
    'need_certificates', true,
    'message', 'تم إنشاء الطلب. يرجى رفع الشهادات أولاً.'
  );
exception when others then
  return json_build_object('error', SQLERRM);
end;
$$ language plpgsql security definer;

-- 8) Sequence handlers: certificate upload moves request to under_review.
create or replace function public.handle_pro_upgrade_certificate_insert()
returns trigger
language plpgsql
security definer
as $$
begin
  update public.pro_upgrade_requests
  set status = 'under_review'
  where id = new.request_id
    and status = 'pending_documents';

  return new;
end;
$$;

-- Recreate certificate trigger safely.
drop trigger if exists trg_handle_pro_upgrade_certificate_insert on public.pro_upgrade_certificates;
create trigger trg_handle_pro_upgrade_certificate_insert
after insert on public.pro_upgrade_certificates
for each row execute function public.handle_pro_upgrade_certificate_insert();

-- 9) Certificate storage sync: everything in path <user>/<request>/<file> is certificate.
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

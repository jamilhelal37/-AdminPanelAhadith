










create table if not exists public.pro_upgrade_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  status text not null default 'pending_documents',
  created_at timestamptz not null default now(),
  constraint fk_pro_upgrade_requests_user_id foreign key (user_id)
    references public.app_user(id) on delete cascade,
  constraint chk_pro_upgrade_requests_status
    check (status in ('pending_documents', 'under_review', 'reviewed'))
);

create unique index if not exists uq_pro_upgrade_requests_user_active
  on public.pro_upgrade_requests(user_id)
  where status <> 'reviewed';



create table if not exists public.pro_upgrade_certificates (
  id uuid primary key default gen_random_uuid(),
  request_id uuid not null,
  file_path text not null,
  created_at timestamptz not null default now(),
  constraint fk_pro_upgrade_certificates_request_id foreign key (request_id)
    references public.pro_upgrade_requests(id) on delete cascade
);



create table if not exists public.pro_upgrade_decisions (
  id uuid primary key default gen_random_uuid(),
  request_id uuid not null,
  user_id uuid not null,
  approved boolean not null,
  reviewed_by uuid null,
  notes text,
  created_at timestamptz not null default now(),
  constraint fk_pro_upgrade_decisions_request_id foreign key (request_id)
    references public.pro_upgrade_requests(id) on delete restrict,
  constraint fk_pro_upgrade_decisions_user_id foreign key (user_id)
    references public.app_user(id) on delete set null,
  constraint fk_pro_upgrade_decisions_reviewed_by foreign key (reviewed_by)
    references public.app_user(id) on delete set null,
  constraint uq_pro_upgrade_decisions_req_user unique (request_id, user_id)
);






create index if not exists idx_pro_upgrade_requests_user_id
  on public.pro_upgrade_requests(user_id);

create index if not exists idx_pro_upgrade_requests_created_at
  on public.pro_upgrade_requests(created_at);

create index if not exists idx_pro_upgrade_requests_status_created_at
  on public.pro_upgrade_requests(status, created_at desc);

create index if not exists idx_pro_upgrade_certificates_request_id
  on public.pro_upgrade_certificates(request_id);

create index if not exists idx_pro_upgrade_certificates_created_at
  on public.pro_upgrade_certificates(created_at);

create index if not exists idx_pro_upgrade_decisions_user_id
  on public.pro_upgrade_decisions(user_id);

create index if not exists idx_pro_upgrade_decisions_reviewed_by
  on public.pro_upgrade_decisions(reviewed_by);

create index if not exists idx_pro_upgrade_decisions_approved
  on public.pro_upgrade_decisions(approved);

create index if not exists idx_pro_upgrade_decisions_created_at
  on public.pro_upgrade_decisions(created_at);







create or replace function public.owns_pro_upgrade_request(p_request_id uuid)
returns boolean
language plpgsql
security definer set search_path = public
as $$
begin
  return exists (
    select 1
    from public.pro_upgrade_requests
    where id = p_request_id
      and user_id = auth.uid()
  );
end;
$$;



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



create or replace function public.submit_pro_upgrade_request(
  p_request_id uuid
)
returns json
language plpgsql
security definer
as $$
declare
  v_user_id uuid := auth.uid();
  v_status text;
  v_has_certificate boolean;
begin
  if v_user_id is null then
    return json_build_object('error', 'Authentication required.');
  end if;

  select status
    into v_status
  from public.pro_upgrade_requests
  where id = p_request_id
    and user_id = v_user_id;

  if v_status is null then
    return json_build_object('error', 'Request not found or access denied.');
  end if;

  if v_status <> 'pending_documents' then
    return json_build_object(
      'error',
      'Request cannot be submitted in current status.'
    );
  end if;

  select exists (
    select 1
    from public.pro_upgrade_certificates
    where request_id = p_request_id
  ) into v_has_certificate;

  if not v_has_certificate then
    return json_build_object('error', 'Please upload at least one certificate.');
  end if;

  update public.pro_upgrade_requests
  set status = 'under_review'
  where id = p_request_id
    and user_id = v_user_id
    and status = 'pending_documents';

  return json_build_object(
    'request_id', p_request_id,
    'status', 'under_review',
    'message', 'تم إرسال الطلب للمراجعة بنجاح.'
  );
exception when others then
  return json_build_object('error', SQLERRM);
end;
$$;







alter table public.pro_upgrade_requests enable row level security;

drop policy if exists pro_upgrade_requests_select_own on public.pro_upgrade_requests;
create policy pro_upgrade_requests_select_own
  on public.pro_upgrade_requests
  for select
  to authenticated
  using (
    user_id = auth.uid() or
    public.is_admin()
  );

drop policy if exists pro_upgrade_requests_insert_own on public.pro_upgrade_requests;
create policy pro_upgrade_requests_insert_own
  on public.pro_upgrade_requests
  for insert
  to authenticated
  with check (
    user_id = auth.uid() and
    public.is_member()
  );

drop policy if exists pro_upgrade_requests_update_own_or_admin on public.pro_upgrade_requests;
drop policy if exists pro_upgrade_requests_update_admin_only on public.pro_upgrade_requests;
create policy pro_upgrade_requests_update_admin_only
  on public.pro_upgrade_requests
  for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists pro_upgrade_requests_delete_admin on public.pro_upgrade_requests;
create policy pro_upgrade_requests_delete_admin
  on public.pro_upgrade_requests
  for delete
  to authenticated
  using (public.is_admin());



alter table public.pro_upgrade_certificates enable row level security;

drop policy if exists pro_upgrade_certificates_select_own on public.pro_upgrade_certificates;
create policy pro_upgrade_certificates_select_own
  on public.pro_upgrade_certificates
  for select
  to authenticated
  using (
    public.owns_pro_upgrade_request(pro_upgrade_certificates.request_id) or
    public.is_admin()
  );

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

drop policy if exists pro_upgrade_certificates_delete_admin on public.pro_upgrade_certificates;
create policy pro_upgrade_certificates_delete_admin
  on public.pro_upgrade_certificates
  for delete
  to authenticated
  using (public.is_admin());



alter table public.pro_upgrade_decisions enable row level security;

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

drop policy if exists pro_upgrade_decisions_insert_admin on public.pro_upgrade_decisions;
create policy pro_upgrade_decisions_insert_admin
  on public.pro_upgrade_decisions
  for insert
  to authenticated
  with check (public.is_admin());

drop policy if exists pro_upgrade_decisions_update_admin on public.pro_upgrade_decisions;
create policy pro_upgrade_decisions_update_admin
  on public.pro_upgrade_decisions
  for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists pro_upgrade_decisions_delete_admin on public.pro_upgrade_decisions;
create policy pro_upgrade_decisions_delete_admin
  on public.pro_upgrade_decisions
  for delete
  to authenticated
  using (public.is_admin());







drop trigger if exists trg_sync_pro_upgrade_certificate_from_storage on storage.objects;
create trigger trg_sync_pro_upgrade_certificate_from_storage
after insert on storage.objects
for each row
execute function public.sync_pro_upgrade_certificate_from_storage();


drop trigger if exists trg_handle_pro_upgrade_certificate_insert on public.pro_upgrade_certificates;






insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'scholar-certificates',
  'scholar-certificates',
  false,
  10485760,
  array['image/jpeg', 'image/png', 'application/pdf']
)
on conflict (id) do update
set
  name = excluded.name,
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;


drop policy if exists "scholars-user-upload" on storage.objects;
create policy "scholars-user-upload"
  on storage.objects
  for insert
  with check (
    bucket_id = 'scholar-certificates' and
    (storage.foldername(name))[1]::uuid = auth.uid() and
    public.is_member()
  );

drop policy if exists "scholars-user-view" on storage.objects;
create policy "scholars-user-view"
  on storage.objects
  for select
  using (
    bucket_id = 'scholar-certificates' and
    (
      (storage.foldername(name))[1]::uuid = auth.uid() or
      public.is_admin()
    )
  );

drop policy if exists "scholars-user-delete" on storage.objects;
create policy "scholars-user-delete"
  on storage.objects
  for delete
  using (
    bucket_id = 'scholar-certificates' and
    (storage.foldername(name))[1]::uuid = auth.uid()
  );

drop policy if exists "scholars-admin-view" on storage.objects;
drop policy if exists "scholars-admin-delete" on storage.objects;
create policy "scholars-admin-delete"
  on storage.objects
  for delete
  using (
    bucket_id = 'scholar-certificates' and
    public.is_admin()
  );

-- Fix pro-upgrade certificate uploads by ensuring storage is migrated
-- and by aligning request creation with member-only eligibility.

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
  to authenticated
  with check (
    bucket_id = 'scholar-certificates' and
    (storage.foldername(name))[1]::uuid = auth.uid() and
    public.is_member()
  );

drop policy if exists "scholars-user-view" on storage.objects;
create policy "scholars-user-view"
  on storage.objects
  for select
  to authenticated
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
  to authenticated
  using (
    bucket_id = 'scholar-certificates' and
    (storage.foldername(name))[1]::uuid = auth.uid()
  );

drop policy if exists "scholars-admin-delete" on storage.objects;
create policy "scholars-admin-delete"
  on storage.objects
  for delete
  to authenticated
  using (
    bucket_id = 'scholar-certificates' and
    public.is_admin()
  );

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

drop trigger if exists trg_sync_pro_upgrade_certificate_from_storage on storage.objects;
create trigger trg_sync_pro_upgrade_certificate_from_storage
after insert on storage.objects
for each row
execute function public.sync_pro_upgrade_certificate_from_storage();

create or replace function public.create_pro_upgrade_request(
  p_user_id uuid
)
returns json
language plpgsql
security definer
set search_path = public
as $$
declare
  v_auth_user_id uuid := auth.uid();
  v_request_id uuid;
  v_existing_id uuid;
  v_existing_status text;
begin
  if v_auth_user_id is null then
    return json_build_object('error', 'Authentication required.');
  end if;

  if p_user_id is null or p_user_id <> v_auth_user_id then
    return json_build_object('error', 'Access denied.');
  end if;

  if not public.is_member() then
    return json_build_object(
      'error',
      'Only member accounts can create a pro-upgrade request.'
    );
  end if;

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
$$;

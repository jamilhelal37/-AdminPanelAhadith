-- 1) Ensure avatars bucket exists and is public for profile images.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'avatars',
  'avatars',
  true,
  5242880,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update
set
  name = excluded.name,
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

-- 2) Avatars storage policies.
drop policy if exists "avatars-user-upload" on storage.objects;
create policy "avatars-user-upload"
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'avatars'
  );

drop policy if exists "avatars-user-update" on storage.objects;
create policy "avatars-user-update"
  on storage.objects
  for update
  to authenticated
  using (
    bucket_id = 'avatars'
  )
  with check (
    bucket_id = 'avatars'
  );

drop policy if exists "avatars-user-delete" on storage.objects;
create policy "avatars-user-delete"
  on storage.objects
  for delete
  to authenticated
  using (
    bucket_id = 'avatars'
  );

drop policy if exists "avatars-admin-delete" on storage.objects;
create policy "avatars-admin-delete"
  on storage.objects
  for delete
  to authenticated
  using (
    bucket_id = 'avatars' and
    public.is_admin()
  );

-- 3) Stop automatic request submission after any certificate upload.
drop trigger if exists trg_handle_pro_upgrade_certificate_insert on public.pro_upgrade_certificates;

-- 4) Add explicit manual submission RPC after uploading one or more certificates.
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

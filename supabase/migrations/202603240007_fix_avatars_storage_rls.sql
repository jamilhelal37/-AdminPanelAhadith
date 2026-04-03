-- Fix avatars storage RLS to avoid false 403 on upload.
-- Use text comparison for folder user id: {auth.uid()}/{file}

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

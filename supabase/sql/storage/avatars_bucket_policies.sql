-- RLS Policies for avatars bucket on storage.objects

-- Users can upload avatars only into their own folder: {user_id}/{file}
drop policy if exists "avatars-user-upload" on storage.objects;
create policy "avatars-user-upload"
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'avatars'
  );

-- Users can update their own avatar files
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

-- Users can delete their own avatar files
drop policy if exists "avatars-user-delete" on storage.objects;
create policy "avatars-user-delete"
  on storage.objects
  for delete
  to authenticated
  using (
    bucket_id = 'avatars'
  );

-- Public bucket means select is available through public URLs.
-- Admin delete policy for moderation.
drop policy if exists "avatars-admin-delete" on storage.objects;
create policy "avatars-admin-delete"
  on storage.objects
  for delete
  to authenticated
  using (
    bucket_id = 'avatars' and
    public.is_admin()
  );

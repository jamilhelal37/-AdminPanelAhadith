-- RLS Policies for scholar-certificates bucket on storage.objects

-- Users can upload to their own folder
-- Path format: {user_id}/{request_id}/{filename}
drop policy if exists "scholars-user-upload" on storage.objects;
create policy "scholars-user-upload"
  on storage.objects
  for insert
  with check (
    bucket_id = 'scholar-certificates' and
    (storage.foldername(name))[1]::uuid = auth.uid() and
    public.is_member()
  );

-- Users can view their own files (admins included)
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

-- Users can delete their own files
drop policy if exists "scholars-user-delete" on storage.objects;
create policy "scholars-user-delete"
  on storage.objects
  for delete
  using (
    bucket_id = 'scholar-certificates' and
    (storage.foldername(name))[1]::uuid = auth.uid()
  );

drop policy if exists "scholars-admin-view" on storage.objects;
-- Admins can delete any files
drop policy if exists "scholars-admin-delete" on storage.objects;
create policy "scholars-admin-delete"
  on storage.objects
  for delete
  using (
    bucket_id = 'scholar-certificates' and
    public.is_admin()
  );

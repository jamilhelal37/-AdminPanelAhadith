



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

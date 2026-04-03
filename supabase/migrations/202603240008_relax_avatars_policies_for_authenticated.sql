-- Temporary hotfix: relax avatars bucket policies for authenticated users.
-- This resolves persistent 403 errors on mobile avatar upload.

DROP POLICY IF EXISTS "avatars-user-upload" ON storage.objects;
CREATE POLICY "avatars-user-upload"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
  );

DROP POLICY IF EXISTS "avatars-user-update" ON storage.objects;
CREATE POLICY "avatars-user-update"
  ON storage.objects
  FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'avatars'
  )
  WITH CHECK (
    bucket_id = 'avatars'
  );

DROP POLICY IF EXISTS "avatars-user-delete" ON storage.objects;
CREATE POLICY "avatars-user-delete"
  ON storage.objects
  FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'avatars'
  );

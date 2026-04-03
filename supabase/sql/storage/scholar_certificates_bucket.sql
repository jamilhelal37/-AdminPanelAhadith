-- Storage Configuration for Scholar Certificates
-- Create a private storage bucket for scholar certificate uploads

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

-- Suggested path structure: {user_id}/{request_id}/{filename}

-- Related scripts:
-- - Policies: sql/storage/scholar_certificates_bucket_policies.sql
-- - Sync function: sql/functions/16_sync_pro_upgrade_certificate_from_storage.sql
-- - Sync trigger: sql/triggers/18_pro_upgrade_certificates_storage.sql


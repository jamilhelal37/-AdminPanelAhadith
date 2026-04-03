create table if not exists public.admin_audit_log (
  id uuid primary key default gen_random_uuid(),
  table_name text not null,
  operation text not null check (operation in ('INSERT', 'UPDATE', 'DELETE')),
  record_id uuid,
  actor_user_id uuid,
  old_data jsonb,
  new_data jsonb,
  created_at timestamptz not null default now()
);

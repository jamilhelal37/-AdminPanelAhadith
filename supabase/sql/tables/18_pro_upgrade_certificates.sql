
create table if not exists public.pro_upgrade_certificates (
  id uuid primary key default gen_random_uuid(),
  request_id uuid not null,
  file_path text not null,
  created_at timestamptz not null default now(),
  

  constraint fk_pro_upgrade_certificates_request_id foreign key (request_id)
    references public.pro_upgrade_requests(id) on delete cascade

);

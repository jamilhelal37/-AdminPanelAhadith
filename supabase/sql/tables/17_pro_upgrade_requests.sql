
create table if not exists public.pro_upgrade_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  status text not null default 'pending_documents',
  created_at timestamptz not null default now(),  
  constraint fk_pro_upgrade_requests_user_id foreign key (user_id) 
    references public.app_user(id) on delete cascade,
  constraint chk_pro_upgrade_requests_status
    check (
      status in ('pending_documents', 'under_review', 'reviewed')
    )
);

create unique index if not exists uq_pro_upgrade_requests_user_active
  on public.pro_upgrade_requests(user_id)
  where status <> 'reviewed';

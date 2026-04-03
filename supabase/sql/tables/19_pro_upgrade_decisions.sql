
create table if not exists public.pro_upgrade_decisions (
  id uuid primary key default gen_random_uuid(),
  request_id uuid not null ,
  user_id uuid not null ,
  approved boolean not null ,
  reviewed_by uuid  null,
  notes text ,
  created_at timestamptz not null default now(),
  
  constraint fk_pro_upgrade_decisions_request_id foreign key (request_id) 
    references public.pro_upgrade_requests(id) on delete restrict,
  constraint fk_pro_upgrade_decisions_user_id foreign key (user_id) 
    references public.app_user(id) on delete set null,
  constraint fk_pro_upgrade_decisions_reviewed_by foreign key (reviewed_by) 
    references public.app_user(id) on delete set null,

  constraint uq_pro_upgrade_decisions_req_user unique (request_id, user_id)
);


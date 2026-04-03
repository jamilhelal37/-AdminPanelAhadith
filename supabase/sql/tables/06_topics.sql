create table if not exists public.topics (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_topics_created_by
    foreign key (created_by)
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint fk_topics_updated_by
    foreign key (updated_by)
    references public.app_user(id)
    on delete set null
    on update cascade
);



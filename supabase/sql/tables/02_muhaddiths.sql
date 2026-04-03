create table if not exists public.muhaddiths (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  gender public.gender not null,
  about text not null,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_muhaddiths_created_by
    foreign key (created_by)
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint fk_muhaddiths_updated_by
    foreign key (updated_by)
    references public.app_user(id)
    on delete set null
    on update cascade
);



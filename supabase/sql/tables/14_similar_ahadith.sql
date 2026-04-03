create table if not exists public.similar_ahadith (
  id uuid primary key default gen_random_uuid(),
  main_hadith uuid null,
  sim_hadith uuid null,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_similar_main
    foreign key (main_hadith)
    references public.ahadith(id)
    on delete set null
    on update cascade,

  constraint fk_similar_sim
    foreign key (sim_hadith)
    references public.ahadith(id)
    on delete set null
    on update cascade,

  constraint fk_similar_ahadith_created_by
    foreign key (created_by)
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint fk_similar_ahadith_updated_by
    foreign key (updated_by)
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint uq_similar_ahadith_main_sim unique (main_hadith, sim_hadith)
);

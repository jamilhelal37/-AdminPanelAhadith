create table if not exists public.fake_ahadith (
  id uuid primary key default gen_random_uuid(),
  sub_valid uuid null,
  text text not null,
  normal_text text,
  search_text text,
  ruling uuid null,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_fake_ahadith_sub_valid
    foreign key (sub_valid)
    references public.ahadith(id)
    on delete set null
    on update cascade,

  constraint fk_fake_ahadith_ruling
    foreign key (ruling)
    references public.ruling(id)
    on delete set null
    on update cascade,

  constraint fk_fake_ahadith_created_by
    foreign key (created_by)
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint fk_fake_ahadith_updated_by
    foreign key (updated_by)
    references public.app_user(id)
    on delete set null
    on update cascade
);



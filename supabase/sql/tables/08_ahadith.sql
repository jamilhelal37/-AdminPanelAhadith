create table if not exists public.ahadith (
  id uuid primary key default gen_random_uuid(),
  sub_valid uuid null,
  explaining uuid null,
  type public.hadith_type not null,
  text text not null,
  normal_text text,
  search_text text,
  hadith_number integer not null,
  muhaddith_ruling uuid null,
  final_ruling uuid null,
  rawi uuid null,
  source uuid null,
  sanad text,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_ahadith_sub_valid
    foreign key (sub_valid)
    references public.ahadith(id)
    on delete set null
    on update cascade,

  constraint fk_ahadith_explaining
    foreign key (explaining)
    references public.explaining(id)
    on delete set null
    on update cascade,

  constraint fk_ahadith_muhaddith_ruling
    foreign key (muhaddith_ruling)
    references public.ruling(id)
    on delete set null
    on update cascade,

  constraint fk_ahadith_final_ruling
    foreign key (final_ruling)
    references public.ruling(id)
    on delete set null
    on update cascade,

  constraint fk_ahadith_rawi
    foreign key (rawi)
    references public.rawis(id)
    on delete set null
    on update cascade,

  constraint fk_ahadith_source
    foreign key (source)
    references public.books(id)
    on delete set null
    on update cascade,

  constraint fk_ahadith_created_by
    foreign key (created_by)
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint fk_ahadith_updated_by
    foreign key (updated_by)
    references public.app_user(id)
    on delete set null
    on update cascade
);



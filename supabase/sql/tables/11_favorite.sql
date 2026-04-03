create table if not exists public.favorite (
  id uuid primary key default gen_random_uuid(),
  "user" uuid not null,
  hadith uuid not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_favorite_user
    foreign key ("user")
    references public.app_user(id)
    on delete cascade
    on update cascade,

  constraint fk_favorite_hadith
    foreign key (hadith)
    references public.ahadith(id)
    on delete cascade
    on update cascade,

  constraint uq_favorite_user_hadith unique ("user", hadith)
);

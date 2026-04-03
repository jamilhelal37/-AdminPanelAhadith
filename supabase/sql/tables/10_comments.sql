create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  hadith uuid not null,
  "user" uuid not null,
  text text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_comments_hadith
    foreign key (hadith)
    references public.ahadith(id)
    on delete cascade
    on update cascade,

  constraint fk_comments_user
    foreign key ("user")
    references public.app_user(id)
    on delete cascade
    on update cascade
);


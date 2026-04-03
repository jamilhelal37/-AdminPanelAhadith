create table if not exists public.search_history (
  id uuid primary key default gen_random_uuid(),
  "user" uuid not null,
  search_text text not null,
  ishadith boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_search_history_user
    foreign key ("user")
    references public.app_user(id)
    on delete cascade
    on update cascade
);

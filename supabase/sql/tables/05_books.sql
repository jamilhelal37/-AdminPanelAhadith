create table if not exists public.books (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  muhaddith uuid null,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_books_muhaddith
    foreign key (muhaddith)
    references public.muhaddiths(id)
    on delete set null
    on update cascade,

  constraint fk_books_created_by
    foreign key (created_by)
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint fk_books_updated_by
    foreign key (updated_by)
    references public.app_user(id)
    on delete set null
    on update cascade
);


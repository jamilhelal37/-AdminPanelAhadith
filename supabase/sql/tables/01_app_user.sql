create table if not exists public.app_user (
  id uuid primary key,
  name text,
  email text not null unique,
  avatar_url text,
  is_activated boolean not null default false,
  gender public.gender,
  type public.user_type not null default 'member',
  birth_date date,
  created_at timestamptz not null default now(),
  updated_at timestamptz default now(),

  constraint fk_app_user_auth
    foreign key (id)
    references auth.users(id)
    on delete cascade
    on update cascade
);


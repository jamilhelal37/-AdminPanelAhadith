-- ============================
-- INITIAL SCHEMA (SUPABASE)
-- ============================

create extension if not exists "pgcrypto";

-- ============================
-- ENUM TYPES
-- ============================

do $$ begin
  create type public.gender as enum ('male', 'female');
exception
  when duplicate_object then null;
end $$;

do $$ begin
  create type public.user_type as enum ('admin', 'member', 'scholar');
exception
  when duplicate_object then null;
end $$;

do $$ begin
  create type public.hadith_type as enum ('marfu', 'mawquf', 'qudsi', 'atharSahaba');
exception
  when duplicate_object then null;
end $$;

-- ============================
-- BASE TABLES
-- ============================

create table if not exists public.ruling (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.muhaddiths (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  gender public.gender not null,
  about text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.rawis (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  gender public.gender not null,
  about text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.explaining (
  id uuid primary key default gen_random_uuid(),
  text text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.books (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  muhaddith uuid null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_books_muhaddith
    foreign key (muhaddith)
    references public.muhaddiths(id)
    on delete set null
    on update cascade
);

create table if not exists public.topics (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.app_user (
  id uuid primary key,
  name text,
  email text not null unique,
  avatar_url text,
  is_activated boolean not null default true,
  gender public.gender,
  type public.user_type,
  birth_date date,
  created_at timestamptz not null default now(),
  updated_at timestamptz default now(),

  constraint fk_app_user_auth
    foreign key (id)
    references auth.users(id)
    on delete cascade
    on update cascade
);

-- ============================
-- AHADITH TABLES
-- ============================

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
    on update cascade
);

create table if not exists public.fake_ahadith (
  id uuid primary key default gen_random_uuid(),
  sub_valid uuid null,
  text text not null,
  normal_text text,
  search_text text,
  ruling uuid null,
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
    on update cascade
);

-- ============================
-- USER INTERACTION TABLES
-- ============================

create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  hadith uuid null,
  "user" uuid null,
  text text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_comments_hadith
    foreign key (hadith)
    references public.ahadith(id)
    on delete set null
    on update cascade,

  constraint fk_comments_user
    foreign key ("user")
    references public.app_user(id)
    on delete set null
    on update cascade
);

create table if not exists public.favorite (
  id uuid primary key default gen_random_uuid(),
  "user" uuid null,
  hadith uuid null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_favorite_user
    foreign key ("user")
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint fk_favorite_hadith
    foreign key (hadith)
    references public.ahadith(id)
    on delete set null
    on update cascade
);

create table if not exists public.questions (
  id uuid primary key default gen_random_uuid(),
  asker uuid null,
  asker_text text not null,
  is_active boolean not null default false,
  answer_text text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_questions_asker
    foreign key (asker)
    references public.app_user(id)
    on delete set null
    on update cascade
);

create table if not exists public.search_history (
  id uuid primary key default gen_random_uuid(),
  "user" uuid null,
  search_text text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_search_history_user
    foreign key ("user")
    references public.app_user(id)
    on delete set null
    on update cascade
);

-- ============================
-- RELATION TABLES
-- ============================

create table if not exists public.similar_ahadith (
  id uuid primary key default gen_random_uuid(),
  main_hadith uuid null,
  sim_hadith uuid null,
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
    on update cascade
);

create table if not exists public.topic_class (
  id uuid primary key default gen_random_uuid(),
  topic uuid null,
  hadith uuid null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_topic_class_topic
    foreign key (topic)
    references public.topics(id)
    on delete set null
    on update cascade,

  constraint fk_topic_class_hadith
    foreign key (hadith)
    references public.ahadith(id)
    on delete set null
    on update cascade
);

-- ============================
-- INDEXES
-- ============================

create index if not exists idx_books_muhaddith on public.books(muhaddith);
create index if not exists idx_ahadith_sub_valid on public.ahadith(sub_valid);
create index if not exists idx_ahadith_explaining on public.ahadith(explaining);
create index if not exists idx_ahadith_muhaddith_ruling on public.ahadith(muhaddith_ruling);
create index if not exists idx_ahadith_final_ruling on public.ahadith(final_ruling);
create index if not exists idx_ahadith_rawi on public.ahadith(rawi);
create index if not exists idx_ahadith_source on public.ahadith(source);
create index if not exists idx_ahadith_search_text on public.ahadith(search_text);
create index if not exists idx_fake_ahadith_sub_valid on public.fake_ahadith(sub_valid);
create index if not exists idx_fake_ahadith_ruling on public.fake_ahadith(ruling);
create index if not exists idx_fake_ahadith_search_text on public.fake_ahadith(search_text);
create index if not exists idx_comments_hadith on public.comments(hadith);
create index if not exists idx_comments_user on public.comments("user");
create index if not exists idx_favorite_user on public.favorite("user");
create index if not exists idx_favorite_hadith on public.favorite(hadith);
create index if not exists idx_questions_asker on public.questions(asker);
create index if not exists idx_search_history_user on public.search_history("user");
create index if not exists idx_similar_ahadith_main on public.similar_ahadith(main_hadith);
create index if not exists idx_similar_ahadith_sim on public.similar_ahadith(sim_hadith);
create index if not exists idx_topic_class_topic on public.topic_class(topic);
create index if not exists idx_topic_class_hadith on public.topic_class(hadith);

-- ========================================
-- Auto-generated unified SQL execution script
-- Order: tables (and indexes) -> functions -> storage -> triggers -> policies
-- Generated on: 2026-03-23 11:01:44
-- ========================================

-- ========================================
-- SECTION: tables
-- ========================================

-- FILE: tables\00_extensions_and_types.sql

create extension if not exists "pgcrypto";
create extension if not exists "pg_trgm";

do $$
begin
  if not exists (
    select 1
    from pg_extension
    where extname = 'pg_net'
  ) and exists (
    select 1
    from pg_namespace
    where nspname = 'net'
  ) then
    execute 'drop schema net cascade';
  end if;
end
$$;

create extension if not exists "pg_net";

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

-- FILE: tables\01_app_user.sql

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


-- FILE: tables\01_ruling.sql

create table if not exists public.ruling (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_ruling_created_by
    foreign key (created_by)
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint fk_ruling_updated_by
    foreign key (updated_by)
    references public.app_user(id)
    on delete set null
    on update cascade
);


-- FILE: tables\02_muhaddiths.sql

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



-- FILE: tables\03_rawis.sql

create table if not exists public.rawis (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  gender public.gender not null,
  about text not null,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_rawis_created_by
    foreign key (created_by)
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint fk_rawis_updated_by
    foreign key (updated_by)
    references public.app_user(id)
    on delete set null
    on update cascade
);


-- FILE: tables\04_explaining.sql

create table if not exists public.explaining (
  id uuid primary key default gen_random_uuid(),
  text text not null,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_explaining_created_by
    foreign key (created_by)
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint fk_explaining_updated_by
    foreign key (updated_by)
    references public.app_user(id)
    on delete set null
    on update cascade
);


-- FILE: tables\05_books.sql

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


-- FILE: tables\06_topics.sql

create table if not exists public.topics (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_topics_created_by
    foreign key (created_by)
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint fk_topics_updated_by
    foreign key (updated_by)
    references public.app_user(id)
    on delete set null
    on update cascade
);



-- FILE: tables\08_ahadith.sql

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



-- FILE: tables\09_fake_ahadith.sql

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



-- FILE: tables\10_comments.sql

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


-- FILE: tables\11_favorite.sql

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

-- FILE: tables\12_questions.sql

create table if not exists public.questions (
  id uuid primary key default gen_random_uuid(),
  asker uuid not null,
  asker_text text not null,
  is_active boolean not null default false,
  answer_text text,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_questions_asker
    foreign key (asker)
    references public.app_user(id)
    on delete cascade
    on update cascade,


  constraint fk_questions_updated_by
    foreign key (updated_by)
    references public.app_user(id)
    on delete set null
    on update cascade
);


-- FILE: tables\13_search_history.sql

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

-- FILE: tables\14_similar_ahadith.sql

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

-- FILE: tables\15_topic_class.sql

create table if not exists public.topic_class (
  id uuid primary key default gen_random_uuid(),
  topic uuid null,
  hadith uuid null,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_topic_class_topic
    foreign key (topic)
    references public.topics(id)
    on delete cascade
    on update cascade,

  constraint fk_topic_class_hadith
    foreign key (hadith)
    references public.ahadith(id)
    on delete cascade
    on update cascade,

  constraint fk_topic_class_created_by
    foreign key (created_by)
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint fk_topic_class_updated_by
    foreign key (updated_by)
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint uq_topic_class_topic_hadith unique (topic, hadith)
);


-- FILE: tables\16_admin_audit_log.sql

create table if not exists public.admin_audit_log (
  id uuid primary key default gen_random_uuid(),
  table_name text not null,
  operation text not null check (operation in ('INSERT', 'UPDATE', 'DELETE')),
  record_id uuid,
  actor_user_id uuid,
  old_data jsonb,
  new_data jsonb,
  created_at timestamptz not null default now()
);

-- FILE: tables\17_pro_upgrade_requests.sql


create table if not exists public.pro_upgrade_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  status text not null default 'pending_documents',
  created_at timestamptz not null default now(),  
  constraint fk_pro_upgrade_requests_user_id foreign key (user_id) 
    references public.app_user(id) on delete cascade,
  constraint chk_pro_upgrade_requests_status
    check (
      status in ('pending_documents', 'under_review', 'reviewed')
    )
);

create unique index if not exists uq_pro_upgrade_requests_user_active
  on public.pro_upgrade_requests(user_id)
  where status <> 'reviewed';

-- FILE: tables\18_pro_upgrade_certificates.sql


create table if not exists public.pro_upgrade_certificates (
  id uuid primary key default gen_random_uuid(),
  request_id uuid not null,
  file_path text not null,
  created_at timestamptz not null default now(),
  

  constraint fk_pro_upgrade_certificates_request_id foreign key (request_id)
    references public.pro_upgrade_requests(id) on delete cascade

);

-- FILE: tables\19_pro_upgrade_decisions.sql


create table if not exists public.pro_upgrade_decisions (
  id uuid primary key default gen_random_uuid(),
  request_id uuid not null ,
  user_id uuid not null ,
  approved boolean not null ,
  reviewed_by uuid  null,
  notes text ,
  created_at timestamptz not null default now(),
  
  constraint fk_pro_upgrade_decisions_request_id foreign key (request_id) 
    references public.pro_upgrade_requests(id) on delete restrict,
  constraint fk_pro_upgrade_decisions_user_id foreign key (user_id) 
    references public.app_user(id) on delete set null,
  constraint fk_pro_upgrade_decisions_reviewed_by foreign key (reviewed_by) 
    references public.app_user(id) on delete set null,

  constraint uq_pro_upgrade_decisions_req_user unique (request_id, user_id)
);

-- FILE: tables\99_enable_realtime.sql

-- Enable Realtime for all public tables and storage.objects.
do $$
declare
  v_table record;
begin
  if not exists (
    select 1
    from pg_publication
    where pubname = 'supabase_realtime'
  ) then
    raise notice 'Publication supabase_realtime does not exist. Skipping realtime setup.';
    return;
  end if;

  -- Add every public base table to supabase_realtime if not already added.
  for v_table in
    select t.table_name
    from information_schema.tables t
    where t.table_schema = 'public'
      and t.table_type = 'BASE TABLE'
  loop
    if not exists (
      select 1
      from pg_publication_tables p
      where p.pubname = 'supabase_realtime'
        and p.schemaname = 'public'
        and p.tablename = v_table.table_name
    ) then
      execute format(
        'alter publication supabase_realtime add table public.%I',
        v_table.table_name
      );
    end if;
  end loop;

  -- Add storage.objects (used for bucket file events) if not already added.
  if not exists (
    select 1
    from pg_publication_tables p
    where p.pubname = 'supabase_realtime'
      and p.schemaname = 'storage'
      and p.tablename = 'objects'
  ) then
    execute 'alter publication supabase_realtime add table storage.objects';
  end if;
end;
$$;

-- FILE: indexes\01_all_indexes.sql

create index if not exists idx_books_muhaddith on public.books(muhaddith);

create index if not exists idx_ahadith_sub_valid on public.ahadith(sub_valid);
create index if not exists idx_ahadith_explaining on public.ahadith(explaining);
create index if not exists idx_ahadith_muhaddith_ruling on public.ahadith(muhaddith_ruling);
create index if not exists idx_ahadith_final_ruling on public.ahadith(final_ruling);
create index if not exists idx_ahadith_rawi on public.ahadith(rawi);
create index if not exists idx_ahadith_source on public.ahadith(source);
create index if not exists idx_ahadith_search_text on public.ahadith(search_text);
create index if not exists idx_ahadith_search_text_trgm on public.ahadith using gin (search_text gin_trgm_ops);

create index if not exists idx_fake_ahadith_sub_valid on public.fake_ahadith(sub_valid);
create index if not exists idx_fake_ahadith_ruling on public.fake_ahadith(ruling);
create index if not exists idx_fake_ahadith_search_text on public.fake_ahadith(search_text);
create index if not exists idx_fake_ahadith_search_text_trgm on public.fake_ahadith using gin (search_text gin_trgm_ops);

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

create index if not exists idx_search_history_ishadith on public.search_history(ishadith);

create index if not exists idx_ruling_created_by on public.ruling(created_by);
create index if not exists idx_ruling_updated_by on public.ruling(updated_by);
create index if not exists idx_muhaddiths_created_by on public.muhaddiths(created_by);
create index if not exists idx_muhaddiths_updated_by on public.muhaddiths(updated_by);
create index if not exists idx_rawis_created_by on public.rawis(created_by);
create index if not exists idx_rawis_updated_by on public.rawis(updated_by);
create index if not exists idx_explaining_created_by on public.explaining(created_by);
create index if not exists idx_explaining_updated_by on public.explaining(updated_by);
create index if not exists idx_books_created_by on public.books(created_by);
create index if not exists idx_books_updated_by on public.books(updated_by);
create index if not exists idx_topics_created_by on public.topics(created_by);
create index if not exists idx_topics_updated_by on public.topics(updated_by);
create index if not exists idx_ahadith_created_by on public.ahadith(created_by);
create index if not exists idx_ahadith_updated_by on public.ahadith(updated_by);
create index if not exists idx_fake_ahadith_created_by on public.fake_ahadith(created_by);
create index if not exists idx_fake_ahadith_updated_by on public.fake_ahadith(updated_by);
create index if not exists idx_questions_updated_by on public.questions(updated_by);
create index if not exists idx_similar_ahadith_created_by on public.similar_ahadith(created_by);
create index if not exists idx_similar_ahadith_updated_by on public.similar_ahadith(updated_by);
create index if not exists idx_topic_class_created_by on public.topic_class(created_by);
create index if not exists idx_topic_class_updated_by on public.topic_class(updated_by);

create index if not exists idx_admin_audit_log_table_name on public.admin_audit_log(table_name);
create index if not exists idx_admin_audit_log_record_id on public.admin_audit_log(record_id);
create index if not exists idx_admin_audit_log_actor on public.admin_audit_log(actor_user_id);
create index if not exists idx_admin_audit_log_created_at on public.admin_audit_log(created_at);

-- Pro Upgrade System Indexes
create index if not exists idx_pro_upgrade_requests_user_id on public.pro_upgrade_requests(user_id);
create index if not exists idx_pro_upgrade_requests_created_at on public.pro_upgrade_requests(created_at);
create index if not exists idx_pro_upgrade_requests_status_created_at on public.pro_upgrade_requests(status, created_at desc);

create index if not exists idx_pro_upgrade_certificates_request_id on public.pro_upgrade_certificates(request_id);
create index if not exists idx_pro_upgrade_certificates_created_at on public.pro_upgrade_certificates(created_at);

create index if not exists idx_pro_upgrade_decisions_user_id on public.pro_upgrade_decisions(user_id);
create index if not exists idx_pro_upgrade_decisions_reviewed_by on public.pro_upgrade_decisions(reviewed_by);
create index if not exists idx_pro_upgrade_decisions_approved on public.pro_upgrade_decisions(approved);
create index if not exists idx_pro_upgrade_decisions_created_at on public.pro_upgrade_decisions(created_at);

-- ========================================
-- SECTION: functions
-- ========================================

-- FILE: functions\01_set_updated_at.sql

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
	new.updated_at = now();
	return new;
end;
$$;


-- FILE: functions\02_update_updated_at_column.sql


create or replace function public.update_updated_at_column()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- FILE: functions\03_handle_new_user.sql

-- Create a function to handle new user signup
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.app_user (id, email, is_activated)
  values (new.id, new.email, true)
  on conflict (id) do nothing;
  return new;
end;
$$;

-- FILE: functions\04_is_admin.sql

-- Create a function to check if the user is an admin
create or replace function public.is_admin()
returns boolean
language plpgsql
security definer set search_path = public
as $$
begin
  return exists (
    select 1
    from public.app_user
    where id = auth.uid() and type = 'admin'
  );
end;
$$;

-- FILE: functions\05_set_row_user_stamps.sql

create or replace function public.set_row_user_stamps()
returns trigger
language plpgsql
as $$
begin
  if tg_op = 'INSERT' then
    if new.created_by is null then
      new.created_by = auth.uid();
    end if;
    if new.updated_by is null then
      new.updated_by = auth.uid();
    end if;
  elsif tg_op = 'UPDATE' then
    new.updated_by = auth.uid();
  end if;

  return new;
end;
$$;

-- FILE: functions\06_log_admin_audit.sql

create or replace function public.log_admin_audit()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    insert into public.admin_audit_log(table_name, operation, record_id, actor_user_id, old_data, new_data)
    values (tg_table_name, tg_op, new.id, auth.uid(), null, to_jsonb(new));
    return new;
  elsif tg_op = 'UPDATE' then
    insert into public.admin_audit_log(table_name, operation, record_id, actor_user_id, old_data, new_data)
    values (tg_table_name, tg_op, new.id, auth.uid(), to_jsonb(old), to_jsonb(new));
    return new;
  elsif tg_op = 'DELETE' then
    insert into public.admin_audit_log(table_name, operation, record_id, actor_user_id, old_data, new_data)
    values (tg_table_name, tg_op, old.id, auth.uid(), to_jsonb(old), null);
    return old;
  end if;

  return null;
end;
$$;

-- FILE: functions\07_arabic_text_normalization.sql

-- Arabic text normalization helpers
-- 1) normalize_arabic_diacritics: remove tashkeel only
-- 2) normalize_arabic_search_text: remove tashkeel, normalize hamza/alef, remove punctuation, collapse spaces

create or replace function public.normalize_arabic_diacritics(p_text text)
returns text
language plpgsql
immutable
as $$
declare
  v_text text;
begin
  if p_text is null then
    return null;
  end if;

  v_text := p_text;

  -- Remove Arabic diacritics, Quranic marks, and tatweel.
  v_text := translate(
    v_text,
    U&'\0610\0611\0612\0613\0614\0615\0616\0617\0618\0619\061A\064B\064C\064D\064E\064F\0650\0651\0652\0653\0654\0655\0656\0657\0658\0659\065A\065B\065C\065D\065E\065F\0670\06D6\06D7\06D8\06D9\06DA\06DB\06DC\06DF\06E0\06E1\06E2\06E3\06E4\06E7\06E8\06EA\06EB\06EC\06ED\0640',
    ''
  );

  return v_text;
end;
$$;

create or replace function public.normalize_arabic_search_text(p_text text)
returns text
language plpgsql
immutable
as $$
declare
  v_text text;
begin
  if p_text is null then
    return null;
  end if;

  v_text := public.normalize_arabic_diacritics(p_text);

  -- Normalize alef variants.
  v_text := replace(v_text, U&'\0623', U&'\0627');
  v_text := replace(v_text, U&'\0625', U&'\0627');
  v_text := replace(v_text, U&'\0622', U&'\0627');
  v_text := replace(v_text, U&'\0671', U&'\0627');

  -- Remove/normalize hamza-bearing letters.
  v_text := replace(v_text, U&'\0624', U&'\0648');
  v_text := replace(v_text, U&'\0626', U&'\064A');
  v_text := replace(v_text, U&'\0621', '');

  -- Remove punctuation (Arabic + generic punctuation), keep letters/digits/spaces.
  v_text := regexp_replace(v_text, '[[:punct:]]', ' ', 'g');

  -- Normalize spaces.
  v_text := regexp_replace(v_text, '\s+', ' ', 'g');
  v_text := btrim(v_text);

  return v_text;
end;
$$;

-- FILE: functions\08_create_pro_upgrade_request.sql

-- Create Pro Upgrade Request with ordered flow
-- 1. User creates request
-- 2. Uploads certificates
-- 3. Request moves to under_review
-- 4. Supervisor reviews request
create or replace function public.create_pro_upgrade_request(
  p_user_id uuid
)
returns json as $$
declare
  v_request_id uuid;
  v_existing_id uuid;
  v_existing_status text;
begin
  -- Check if user already has an active request
  select id, status
    into v_existing_id, v_existing_status
  from public.pro_upgrade_requests
  where user_id = p_user_id
    and status <> 'reviewed'
  order by created_at desc
  limit 1;

  if v_existing_id is not null then
    return json_build_object(
      'request_id', v_existing_id,
      'status', v_existing_status,
      'need_certificates', v_existing_status = 'pending_documents',
      'message', 'لديك طلب ترقية نشط بالفعل'
    );
  end if;

  -- Create new request, starts with certificates upload
  insert into public.pro_upgrade_requests (user_id, status)
  values (p_user_id, 'pending_documents')
  returning pro_upgrade_requests.id into v_request_id;

  return json_build_object(
    'request_id', v_request_id,
    'status', 'pending_documents',
    'need_certificates', true,
    'message', 'تم إنشاء الطلب. يرجى رفع الشهادات أولاً.'
  );
exception when others then
  return json_build_object('error', SQLERRM);
end;
$$ language plpgsql security definer;


-- FILE: functions\09_search_ahadith.sql

-- Search function with word-by-word OR matching on normalized text.
-- Input query is normalized exactly like search_text.

create or replace function public.search_ahadith_or_words(
  p_query text,
  p_limit integer default 50,
  p_offset integer default 0
)
returns table (
  id uuid,
  hadith_number integer,
  text text,
  normal_text text,
  search_text text,
  matched_terms integer
)
language plpgsql
stable
as $$
declare
  v_query text;
  v_terms text[];
begin
  v_query := public.normalize_arabic_search_text(p_query);

  if v_query is null or v_query = '' then
    return;
  end if;

  select array_agg(distinct t)
  into v_terms
  from unnest(regexp_split_to_array(v_query, '\s+')) as t
  where char_length(t) > 0;

  if v_terms is null or array_length(v_terms, 1) = 0 then
    return;
  end if;

  return query
  with scored as (
    select
      a.id,
      a.hadith_number,
      a.text,
      a.normal_text,
      a.search_text,
      (
        select count(*)::integer
        from unnest(v_terms) as term
        where a.search_text like '%' || term || '%'
      ) as matched_terms
    from public.ahadith a
  )
  select
    s.id,
    s.hadith_number,
    s.text,
    s.normal_text,
    s.search_text,
    s.matched_terms
  from scored s
  where s.matched_terms > 0
  order by s.matched_terms desc, s.id asc
  limit greatest(coalesce(p_limit, 50), 1)
  offset greatest(coalesce(p_offset, 0), 0);
end;
$$;

-- FILE: functions\10_search_fake_ahadith.sql

-- Search function for fake_ahadith only (separate from ahadith).
-- Word-by-word OR matching on normalized search_text.

create or replace function public.search_fake_ahadith_or_words(
  p_query text,
  p_limit integer default 50,
  p_offset integer default 0
)
returns table (
  id uuid,
  text text,
  normal_text text,
  search_text text,
  matched_terms integer
)
language plpgsql
stable
as $$
declare
  v_query text;
  v_terms text[];
begin
  v_query := public.normalize_arabic_search_text(p_query);

  if v_query is null or v_query = '' then
    return;
  end if;

  select array_agg(distinct t)
  into v_terms
  from unnest(regexp_split_to_array(v_query, '\s+')) as t
  where char_length(t) > 0;

  if v_terms is null or array_length(v_terms, 1) = 0 then
    return;
  end if;

  return query
  with scored as (
    select
      f.id,
      f.text,
      f.normal_text,
      f.search_text,
      (
        select count(*)::integer
        from unnest(v_terms) as term
        where f.search_text like '%' || term || '%'
      ) as matched_terms
    from public.fake_ahadith f
  )
  select
    s.id,
    s.text,
    s.normal_text,
    s.search_text,
    s.matched_terms
  from scored s
  where s.matched_terms > 0
  order by s.matched_terms desc, s.id asc
  limit greatest(coalesce(p_limit, 50), 1)
  offset greatest(coalesce(p_offset, 0), 0);
end;
$$;

-- FILE: functions\11_set_ahadith_text_variants.sql

create or replace function public.set_ahadith_text_variants()
returns trigger
language plpgsql
as $$
begin
	if new.text is null then
		new.normal_text := null;
		new.search_text := null;
		return new;
	end if;

	new.normal_text := public.normalize_arabic_diacritics(new.text);
	new.search_text := public.normalize_arabic_search_text(new.text);

	return new;
end;
$$;

-- FILE: functions\12_set_fake_ahadith_text_variants.sql

create or replace function public.set_fake_ahadith_text_variants()
returns trigger
language plpgsql
as $$
begin
	if new.text is null then
		new.normal_text := null;
		new.search_text := null;
		return new;
	end if;

	new.normal_text := public.normalize_arabic_diacritics(new.text);
	new.search_text := public.normalize_arabic_search_text(new.text);

	return new;
end;
$$;

-- FILE: functions\12b_notify_fake_ahadith_inserted.sql

create or replace function public.notify_fake_ahadith_inserted()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  degree_name text;
  alternative_text text;
  notification_payload jsonb;
begin
  select coalesce(r.name, '')
    into degree_name
  from public.ruling r
  where r.id = new.ruling;

  if new.sub_valid is not null then
    select a.text
      into alternative_text
    from public.ahadith a
    where a.id = new.sub_valid;
  end if;

  notification_payload := jsonb_build_object(
    'fake_ahadith_id', new.id::text,
    'title', 'انتبه حديث منتشر لا يصح',
    'text', coalesce(new.text, ''),
    'degree', coalesce(degree_name, ''),
    'sub_valid_text', nullif(coalesce(alternative_text, ''), '')
  );

  begin
    perform net.http_post(
      url := 'https://nvatwpxmuderxyixjinz.supabase.co/functions/v1/send-fake-ahadith-alert',
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'x-webhook-secret', 'ahadith-fake-ahadith-alert-v1'
      ),
      body := notification_payload
    );
  exception
    when others then
      raise warning 'notify_fake_ahadith_inserted failed for fake_ahadith id %: %', new.id, sqlerrm;
  end;

  return new;
end;
$$;

-- FILE: functions\13_is_scholar.sql

-- Create a function to check if the user is a scholar
create or replace function public.is_scholar()
returns boolean
language plpgsql
security definer set search_path = public
as $$
begin
  return exists (
    select 1
    from public.app_user
    where id = auth.uid() and type = 'scholar'
  );
end;
$$;

-- FILE: functions\14_is_member.sql

-- Create a function to check if the user is a member
create or replace function public.is_member()
returns boolean
language plpgsql
security definer set search_path = public
as $$
begin
  return exists (
    select 1
    from public.app_user
    where id = auth.uid() and type = 'member'
  );
end;
$$;

-- FILE: functions\15_owns_pro_upgrade_request.sql

-- Check whether the current user owns a pro upgrade request
create or replace function public.owns_pro_upgrade_request(p_request_id uuid)
returns boolean
language plpgsql
security definer set search_path = public
as $$
begin
  return exists (
    select 1
    from public.pro_upgrade_requests
    where id = p_request_id
      and user_id = auth.uid()
  );
end;
$$;

-- FILE: functions\16_sync_pro_upgrade_certificate_from_storage.sql

-- Sync uploaded certificate files from Storage into pro_upgrade_certificates
create or replace function public.sync_pro_upgrade_certificate_from_storage()
returns trigger
language plpgsql
security definer set search_path = public, storage
as $$
declare
  v_user_id uuid;
  v_request_id uuid;
begin
  -- Only handle objects in scholar certificates bucket.
  if new.bucket_id <> 'scholar-certificates' then
    return new;
  end if;

  begin
    v_user_id := split_part(new.name, '/', 1)::uuid;
    v_request_id := split_part(new.name, '/', 2)::uuid;
  exception when others then
    -- Ignore invalid paths. Storage upload succeeded, but no DB sync is created.
    return new;
  end;

  if exists (
    select 1
    from public.pro_upgrade_requests pr
    where pr.id = v_request_id
      and pr.user_id = v_user_id
  ) then
    insert into public.pro_upgrade_certificates (request_id, file_path)
    select v_request_id, new.name
    where not exists (
      select 1
      from public.pro_upgrade_certificates c
      where c.request_id = v_request_id
        and c.file_path = new.name
    );
  end if;

  return new;
end;
$$;

-- FILE: functions\17_handle_pro_upgrade_sequence.sql

-- Pro-upgrade submit handler:
-- request -> upload one or more certificates -> submit request -> under_review
create or replace function public.submit_pro_upgrade_request(
  p_request_id uuid
)
returns json
language plpgsql
security definer
as $$
declare
  v_user_id uuid := auth.uid();
  v_status text;
  v_has_certificate boolean;
begin
  if v_user_id is null then
    return json_build_object('error', 'Authentication required.');
  end if;

  select status
    into v_status
  from public.pro_upgrade_requests
  where id = p_request_id
    and user_id = v_user_id;

  if v_status is null then
    return json_build_object('error', 'Request not found or access denied.');
  end if;

  if v_status <> 'pending_documents' then
    return json_build_object(
      'error',
      'Request cannot be submitted in current status.'
    );
  end if;

  select exists (
    select 1
    from public.pro_upgrade_certificates
    where request_id = p_request_id
  ) into v_has_certificate;

  if not v_has_certificate then
    return json_build_object('error', 'Please upload at least one certificate.');
  end if;

  update public.pro_upgrade_requests
  set status = 'under_review'
  where id = p_request_id
    and user_id = v_user_id
    and status = 'pending_documents';

  return json_build_object(
    'request_id', p_request_id,
    'status', 'under_review',
    'message', 'تم إرسال الطلب للمراجعة بنجاح.'
  );
exception when others then
  return json_build_object('error', SQLERRM);
end;
$$;

-- ========================================
-- SECTION: storage
-- ========================================

-- FILE: storage\scholar_certificates_bucket.sql

-- Storage Configuration for Scholar Certificates
-- Create a private storage bucket for scholar certificate uploads

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'scholar-certificates',
  'scholar-certificates',
  false,
  10485760,
  array['image/jpeg', 'image/png', 'application/pdf']
)
on conflict (id) do update
set
  name = excluded.name,
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

-- Suggested path structure: {user_id}/{request_id}/{filename}

-- Related scripts:
-- - Policies: sql/storage/scholar_certificates_bucket_policies.sql
-- - Sync function: sql/functions/16_sync_pro_upgrade_certificate_from_storage.sql
-- - Sync trigger: sql/triggers/18_pro_upgrade_certificates_storage.sql


-- ========================================
-- SECTION: triggers
-- ========================================

-- FILE: triggers\01_ruling.sql

drop trigger if exists trg_ruling_updated_at on public.ruling;
create trigger trg_ruling_updated_at
before update on public.ruling
for each row execute function public.set_updated_at();

-- FILE: triggers\02_muhaddiths.sql

drop trigger if exists trg_muhaddiths_updated_at on public.muhaddiths;
create trigger trg_muhaddiths_updated_at
before update on public.muhaddiths
for each row execute function public.set_updated_at();

-- FILE: triggers\03_rawis.sql

drop trigger if exists trg_rawis_updated_at on public.rawis;
create trigger trg_rawis_updated_at
before update on public.rawis
for each row execute function public.set_updated_at();

-- FILE: triggers\04_explaining.sql

drop trigger if exists trg_explaining_updated_at on public.explaining;
create trigger trg_explaining_updated_at
before update on public.explaining
for each row execute function public.set_updated_at();

-- FILE: triggers\05_books.sql

drop trigger if exists trg_books_updated_at on public.books;
create trigger trg_books_updated_at
before update on public.books
for each row execute function public.set_updated_at();

-- FILE: triggers\06_topics.sql

drop trigger if exists trg_topics_updated_at on public.topics;
create trigger trg_topics_updated_at
before update on public.topics
for each row execute function public.set_updated_at();

-- FILE: triggers\07_app_user.sql

drop trigger if exists trg_app_user_updated_at on public.app_user;
create trigger trg_app_user_updated_at
before update on public.app_user
for each row execute function public.set_updated_at();

-- FILE: triggers\08_ahadith.sql

drop trigger if exists trg_ahadith_updated_at on public.ahadith;
create trigger trg_ahadith_updated_at
before update on public.ahadith
for each row execute function public.set_updated_at();

drop trigger if exists trg_ahadith_text_variants on public.ahadith;
create trigger trg_ahadith_text_variants
before insert or update of text on public.ahadith
for each row execute function public.set_ahadith_text_variants();

-- FILE: triggers\09_fake_ahadith.sql

drop trigger if exists trg_fake_ahadith_updated_at on public.fake_ahadith;
create trigger trg_fake_ahadith_updated_at
before update on public.fake_ahadith
for each row execute function public.set_updated_at();

drop trigger if exists trg_fake_ahadith_text_variants on public.fake_ahadith;
create trigger trg_fake_ahadith_text_variants
before insert or update of text on public.fake_ahadith
for each row execute function public.set_fake_ahadith_text_variants();

drop trigger if exists trg_fake_ahadith_notification on public.fake_ahadith;
create trigger trg_fake_ahadith_notification
after insert on public.fake_ahadith
for each row execute function public.notify_fake_ahadith_inserted();

-- FILE: triggers\10_comments.sql

drop trigger if exists trg_comments_updated_at on public.comments;
create trigger trg_comments_updated_at
before update on public.comments
for each row execute function public.set_updated_at();

-- FILE: triggers\11_favorite.sql

drop trigger if exists trg_favorite_updated_at on public.favorite;
create trigger trg_favorite_updated_at
before update on public.favorite
for each row execute function public.set_updated_at();

-- FILE: triggers\12_questions.sql

drop trigger if exists trg_questions_updated_at on public.questions;
create trigger trg_questions_updated_at
before update on public.questions
for each row execute function public.set_updated_at();

-- FILE: triggers\13_search_history.sql

drop trigger if exists trg_search_history_updated_at on public.search_history;
create trigger trg_search_history_updated_at
before update on public.search_history
for each row execute function public.set_updated_at();

-- FILE: triggers\14_similar_ahadith.sql

drop trigger if exists trg_similar_ahadith_updated_at on public.similar_ahadith;
create trigger trg_similar_ahadith_updated_at
before update on public.similar_ahadith
for each row execute function public.set_updated_at();

-- FILE: triggers\15_topic_class.sql

drop trigger if exists trg_topic_class_updated_at on public.topic_class;
create trigger trg_topic_class_updated_at
before update on public.topic_class
for each row execute function public.set_updated_at();

-- FILE: triggers\16_on_auth_user_created.sql

-- Create the trigger
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- FILE: triggers\17_admin_audit.sql

do $$
declare
  tbl text;

  audit_tables text[] := array[
    'ruling',
    'muhaddiths',
    'rawis',
    'explaining',
    'books',
    'topics',
    'ahadith',
    'fake_ahadith',
    'questions',
    'similar_ahadith',
    'topic_class',
    'pro_upgrade_decisions'
  ];

begin
  foreach tbl in array audit_tables loop
    execute format('drop trigger if exists trg_%I_audit on public.%I', tbl, tbl);
    execute format('create trigger trg_%I_audit after insert or update or delete on public.%I for each row execute function public.log_admin_audit()', tbl, tbl);
  end loop;
end $$;

-- FILE: triggers\18_pro_upgrade_certificates_storage.sql

drop trigger if exists trg_sync_pro_upgrade_certificate_from_storage on storage.objects;
create trigger trg_sync_pro_upgrade_certificate_from_storage
after insert on storage.objects
for each row
execute function public.sync_pro_upgrade_certificate_from_storage();

-- ========================================
-- SECTION: policies
-- ========================================

-- FILE: policies\01_ruling.sql

alter table public.ruling enable row level security;

drop policy if exists ruling_select_all on public.ruling;
create policy ruling_select_all
on public.ruling
for select
to anon, authenticated
using (true);

drop policy if exists ruling_insert_admin on public.ruling;
create policy ruling_insert_admin
on public.ruling
for insert
to authenticated
with check (public.is_admin());

drop policy if exists ruling_update_admin on public.ruling;
create policy ruling_update_admin
on public.ruling
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists ruling_delete_admin on public.ruling;
create policy ruling_delete_admin
on public.ruling
for delete
to authenticated
using (public.is_admin());

-- FILE: policies\02_muhaddiths.sql

alter table public.muhaddiths enable row level security;

drop policy if exists muhaddiths_select_all on public.muhaddiths;
create policy muhaddiths_select_all
on public.muhaddiths
for select
to anon, authenticated
using (true);

drop policy if exists muhaddiths_insert_admin on public.muhaddiths;
create policy muhaddiths_insert_admin
on public.muhaddiths
for insert
to authenticated
with check (public.is_admin());

drop policy if exists muhaddiths_update_admin on public.muhaddiths;
create policy muhaddiths_update_admin
on public.muhaddiths
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists muhaddiths_delete_admin on public.muhaddiths;
create policy muhaddiths_delete_admin
on public.muhaddiths
for delete
to authenticated
using (public.is_admin());

-- FILE: policies\03_rawis.sql

alter table public.rawis enable row level security;

drop policy if exists rawis_select_all on public.rawis;
create policy rawis_select_all
on public.rawis
for select
to anon, authenticated
using (true);

drop policy if exists rawis_insert_admin on public.rawis;
create policy rawis_insert_admin
on public.rawis
for insert
to authenticated
with check (public.is_admin());

drop policy if exists rawis_update_admin on public.rawis;
create policy rawis_update_admin
on public.rawis
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists rawis_delete_admin on public.rawis;
create policy rawis_delete_admin
on public.rawis
for delete
to authenticated
using (public.is_admin());

-- FILE: policies\04_explaining.sql

alter table public.explaining enable row level security;

drop policy if exists explaining_select_all on public.explaining;
create policy explaining_select_all
on public.explaining
for select
to anon, authenticated
using (true);

drop policy if exists explaining_insert_admin on public.explaining;
create policy explaining_insert_admin
on public.explaining
for insert
to authenticated
with check (public.is_admin());

drop policy if exists explaining_update_admin on public.explaining;
create policy explaining_update_admin
on public.explaining
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists explaining_delete_admin on public.explaining;
create policy explaining_delete_admin
on public.explaining
for delete
to authenticated
using (public.is_admin());

-- FILE: policies\05_books.sql

alter table public.books enable row level security;

drop policy if exists books_select_all on public.books;
create policy books_select_all
on public.books
for select
to anon, authenticated
using (true);

drop policy if exists books_insert_admin on public.books;
create policy books_insert_admin
on public.books
for insert
to authenticated
with check (public.is_admin());

drop policy if exists books_update_admin on public.books;
create policy books_update_admin
on public.books
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists books_delete_admin on public.books;
create policy books_delete_admin
on public.books
for delete
to authenticated
using (public.is_admin());

-- FILE: policies\06_topics.sql

alter table public.topics enable row level security;

drop policy if exists topics_select_all on public.topics;
create policy topics_select_all
on public.topics
for select
to anon, authenticated
using (true);

drop policy if exists topics_insert_admin on public.topics;
create policy topics_insert_admin
on public.topics
for insert
to authenticated
with check (public.is_admin());

drop policy if exists topics_update_admin on public.topics;
create policy topics_update_admin
on public.topics
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists topics_delete_admin on public.topics;
create policy topics_delete_admin
on public.topics
for delete
to authenticated
using (public.is_admin());

-- FILE: policies\07_app_user.sql

alter table public.app_user enable row level security;

drop policy if exists app_user_select_all on public.app_user;
create policy app_user_select_all
on public.app_user
for select
to anon, authenticated
using (true);

drop policy if exists app_user_select_own on public.app_user;
create policy app_user_select_own
on public.app_user
for select
to authenticated
using (id = auth.uid());

drop policy if exists app_user_insert_own on public.app_user;
create policy app_user_insert_own
on public.app_user
for insert
to authenticated
with check (id = auth.uid());

drop policy if exists app_user_update_own on public.app_user;
create policy app_user_update_own
on public.app_user
for update
to authenticated
using (id = auth.uid())
with check (id = auth.uid());

drop policy if exists app_user_update_admin on public.app_user;
create policy app_user_update_admin
on public.app_user
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());


-- FILE: policies\08_ahadith.sql

alter table public.ahadith enable row level security;

drop policy if exists ahadith_select_all on public.ahadith;
create policy ahadith_select_all
on public.ahadith
for select
to anon, authenticated
using (true);

drop policy if exists ahadith_insert_admin on public.ahadith;
create policy ahadith_insert_admin
on public.ahadith
for insert
to authenticated
with check (public.is_admin());

drop policy if exists ahadith_update_admin on public.ahadith;
create policy ahadith_update_admin
on public.ahadith
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists ahadith_delete_admin on public.ahadith;
create policy ahadith_delete_admin
on public.ahadith
for delete
to authenticated
using (public.is_admin());

-- FILE: policies\09_fake_ahadith.sql

alter table public.fake_ahadith enable row level security;

drop policy if exists fake_ahadith_select_all on public.fake_ahadith;
create policy fake_ahadith_select_all
on public.fake_ahadith
for select
to anon, authenticated
using (true);

drop policy if exists fake_ahadith_insert_admin on public.fake_ahadith;
create policy fake_ahadith_insert_admin
on public.fake_ahadith
for insert
to authenticated
with check (public.is_admin());

drop policy if exists fake_ahadith_update_admin on public.fake_ahadith;
create policy fake_ahadith_update_admin
on public.fake_ahadith
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists fake_ahadith_delete_admin on public.fake_ahadith;
create policy fake_ahadith_delete_admin
on public.fake_ahadith
for delete
to authenticated
using (public.is_admin());

-- FILE: policies\10_comments.sql

alter table public.comments enable row level security;

drop policy if exists comments_select_all on public.comments;
create policy comments_select_all
on public.comments
for select
to anon, authenticated
using (true);

drop policy if exists comments_insert_own on public.comments;
create policy comments_insert_own
on public.comments
for insert
to authenticated
with check ("user" = auth.uid() and public.is_scholar());

drop policy if exists comments_update_own on public.comments;
create policy comments_update_own
on public.comments
for update
to authenticated
using ("user" = auth.uid())
with check ("user" = auth.uid() and public.is_scholar());

drop policy if exists comments_delete_own on public.comments;
create policy comments_delete_own
on public.comments
for delete
to authenticated
using ("user" = auth.uid())
;


drop policy if exists comments_delete_admin on public.comments;
create policy comments_delete_admin
on public.comments
for delete
to authenticated
using (public.is_admin());


-- FILE: policies\11_favorite.sql

alter table public.favorite enable row level security;

drop policy if exists favorite_select_own on public.favorite;
create policy favorite_select_own
on public.favorite
for select
to authenticated
using ("user" = auth.uid());

drop policy if exists favorite_insert_own on public.favorite;
create policy favorite_insert_own
on public.favorite
for insert
to authenticated
with check ("user" = auth.uid());

drop policy if exists favorite_delete_own on public.favorite;
create policy favorite_delete_own
on public.favorite
for delete
to authenticated
using ("user" = auth.uid());

-- FILE: policies\12_questions.sql

alter table public.questions enable row level security;

drop policy if exists questions_select_all on public.questions;
create policy questions_select_all
on public.questions
for select
to anon, authenticated
using (true);

drop policy if exists questions_insert_own on public.questions;
create policy questions_insert_own
on public.questions
for insert
to authenticated
with check (asker = auth.uid());

drop policy if exists questions_update_own on public.questions;
create policy questions_update_own
on public.questions
for update
to authenticated
using (asker = auth.uid())
with check (asker = auth.uid());

drop policy if exists questions_delete_own on public.questions;
create policy questions_delete_own
on public.questions
for delete
to authenticated
using (asker = auth.uid());

drop policy if exists questions_update_admin on public.questions;
create policy questions_update_admin
on public.questions
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists questions_delete_admin on public.questions;
create policy questions_delete_admin
on public.questions
for delete
to authenticated
using (public.is_admin());

-- FILE: policies\13_search_history.sql

alter table public.search_history enable row level security;

drop policy if exists search_history_select_own on public.search_history;
create policy search_history_select_own
on public.search_history
for select
to authenticated
using ("user" = auth.uid());

drop policy if exists search_history_insert_own on public.search_history;
create policy search_history_insert_own
on public.search_history
for insert
to authenticated
with check ("user" = auth.uid());

drop policy if exists search_history_update_own on public.search_history;
create policy search_history_update_own
on public.search_history
for update
to authenticated
using ("user" = auth.uid())
with check ("user" = auth.uid());

drop policy if exists search_history_delete_own on public.search_history;
create policy search_history_delete_own
on public.search_history
for delete
to authenticated
using ("user" = auth.uid());

-- FILE: policies\14_similar_ahadith.sql

alter table public.similar_ahadith enable row level security;

drop policy if exists similar_ahadith_select_all on public.similar_ahadith;
create policy similar_ahadith_select_all
on public.similar_ahadith
for select
to anon, authenticated
using (true);

drop policy if exists similar_ahadith_insert_admin on public.similar_ahadith;
create policy similar_ahadith_insert_admin
on public.similar_ahadith
for insert
to authenticated
with check (public.is_admin());

drop policy if exists similar_ahadith_update_admin on public.similar_ahadith;
create policy similar_ahadith_update_admin
on public.similar_ahadith
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists similar_ahadith_delete_admin on public.similar_ahadith;
create policy similar_ahadith_delete_admin
on public.similar_ahadith
for delete
to authenticated
using (public.is_admin());

-- FILE: policies\15_topic_class.sql

alter table public.topic_class enable row level security;

drop policy if exists topic_class_select_all on public.topic_class;
create policy topic_class_select_all
on public.topic_class
for select
to anon, authenticated
using (true);

drop policy if exists topic_class_insert_admin on public.topic_class;
create policy topic_class_insert_admin
on public.topic_class
for insert
to authenticated
with check (public.is_admin());

drop policy if exists topic_class_update_admin on public.topic_class;
create policy topic_class_update_admin
on public.topic_class
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists topic_class_delete_admin on public.topic_class;
create policy topic_class_delete_admin
on public.topic_class
for delete
to authenticated
using (public.is_admin());

-- FILE: policies\16_admin_audit_log.sql

alter table public.admin_audit_log enable row level security;

drop policy if exists admin_audit_log_select_admin on public.admin_audit_log;
create policy admin_audit_log_select_admin
on public.admin_audit_log
for select
to authenticated
using (public.is_admin());

-- FILE: policies\17_pro_upgrade_requests.sql


alter table public.pro_upgrade_requests enable row level security;

drop policy if exists pro_upgrade_requests_select_own on public.pro_upgrade_requests;
create policy pro_upgrade_requests_select_own
  on public.pro_upgrade_requests
  for select
  to authenticated
  using (
    user_id =auth.uid() or 
    public.is_admin()
  );

drop policy if exists pro_upgrade_requests_insert_own on public.pro_upgrade_requests;
create policy pro_upgrade_requests_insert_own
  on public.pro_upgrade_requests
  for insert
  to authenticated
  with check (
    user_id = auth.uid() and
    public.is_member()
  );

drop policy if exists pro_upgrade_requests_update_own_or_admin on public.pro_upgrade_requests;
drop policy if exists pro_upgrade_requests_update_admin_only on public.pro_upgrade_requests;
create policy pro_upgrade_requests_update_admin_only
  on public.pro_upgrade_requests
  for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists pro_upgrade_requests_delete_admin on public.pro_upgrade_requests;
create policy pro_upgrade_requests_delete_admin
  on public.pro_upgrade_requests
  for delete
  to authenticated
  using (public.is_admin());

-- FILE: policies\18_pro_upgrade_certificates.sql

alter table public.pro_upgrade_certificates enable row level security;

drop policy if exists pro_upgrade_certificates_select_own on public.pro_upgrade_certificates;
create policy pro_upgrade_certificates_select_own
  on public.pro_upgrade_certificates
  for select
  to authenticated
  using (
    public.owns_pro_upgrade_request(pro_upgrade_certificates.request_id) or
    public.is_admin()
  );

drop policy if exists pro_upgrade_certificates_insert_own on public.pro_upgrade_certificates;
create policy pro_upgrade_certificates_insert_own
  on public.pro_upgrade_certificates
  for insert
  to authenticated
  with check (
    public.owns_pro_upgrade_request(request_id)
    and exists (
      select 1
      from public.pro_upgrade_requests r
      where r.id = request_id
        and r.user_id = auth.uid()
        and r.status = 'pending_documents'
    )
  );

drop policy if exists pro_upgrade_certificates_delete_admin on public.pro_upgrade_certificates;
create policy pro_upgrade_certificates_delete_admin
  on public.pro_upgrade_certificates
  for delete
  to authenticated
  using (public.is_admin());

-- FILE: policies\20_pro_upgrade_decisions.sql

alter table public.pro_upgrade_decisions enable row level security;

drop policy if exists pro_upgrade_decisions_select_all on public.pro_upgrade_decisions;
drop policy if exists pro_upgrade_decisions_select_own_or_admin on public.pro_upgrade_decisions;
create policy pro_upgrade_decisions_select_own_or_admin
  on public.pro_upgrade_decisions
  for select
  to authenticated
  using (
    user_id = auth.uid() or
    public.is_admin()
  );

drop policy if exists pro_upgrade_decisions_insert_admin on public.pro_upgrade_decisions;
create policy pro_upgrade_decisions_insert_admin
  on public.pro_upgrade_decisions
  for insert
  to authenticated
  with check (public.is_admin());

drop policy if exists pro_upgrade_decisions_update_admin on public.pro_upgrade_decisions;
create policy pro_upgrade_decisions_update_admin
  on public.pro_upgrade_decisions
  for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists pro_upgrade_decisions_delete_admin on public.pro_upgrade_decisions;
create policy pro_upgrade_decisions_delete_admin
  on public.pro_upgrade_decisions
  for delete
  to authenticated
  using (public.is_admin());

-- FILE: storage\scholar_certificates_bucket_policies.sql

-- RLS Policies for scholar-certificates bucket on storage.objects

-- Users can upload to their own folder
-- Path format: {user_id}/{request_id}/{filename}
drop policy if exists "scholars-user-upload" on storage.objects;
create policy "scholars-user-upload"
  on storage.objects
  for insert
  with check (
    bucket_id = 'scholar-certificates' and
    (storage.foldername(name))[1]::uuid = auth.uid() and
    public.is_member()
  );

-- Users can view their own files (admins included)
drop policy if exists "scholars-user-view" on storage.objects;
create policy "scholars-user-view"
  on storage.objects
  for select
  using (
    bucket_id = 'scholar-certificates' and
    (
      (storage.foldername(name))[1]::uuid = auth.uid() or
      public.is_admin()
    )
  );

-- Users can delete their own files
drop policy if exists "scholars-user-delete" on storage.objects;
create policy "scholars-user-delete"
  on storage.objects
  for delete
  using (
    bucket_id = 'scholar-certificates' and
    (storage.foldername(name))[1]::uuid = auth.uid()
  );

drop policy if exists "scholars-admin-view" on storage.objects;
-- Admins can delete any files
drop policy if exists "scholars-admin-delete" on storage.objects;
create policy "scholars-admin-delete"
  on storage.objects
  for delete
  using (
    bucket_id = 'scholar-certificates' and
    public.is_admin()
  );


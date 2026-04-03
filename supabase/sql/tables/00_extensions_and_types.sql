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

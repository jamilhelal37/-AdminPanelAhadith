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

drop trigger if exists trg_fake_ahadith_notification on public.fake_ahadith;
create trigger trg_fake_ahadith_notification
after insert on public.fake_ahadith
for each row execute function public.notify_fake_ahadith_inserted();

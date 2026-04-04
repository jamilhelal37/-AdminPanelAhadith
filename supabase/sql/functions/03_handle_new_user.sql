
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

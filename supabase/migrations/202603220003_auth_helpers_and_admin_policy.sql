-- ============================
-- AUTH HELPERS + ADMIN POLICY
-- ============================

-- Function to automatically update updated_at timestamp
create or replace function public.update_updated_at_column()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

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

-- Create trigger on auth.users signup
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- Ensure RLS is enabled and add admin policy
alter table public.app_user enable row level security;

drop policy if exists app_user_select_all on public.app_user;
create policy app_user_select_all
on public.app_user
for select
to anon, authenticated
using (true);

drop policy if exists app_user_update_admin on public.app_user;
create policy app_user_update_admin
on public.app_user
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

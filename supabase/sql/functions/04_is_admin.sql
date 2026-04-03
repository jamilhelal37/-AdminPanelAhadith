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

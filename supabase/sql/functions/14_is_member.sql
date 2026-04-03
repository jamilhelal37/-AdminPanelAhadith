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

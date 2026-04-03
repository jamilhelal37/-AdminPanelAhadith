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


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

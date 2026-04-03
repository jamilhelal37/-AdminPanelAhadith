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

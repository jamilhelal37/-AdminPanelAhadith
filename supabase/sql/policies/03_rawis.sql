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

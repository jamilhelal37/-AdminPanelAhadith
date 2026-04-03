alter table public.ahadith enable row level security;

drop policy if exists ahadith_select_all on public.ahadith;
create policy ahadith_select_all
on public.ahadith
for select
to anon, authenticated
using (true);

drop policy if exists ahadith_insert_admin on public.ahadith;
create policy ahadith_insert_admin
on public.ahadith
for insert
to authenticated
with check (public.is_admin());

drop policy if exists ahadith_update_admin on public.ahadith;
create policy ahadith_update_admin
on public.ahadith
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists ahadith_delete_admin on public.ahadith;
create policy ahadith_delete_admin
on public.ahadith
for delete
to authenticated
using (public.is_admin());

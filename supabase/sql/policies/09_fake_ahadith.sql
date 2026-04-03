alter table public.fake_ahadith enable row level security;

drop policy if exists fake_ahadith_select_all on public.fake_ahadith;
create policy fake_ahadith_select_all
on public.fake_ahadith
for select
to anon, authenticated
using (true);

drop policy if exists fake_ahadith_insert_admin on public.fake_ahadith;
create policy fake_ahadith_insert_admin
on public.fake_ahadith
for insert
to authenticated
with check (public.is_admin());

drop policy if exists fake_ahadith_update_admin on public.fake_ahadith;
create policy fake_ahadith_update_admin
on public.fake_ahadith
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists fake_ahadith_delete_admin on public.fake_ahadith;
create policy fake_ahadith_delete_admin
on public.fake_ahadith
for delete
to authenticated
using (public.is_admin());

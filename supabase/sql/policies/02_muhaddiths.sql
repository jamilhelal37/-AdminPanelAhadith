alter table public.muhaddiths enable row level security;

drop policy if exists muhaddiths_select_all on public.muhaddiths;
create policy muhaddiths_select_all
on public.muhaddiths
for select
to anon, authenticated
using (true);

drop policy if exists muhaddiths_insert_admin on public.muhaddiths;
create policy muhaddiths_insert_admin
on public.muhaddiths
for insert
to authenticated
with check (public.is_admin());

drop policy if exists muhaddiths_update_admin on public.muhaddiths;
create policy muhaddiths_update_admin
on public.muhaddiths
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists muhaddiths_delete_admin on public.muhaddiths;
create policy muhaddiths_delete_admin
on public.muhaddiths
for delete
to authenticated
using (public.is_admin());

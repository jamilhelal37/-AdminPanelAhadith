alter table public.similar_ahadith enable row level security;

drop policy if exists similar_ahadith_select_all on public.similar_ahadith;
create policy similar_ahadith_select_all
on public.similar_ahadith
for select
to anon, authenticated
using (true);

drop policy if exists similar_ahadith_insert_admin on public.similar_ahadith;
create policy similar_ahadith_insert_admin
on public.similar_ahadith
for insert
to authenticated
with check (public.is_admin());

drop policy if exists similar_ahadith_update_admin on public.similar_ahadith;
create policy similar_ahadith_update_admin
on public.similar_ahadith
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists similar_ahadith_delete_admin on public.similar_ahadith;
create policy similar_ahadith_delete_admin
on public.similar_ahadith
for delete
to authenticated
using (public.is_admin());

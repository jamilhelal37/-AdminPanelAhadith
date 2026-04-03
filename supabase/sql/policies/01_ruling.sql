alter table public.ruling enable row level security;

drop policy if exists ruling_select_all on public.ruling;
create policy ruling_select_all
on public.ruling
for select
to anon, authenticated
using (true);

drop policy if exists ruling_insert_admin on public.ruling;
create policy ruling_insert_admin
on public.ruling
for insert
to authenticated
with check (public.is_admin());

drop policy if exists ruling_update_admin on public.ruling;
create policy ruling_update_admin
on public.ruling
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists ruling_delete_admin on public.ruling;
create policy ruling_delete_admin
on public.ruling
for delete
to authenticated
using (public.is_admin());

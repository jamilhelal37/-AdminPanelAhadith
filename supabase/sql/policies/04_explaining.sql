alter table public.explaining enable row level security;

drop policy if exists explaining_select_all on public.explaining;
create policy explaining_select_all
on public.explaining
for select
to anon, authenticated
using (true);

drop policy if exists explaining_insert_admin on public.explaining;
create policy explaining_insert_admin
on public.explaining
for insert
to authenticated
with check (public.is_admin());

drop policy if exists explaining_update_admin on public.explaining;
create policy explaining_update_admin
on public.explaining
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists explaining_delete_admin on public.explaining;
create policy explaining_delete_admin
on public.explaining
for delete
to authenticated
using (public.is_admin());

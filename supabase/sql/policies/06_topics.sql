alter table public.topics enable row level security;

drop policy if exists topics_select_all on public.topics;
create policy topics_select_all
on public.topics
for select
to anon, authenticated
using (true);

drop policy if exists topics_insert_admin on public.topics;
create policy topics_insert_admin
on public.topics
for insert
to authenticated
with check (public.is_admin());

drop policy if exists topics_update_admin on public.topics;
create policy topics_update_admin
on public.topics
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists topics_delete_admin on public.topics;
create policy topics_delete_admin
on public.topics
for delete
to authenticated
using (public.is_admin());

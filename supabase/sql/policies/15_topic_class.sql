alter table public.topic_class enable row level security;

drop policy if exists topic_class_select_all on public.topic_class;
create policy topic_class_select_all
on public.topic_class
for select
to anon, authenticated
using (true);

drop policy if exists topic_class_insert_admin on public.topic_class;
create policy topic_class_insert_admin
on public.topic_class
for insert
to authenticated
with check (public.is_admin());

drop policy if exists topic_class_update_admin on public.topic_class;
create policy topic_class_update_admin
on public.topic_class
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists topic_class_delete_admin on public.topic_class;
create policy topic_class_delete_admin
on public.topic_class
for delete
to authenticated
using (public.is_admin());

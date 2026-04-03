alter table public.comments enable row level security;

drop policy if exists comments_select_all on public.comments;
create policy comments_select_all
on public.comments
for select
to anon, authenticated
using (true);

drop policy if exists comments_insert_own on public.comments;
create policy comments_insert_own
on public.comments
for insert
to authenticated
with check ("user" = auth.uid() and public.is_scholar());

drop policy if exists comments_update_own on public.comments;
create policy comments_update_own
on public.comments
for update
to authenticated
using ("user" = auth.uid())
with check ("user" = auth.uid() and public.is_scholar());

drop policy if exists comments_delete_own on public.comments;
create policy comments_delete_own
on public.comments
for delete
to authenticated
using ("user" = auth.uid())
;


drop policy if exists comments_delete_admin on public.comments;
create policy comments_delete_admin
on public.comments
for delete
to authenticated
using (public.is_admin());


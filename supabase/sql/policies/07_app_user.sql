alter table public.app_user enable row level security;

drop policy if exists app_user_select_all on public.app_user;
create policy app_user_select_all
on public.app_user
for select
to anon, authenticated
using (true);

drop policy if exists app_user_select_own on public.app_user;
create policy app_user_select_own
on public.app_user
for select
to authenticated
using (id = auth.uid());

drop policy if exists app_user_insert_own on public.app_user;
create policy app_user_insert_own
on public.app_user
for insert
to authenticated
with check (id = auth.uid());

drop policy if exists app_user_update_own on public.app_user;
create policy app_user_update_own
on public.app_user
for update
to authenticated
using (id = auth.uid())
with check (id = auth.uid());

drop policy if exists app_user_update_admin on public.app_user;
create policy app_user_update_admin
on public.app_user
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());


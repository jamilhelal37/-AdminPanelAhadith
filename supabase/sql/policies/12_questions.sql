alter table public.questions enable row level security;

drop policy if exists questions_select_all on public.questions;
create policy questions_select_all
on public.questions
for select
to anon, authenticated
using (true);

drop policy if exists questions_insert_own on public.questions;
create policy questions_insert_own
on public.questions
for insert
to authenticated
with check (asker = auth.uid());

drop policy if exists questions_update_own on public.questions;
create policy questions_update_own
on public.questions
for update
to authenticated
using (asker = auth.uid())
with check (asker = auth.uid());

drop policy if exists questions_delete_own on public.questions;
create policy questions_delete_own
on public.questions
for delete
to authenticated
using (asker = auth.uid());

drop policy if exists questions_update_admin on public.questions;
create policy questions_update_admin
on public.questions
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists questions_delete_admin on public.questions;
create policy questions_delete_admin
on public.questions
for delete
to authenticated
using (public.is_admin());

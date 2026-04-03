alter table public.search_history enable row level security;

drop policy if exists search_history_select_own on public.search_history;
create policy search_history_select_own
on public.search_history
for select
to authenticated
using ("user" = auth.uid());

drop policy if exists search_history_insert_own on public.search_history;
create policy search_history_insert_own
on public.search_history
for insert
to authenticated
with check ("user" = auth.uid());

drop policy if exists search_history_update_own on public.search_history;
create policy search_history_update_own
on public.search_history
for update
to authenticated
using ("user" = auth.uid())
with check ("user" = auth.uid());

drop policy if exists search_history_delete_own on public.search_history;
create policy search_history_delete_own
on public.search_history
for delete
to authenticated
using ("user" = auth.uid());

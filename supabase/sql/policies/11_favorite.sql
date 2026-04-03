alter table public.favorite enable row level security;

drop policy if exists favorite_select_own on public.favorite;
create policy favorite_select_own
on public.favorite
for select
to authenticated
using ("user" = auth.uid());

drop policy if exists favorite_insert_own on public.favorite;
create policy favorite_insert_own
on public.favorite
for insert
to authenticated
with check ("user" = auth.uid());

drop policy if exists favorite_delete_own on public.favorite;
create policy favorite_delete_own
on public.favorite
for delete
to authenticated
using ("user" = auth.uid());

alter table public.books enable row level security;

drop policy if exists books_select_all on public.books;
create policy books_select_all
on public.books
for select
to anon, authenticated
using (true);

drop policy if exists books_insert_admin on public.books;
create policy books_insert_admin
on public.books
for insert
to authenticated
with check (public.is_admin());

drop policy if exists books_update_admin on public.books;
create policy books_update_admin
on public.books
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists books_delete_admin on public.books;
create policy books_delete_admin
on public.books
for delete
to authenticated
using (public.is_admin());

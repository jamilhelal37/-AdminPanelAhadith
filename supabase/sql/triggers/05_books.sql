drop trigger if exists trg_books_updated_at on public.books;
create trigger trg_books_updated_at
before update on public.books
for each row execute function public.set_updated_at();

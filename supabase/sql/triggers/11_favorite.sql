drop trigger if exists trg_favorite_updated_at on public.favorite;
create trigger trg_favorite_updated_at
before update on public.favorite
for each row execute function public.set_updated_at();

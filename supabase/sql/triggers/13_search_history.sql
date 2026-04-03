drop trigger if exists trg_search_history_updated_at on public.search_history;
create trigger trg_search_history_updated_at
before update on public.search_history
for each row execute function public.set_updated_at();

drop trigger if exists trg_similar_ahadith_updated_at on public.similar_ahadith;
create trigger trg_similar_ahadith_updated_at
before update on public.similar_ahadith
for each row execute function public.set_updated_at();

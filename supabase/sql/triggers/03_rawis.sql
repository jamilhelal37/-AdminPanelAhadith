drop trigger if exists trg_rawis_updated_at on public.rawis;
create trigger trg_rawis_updated_at
before update on public.rawis
for each row execute function public.set_updated_at();

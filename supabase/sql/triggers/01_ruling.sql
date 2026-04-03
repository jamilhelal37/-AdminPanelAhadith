drop trigger if exists trg_ruling_updated_at on public.ruling;
create trigger trg_ruling_updated_at
before update on public.ruling
for each row execute function public.set_updated_at();

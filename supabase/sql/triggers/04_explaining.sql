drop trigger if exists trg_explaining_updated_at on public.explaining;
create trigger trg_explaining_updated_at
before update on public.explaining
for each row execute function public.set_updated_at();

drop trigger if exists trg_muhaddiths_updated_at on public.muhaddiths;
create trigger trg_muhaddiths_updated_at
before update on public.muhaddiths
for each row execute function public.set_updated_at();

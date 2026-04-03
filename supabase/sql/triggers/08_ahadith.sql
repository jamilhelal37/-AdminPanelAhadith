drop trigger if exists trg_ahadith_updated_at on public.ahadith;
create trigger trg_ahadith_updated_at
before update on public.ahadith
for each row execute function public.set_updated_at();

drop trigger if exists trg_ahadith_text_variants on public.ahadith;
create trigger trg_ahadith_text_variants
before insert or update of text on public.ahadith
for each row execute function public.set_ahadith_text_variants();

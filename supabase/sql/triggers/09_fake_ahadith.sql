drop trigger if exists trg_fake_ahadith_updated_at on public.fake_ahadith;
create trigger trg_fake_ahadith_updated_at
before update on public.fake_ahadith
for each row execute function public.set_updated_at();

drop trigger if exists trg_fake_ahadith_text_variants on public.fake_ahadith;
create trigger trg_fake_ahadith_text_variants
before insert or update of text on public.fake_ahadith
for each row execute function public.set_fake_ahadith_text_variants();

drop trigger if exists trg_fake_ahadith_notification on public.fake_ahadith;
create trigger trg_fake_ahadith_notification
after insert on public.fake_ahadith
for each row execute function public.notify_fake_ahadith_inserted();

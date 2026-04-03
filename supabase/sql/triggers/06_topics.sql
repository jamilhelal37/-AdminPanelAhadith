drop trigger if exists trg_topics_updated_at on public.topics;
create trigger trg_topics_updated_at
before update on public.topics
for each row execute function public.set_updated_at();

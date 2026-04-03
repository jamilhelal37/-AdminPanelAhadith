drop trigger if exists trg_topic_class_updated_at on public.topic_class;
create trigger trg_topic_class_updated_at
before update on public.topic_class
for each row execute function public.set_updated_at();

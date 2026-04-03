drop trigger if exists trg_comments_updated_at on public.comments;
create trigger trg_comments_updated_at
before update on public.comments
for each row execute function public.set_updated_at();

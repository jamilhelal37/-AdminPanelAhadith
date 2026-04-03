drop trigger if exists trg_questions_updated_at on public.questions;
create trigger trg_questions_updated_at
before update on public.questions
for each row execute function public.set_updated_at();

drop trigger if exists trg_app_user_updated_at on public.app_user;
create trigger trg_app_user_updated_at
before update on public.app_user
for each row execute function public.set_updated_at();

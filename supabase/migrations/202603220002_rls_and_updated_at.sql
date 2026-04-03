-- ============================
-- UPDATED_AT TRIGGER + RLS POLICIES
-- ============================

-- Keep updated_at in sync on updates.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ============================
-- TRIGGERS (updated_at)
-- ============================

drop trigger if exists trg_ruling_updated_at on public.ruling;
create trigger trg_ruling_updated_at
before update on public.ruling
for each row execute function public.set_updated_at();

drop trigger if exists trg_muhaddiths_updated_at on public.muhaddiths;
create trigger trg_muhaddiths_updated_at
before update on public.muhaddiths
for each row execute function public.set_updated_at();

drop trigger if exists trg_rawis_updated_at on public.rawis;
create trigger trg_rawis_updated_at
before update on public.rawis
for each row execute function public.set_updated_at();

drop trigger if exists trg_explaining_updated_at on public.explaining;
create trigger trg_explaining_updated_at
before update on public.explaining
for each row execute function public.set_updated_at();

drop trigger if exists trg_books_updated_at on public.books;
create trigger trg_books_updated_at
before update on public.books
for each row execute function public.set_updated_at();

drop trigger if exists trg_topics_updated_at on public.topics;
create trigger trg_topics_updated_at
before update on public.topics
for each row execute function public.set_updated_at();

drop trigger if exists trg_app_user_updated_at on public.app_user;
create trigger trg_app_user_updated_at
before update on public.app_user
for each row execute function public.set_updated_at();

drop trigger if exists trg_ahadith_updated_at on public.ahadith;
create trigger trg_ahadith_updated_at
before update on public.ahadith
for each row execute function public.set_updated_at();

drop trigger if exists trg_fake_ahadith_updated_at on public.fake_ahadith;
create trigger trg_fake_ahadith_updated_at
before update on public.fake_ahadith
for each row execute function public.set_updated_at();

drop trigger if exists trg_comments_updated_at on public.comments;
create trigger trg_comments_updated_at
before update on public.comments
for each row execute function public.set_updated_at();

drop trigger if exists trg_favorite_updated_at on public.favorite;
create trigger trg_favorite_updated_at
before update on public.favorite
for each row execute function public.set_updated_at();

drop trigger if exists trg_questions_updated_at on public.questions;
create trigger trg_questions_updated_at
before update on public.questions
for each row execute function public.set_updated_at();

drop trigger if exists trg_search_history_updated_at on public.search_history;
create trigger trg_search_history_updated_at
before update on public.search_history
for each row execute function public.set_updated_at();

drop trigger if exists trg_similar_ahadith_updated_at on public.similar_ahadith;
create trigger trg_similar_ahadith_updated_at
before update on public.similar_ahadith
for each row execute function public.set_updated_at();

drop trigger if exists trg_topic_class_updated_at on public.topic_class;
create trigger trg_topic_class_updated_at
before update on public.topic_class
for each row execute function public.set_updated_at();

-- ============================
-- ENABLE RLS
-- ============================

alter table public.ruling enable row level security;
alter table public.muhaddiths enable row level security;
alter table public.rawis enable row level security;
alter table public.explaining enable row level security;
alter table public.books enable row level security;
alter table public.topics enable row level security;
alter table public.app_user enable row level security;
alter table public.ahadith enable row level security;
alter table public.fake_ahadith enable row level security;
alter table public.comments enable row level security;
alter table public.favorite enable row level security;
alter table public.questions enable row level security;
alter table public.search_history enable row level security;
alter table public.similar_ahadith enable row level security;
alter table public.topic_class enable row level security;

-- ============================
-- PUBLIC READ POLICIES (anon + authenticated)
-- ============================

drop policy if exists ruling_select_all on public.ruling;
create policy ruling_select_all
on public.ruling
for select
to anon, authenticated
using (true);

drop policy if exists muhaddiths_select_all on public.muhaddiths;
create policy muhaddiths_select_all
on public.muhaddiths
for select
to anon, authenticated
using (true);

drop policy if exists rawis_select_all on public.rawis;
create policy rawis_select_all
on public.rawis
for select
to anon, authenticated
using (true);

drop policy if exists explaining_select_all on public.explaining;
create policy explaining_select_all
on public.explaining
for select
to anon, authenticated
using (true);

drop policy if exists books_select_all on public.books;
create policy books_select_all
on public.books
for select
to anon, authenticated
using (true);

drop policy if exists topics_select_all on public.topics;
create policy topics_select_all
on public.topics
for select
to anon, authenticated
using (true);

drop policy if exists ahadith_select_all on public.ahadith;
create policy ahadith_select_all
on public.ahadith
for select
to anon, authenticated
using (true);

drop policy if exists fake_ahadith_select_all on public.fake_ahadith;
create policy fake_ahadith_select_all
on public.fake_ahadith
for select
to anon, authenticated
using (true);

drop policy if exists similar_ahadith_select_all on public.similar_ahadith;
create policy similar_ahadith_select_all
on public.similar_ahadith
for select
to anon, authenticated
using (true);

drop policy if exists topic_class_select_all on public.topic_class;
create policy topic_class_select_all
on public.topic_class
for select
to anon, authenticated
using (true);

-- ============================
-- app_user POLICIES
-- ============================

drop policy if exists app_user_select_own on public.app_user;
create policy app_user_select_own
on public.app_user
for select
to authenticated
using (id = auth.uid());

drop policy if exists app_user_insert_own on public.app_user;
create policy app_user_insert_own
on public.app_user
for insert
to authenticated
with check (id = auth.uid());

drop policy if exists app_user_update_own on public.app_user;
create policy app_user_update_own
on public.app_user
for update
to authenticated
using (id = auth.uid())
with check (id = auth.uid());

-- ============================
-- comments POLICIES
-- ============================

drop policy if exists comments_select_all on public.comments;
create policy comments_select_all
on public.comments
for select
to anon, authenticated
using (true);

drop policy if exists comments_insert_own on public.comments;
create policy comments_insert_own
on public.comments
for insert
to authenticated
with check ("user" = auth.uid());

drop policy if exists comments_update_own on public.comments;
create policy comments_update_own
on public.comments
for update
to authenticated
using ("user" = auth.uid())
with check ("user" = auth.uid());

drop policy if exists comments_delete_own on public.comments;
create policy comments_delete_own
on public.comments
for delete
to authenticated
using ("user" = auth.uid());

-- ============================
-- favorite POLICIES
-- ============================

drop policy if exists favorite_select_own on public.favorite;
create policy favorite_select_own
on public.favorite
for select
to authenticated
using ("user" = auth.uid());

drop policy if exists favorite_insert_own on public.favorite;
create policy favorite_insert_own
on public.favorite
for insert
to authenticated
with check ("user" = auth.uid());

drop policy if exists favorite_delete_own on public.favorite;
create policy favorite_delete_own
on public.favorite
for delete
to authenticated
using ("user" = auth.uid());

-- ============================
-- questions POLICIES
-- ============================

drop policy if exists questions_select_all on public.questions;
create policy questions_select_all
on public.questions
for select
to anon, authenticated
using (true);

drop policy if exists questions_insert_own on public.questions;
create policy questions_insert_own
on public.questions
for insert
to authenticated
with check (asker = auth.uid());

drop policy if exists questions_update_own on public.questions;
create policy questions_update_own
on public.questions
for update
to authenticated
using (asker = auth.uid())
with check (asker = auth.uid());

drop policy if exists questions_delete_own on public.questions;
create policy questions_delete_own
on public.questions
for delete
to authenticated
using (asker = auth.uid());

-- ============================
-- search_history POLICIES
-- ============================

drop policy if exists search_history_select_own on public.search_history;
create policy search_history_select_own
on public.search_history
for select
to authenticated
using ("user" = auth.uid());

drop policy if exists search_history_insert_own on public.search_history;
create policy search_history_insert_own
on public.search_history
for insert
to authenticated
with check ("user" = auth.uid());

drop policy if exists search_history_update_own on public.search_history;
create policy search_history_update_own
on public.search_history
for update
to authenticated
using ("user" = auth.uid())
with check ("user" = auth.uid());

drop policy if exists search_history_delete_own on public.search_history;
create policy search_history_delete_own
on public.search_history
for delete
to authenticated
using ("user" = auth.uid());

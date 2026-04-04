alter table public.user_fcm_tokens enable row level security;

drop policy if exists "Users can insert their own tokens" on public.user_fcm_tokens;
create policy "Users can insert their own tokens"
on public.user_fcm_tokens
for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update their own tokens" on public.user_fcm_tokens;
create policy "Users can update their own tokens"
on public.user_fcm_tokens
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "Users can read their own tokens or admin can read all" on public.user_fcm_tokens;
create policy "Users can read their own tokens or admin can read all"
on public.user_fcm_tokens
for select
to authenticated
using (auth.uid() = user_id or public.is_admin());

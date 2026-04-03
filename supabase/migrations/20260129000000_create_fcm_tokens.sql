create table if not exists public.user_fcm_tokens (
    id uuid not null default gen_random_uuid(),
    user_id uuid not null references auth.users(id) on delete cascade,
    fcm_token text not null,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    last_seen timestamptz not null default now(),

    constraint user_fcm_tokens_pkey primary key (id),
    constraint user_fcm_tokens_user_id_fcm_token_key unique (user_id, fcm_token)
);

alter table public.user_fcm_tokens enable row leve
l security;

create policy "Users can insert their own tokens"
on public.user_fcm_tokens
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "Users can update their own tokens"
on public.user_fcm_tokens
for update
to authenticated
using (auth.uid() = user_id);

create policy "Users can read their own tokens or admin can read all"
on public.user_fcm_tokens
for select
to authenticated
using (auth.uid() = user_id or public.is_admin());

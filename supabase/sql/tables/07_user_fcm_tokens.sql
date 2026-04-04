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

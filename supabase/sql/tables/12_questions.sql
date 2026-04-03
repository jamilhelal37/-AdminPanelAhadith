create table if not exists public.questions (
  id uuid primary key default gen_random_uuid(),
  asker uuid not null,
  asker_text text not null,
  is_active boolean not null default false,
  answer_text text,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_questions_asker
    foreign key (asker)
    references public.app_user(id)
    on delete cascade
    on update cascade,


  constraint fk_questions_updated_by
    foreign key (updated_by)
    references public.app_user(id)
    on delete set null
    on update cascade
);


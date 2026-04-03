create table if not exists public.topic_class (
  id uuid primary key default gen_random_uuid(),
  topic uuid null,
  hadith uuid null,
  created_by uuid,
  updated_by uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint fk_topic_class_topic
    foreign key (topic)
    references public.topics(id)
    on delete cascade
    on update cascade,

  constraint fk_topic_class_hadith
    foreign key (hadith)
    references public.ahadith(id)
    on delete cascade
    on update cascade,

  constraint fk_topic_class_created_by
    foreign key (created_by)
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint fk_topic_class_updated_by
    foreign key (updated_by)
    references public.app_user(id)
    on delete set null
    on update cascade,

  constraint uq_topic_class_topic_hadith unique (topic, hadith)
);


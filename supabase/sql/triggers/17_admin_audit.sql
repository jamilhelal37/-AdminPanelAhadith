do $$
declare
  tbl text;

  audit_tables text[] := array[
    'ruling',
    'muhaddiths',
    'rawis',
    'explaining',
    'books',
    'topics',
    'ahadith',
    'fake_ahadith',
    'questions',
    'similar_ahadith',
    'topic_class',
    'pro_upgrade_decisions'
  ];

begin
  foreach tbl in array audit_tables loop
    execute format('drop trigger if exists trg_%I_audit on public.%I', tbl, tbl);
    execute format('create trigger trg_%I_audit after insert or update or delete on public.%I for each row execute function public.log_admin_audit()', tbl, tbl);
  end loop;
end $$;

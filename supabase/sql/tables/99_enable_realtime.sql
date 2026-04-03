-- Enable Realtime for all public tables and storage.objects.
do $$
declare
  v_table record;
begin
  if not exists (
    select 1
    from pg_publication
    where pubname = 'supabase_realtime'
  ) then
    raise notice 'Publication supabase_realtime does not exist. Skipping realtime setup.';
    return;
  end if;

  -- Add every public base table to supabase_realtime if not already added.
  for v_table in
    select t.table_name
    from information_schema.tables t
    where t.table_schema = 'public'
      and t.table_type = 'BASE TABLE'
  loop
    if not exists (
      select 1
      from pg_publication_tables p
      where p.pubname = 'supabase_realtime'
        and p.schemaname = 'public'
        and p.tablename = v_table.table_name
    ) then
      execute format(
        'alter publication supabase_realtime add table public.%I',
        v_table.table_name
      );
    end if;
  end loop;

  -- Add storage.objects (used for bucket file events) if not already added.
  if not exists (
    select 1
    from pg_publication_tables p
    where p.pubname = 'supabase_realtime'
      and p.schemaname = 'storage'
      and p.tablename = 'objects'
  ) then
    execute 'alter publication supabase_realtime add table storage.objects';
  end if;
end;
$$;

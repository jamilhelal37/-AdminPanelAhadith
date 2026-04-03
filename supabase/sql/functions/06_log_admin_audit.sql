create or replace function public.log_admin_audit()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    insert into public.admin_audit_log(table_name, operation, record_id, actor_user_id, old_data, new_data)
    values (tg_table_name, tg_op, new.id, auth.uid(), null, to_jsonb(new));
    return new;
  elsif tg_op = 'UPDATE' then
    insert into public.admin_audit_log(table_name, operation, record_id, actor_user_id, old_data, new_data)
    values (tg_table_name, tg_op, new.id, auth.uid(), to_jsonb(old), to_jsonb(new));
    return new;
  elsif tg_op = 'DELETE' then
    insert into public.admin_audit_log(table_name, operation, record_id, actor_user_id, old_data, new_data)
    values (tg_table_name, tg_op, old.id, auth.uid(), to_jsonb(old), null);
    return old;
  end if;

  return null;
end;
$$;

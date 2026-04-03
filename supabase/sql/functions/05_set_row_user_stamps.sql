create or replace function public.set_row_user_stamps()
returns trigger
language plpgsql
as $$
begin
  if tg_op = 'INSERT' then
    if new.created_by is null then
      new.created_by = auth.uid();
    end if;
    if new.updated_by is null then
      new.updated_by = auth.uid();
    end if;
  elsif tg_op = 'UPDATE' then
    new.updated_by = auth.uid();
  end if;

  return new;
end;
$$;

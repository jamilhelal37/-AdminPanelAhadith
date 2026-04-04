
create or replace function public.sync_pro_upgrade_certificate_from_storage()
returns trigger
language plpgsql
security definer set search_path = public, storage
as $$
declare
  v_user_id uuid;
  v_request_id uuid;
begin
  -- Only handle objects in scholar certificates bucket.
  if new.bucket_id <> 'scholar-certificates' then
    return new;
  end if;

  begin
    v_user_id := split_part(new.name, '/', 1)::uuid;
    v_request_id := split_part(new.name, '/', 2)::uuid;
  exception when others then
    -- Ignore invalid paths. Storage upload succeeded, but no DB sync is created.
    return new;
  end;

  if exists (
    select 1
    from public.pro_upgrade_requests pr
    where pr.id = v_request_id
      and pr.user_id = v_user_id
  ) then
    insert into public.pro_upgrade_certificates (request_id, file_path)
    select v_request_id, new.name
    where not exists (
      select 1
      from public.pro_upgrade_certificates c
      where c.request_id = v_request_id
        and c.file_path = new.name
    );
  end if;

  return new;
end;
$$;




create or replace function public.submit_pro_upgrade_request(
  p_request_id uuid
)
returns json
language plpgsql
security definer
as $$
declare
  v_user_id uuid := auth.uid();
  v_status text;
  v_has_certificate boolean;
begin
  if v_user_id is null then
    return json_build_object('error', 'Authentication required.');
  end if;

  select status
    into v_status
  from public.pro_upgrade_requests
  where id = p_request_id
    and user_id = v_user_id;

  if v_status is null then
    return json_build_object('error', 'Request not found or access denied.');
  end if;

  if v_status <> 'pending_documents' then
    return json_build_object(
      'error',
      'Request cannot be submitted in current status.'
    );
  end if;

  select exists (
    select 1
    from public.pro_upgrade_certificates
    where request_id = p_request_id
  ) into v_has_certificate;

  if not v_has_certificate then
    return json_build_object('error', 'Please upload at least one certificate.');
  end if;

  update public.pro_upgrade_requests
  set status = 'under_review'
  where id = p_request_id
    and user_id = v_user_id
    and status = 'pending_documents';

  return json_build_object(
    'request_id', p_request_id,
    'status', 'under_review',
    'message', 'تم إرسال الطلب للمراجعة بنجاح.'
  );
exception when others then
  return json_build_object('error', SQLERRM);
end;
$$;

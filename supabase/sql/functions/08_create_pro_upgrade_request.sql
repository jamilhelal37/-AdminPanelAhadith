




create or replace function public.create_pro_upgrade_request(
  p_user_id uuid
)
returns json as $$
declare
  v_request_id uuid;
  v_existing_id uuid;
  v_existing_status text;
begin
  -- Check if user already has an active request
  select id, status
    into v_existing_id, v_existing_status
  from public.pro_upgrade_requests
  where user_id = p_user_id
    and status <> 'reviewed'
  order by created_at desc
  limit 1;

  if v_existing_id is not null then
    return json_build_object(
      'request_id', v_existing_id,
      'status', v_existing_status,
      'need_certificates', v_existing_status = 'pending_documents',
      'message', 'لديك طلب ترقية نشط بالفعل'
    );
  end if;

  -- Create new request, starts with certificates upload
  insert into public.pro_upgrade_requests (user_id, status)
  values (p_user_id, 'pending_documents')
  returning pro_upgrade_requests.id into v_request_id;

  return json_build_object(
    'request_id', v_request_id,
    'status', 'pending_documents',
    'need_certificates', true,
    'message', 'تم إنشاء الطلب. يرجى رفع الشهادات أولاً.'
  );
exception when others then
  return json_build_object('error', SQLERRM);
end;
$$ language plpgsql security definer;


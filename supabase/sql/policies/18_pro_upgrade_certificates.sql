alter table public.pro_upgrade_certificates enable row level security;

drop policy if exists pro_upgrade_certificates_select_own on public.pro_upgrade_certificates;
create policy pro_upgrade_certificates_select_own
  on public.pro_upgrade_certificates
  for select
  to authenticated
  using (
    public.owns_pro_upgrade_request(pro_upgrade_certificates.request_id) or
    public.is_admin()
  );

drop policy if exists pro_upgrade_certificates_insert_own on public.pro_upgrade_certificates;
create policy pro_upgrade_certificates_insert_own
  on public.pro_upgrade_certificates
  for insert
  to authenticated
  with check (
    public.owns_pro_upgrade_request(request_id)
    and exists (
      select 1
      from public.pro_upgrade_requests r
      where r.id = request_id
        and r.user_id = auth.uid()
        and r.status = 'pending_documents'
    )
  );

drop policy if exists pro_upgrade_certificates_delete_admin on public.pro_upgrade_certificates;
create policy pro_upgrade_certificates_delete_admin
  on public.pro_upgrade_certificates
  for delete
  to authenticated
  using (public.is_admin());

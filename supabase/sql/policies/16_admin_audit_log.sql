alter table public.admin_audit_log enable row level security;

drop policy if exists admin_audit_log_select_admin on public.admin_audit_log;
create policy admin_audit_log_select_admin
on public.admin_audit_log
for select
to authenticated
using (public.is_admin());

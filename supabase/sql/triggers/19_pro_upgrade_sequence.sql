-- Keep pro-upgrade request status synchronized with submission sequence.

drop trigger if exists trg_handle_pro_upgrade_certificate_insert on public.pro_upgrade_certificates;

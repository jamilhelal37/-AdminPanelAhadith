drop trigger if exists trg_sync_pro_upgrade_certificate_from_storage on storage.objects;
create trigger trg_sync_pro_upgrade_certificate_from_storage
after insert on storage.objects
for each row
execute function public.sync_pro_upgrade_certificate_from_storage();

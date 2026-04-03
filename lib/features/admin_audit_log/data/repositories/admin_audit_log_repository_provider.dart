import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasources/admin_audit_log_supabase_datasource.dart';
import 'admin_audit_log_repository.dart';

final adminAuditLogRepositoryProvider = Provider<AdminAuditLogRepository>((
  ref,
) {
  return AdminAuditLogSupabaseDatasource();
});

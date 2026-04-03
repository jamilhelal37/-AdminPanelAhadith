import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/admin_audit_log_repository_provider.dart';
import '../../domain/models/admin_audit_log.dart';

final adminAuditLogSearchProvider = StateProvider<String>((ref) => '');

final adminAuditLogOperationFilterProvider = StateProvider<String>(
  (ref) => 'الكل',
);

final adminAuditLogTableFilterProvider = StateProvider<String?>((ref) => null);

final adminAuditLogFutureProvider =
    FutureProvider.autoDispose<List<AdminAuditLog>>((ref) async {
      final repo = ref.read(adminAuditLogRepositoryProvider);
      return repo.getAuditLogs();
    });

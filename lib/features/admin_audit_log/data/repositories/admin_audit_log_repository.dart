import '../../domain/models/admin_audit_log.dart';

abstract class AdminAuditLogRepository {
  Future<List<AdminAuditLog>> getAuditLogs();
}

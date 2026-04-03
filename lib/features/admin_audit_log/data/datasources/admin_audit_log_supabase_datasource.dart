import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/models/admin_audit_log.dart';
import '../repositories/admin_audit_log_repository.dart';

class AdminAuditLogSupabaseDatasource implements AdminAuditLogRepository {
  AdminAuditLogSupabaseDatasource({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const String _auditTable = 'admin_audit_log';
  static const String _usersTable = 'app_user';

  @override
  Future<List<AdminAuditLog>> getAuditLogs() async {
    try {
      final response = await _client
          .from(_auditTable)
          .select(
            'id, table_name, operation, record_id, actor_user_id, old_data, new_data, created_at',
          )
          .order('created_at', ascending: false)
          .limit(800);

      final rawRows = (response as List)
          .cast<Map>()
          .map((entry) => entry.cast<String, dynamic>())
          .toList();

      final actorIds = rawRows
          .map((row) => (row['actor_user_id'] ?? '').toString())
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      final usersById = <String, Map<String, dynamic>>{};
      if (actorIds.isNotEmpty) {
        final usersResponse = await _client
            .from(_usersTable)
            .select('id, name, email')
            .inFilter('id', actorIds);

        for (final raw in (usersResponse as List).cast<Map>()) {
          final map = raw.cast<String, dynamic>();
          usersById[(map['id'] ?? '').toString()] = map;
        }
      }

      return rawRows.map((row) {
        final actorId = (row['actor_user_id'] ?? '').toString();
        final user = usersById[actorId];

        return AdminAuditLog.fromJson({
          'id': (row['id'] ?? '').toString(),
          'table_name': (row['table_name'] ?? '').toString(),
          'operation': (row['operation'] ?? '').toString(),
          'record_id': _asNullableString(row['record_id']),
          'actor_user_id': actorId.isEmpty ? null : actorId,
          'actor_name': (user?['name'] ?? '').toString(),
          'actor_email': (user?['email'] ?? '').toString(),
          'old_data': _toMap(row['old_data']),
          'new_data': _toMap(row['new_data']),
          'created_at': (row['created_at'] ?? '').toString(),
        });
      }).toList();
    } on PostgrestException catch (error) {
      throw AppFailure.network(
        'تعذر تحميل سجل نشاط المشرفين.',
        details: error.message,
      );
    } catch (error) {
      throw AppFailure.network(
        'تعذر تحميل سجل نشاط المشرفين.',
        details: error.toString(),
      );
    }
  }

  String? _asNullableString(dynamic value) {
    final text = (value ?? '').toString().trim();
    return text.isEmpty ? null : text;
  }

  Map<String, dynamic>? _toMap(dynamic value) {
    if (value is Map) {
      return value.cast<String, dynamic>();
    }
    return null;
  }
}

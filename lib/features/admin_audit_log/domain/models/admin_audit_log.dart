

import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_audit_log.freezed.dart';
part 'admin_audit_log.g.dart';

@freezed
abstract class AdminAuditLog with _$AdminAuditLog {
  const AdminAuditLog._();

  const factory AdminAuditLog({
    required String id,
    @JsonKey(name: 'table_name') required String tableName,
    required String operation,
    @JsonKey(name: 'record_id') String? recordId,
    @JsonKey(name: 'actor_user_id') String? actorUserId,
    @Default('') @JsonKey(name: 'actor_name') String actorName,
    @Default('') @JsonKey(name: 'actor_email') String actorEmail,
    @JsonKey(name: 'old_data') Map<String, dynamic>? oldData,
    @JsonKey(name: 'new_data') Map<String, dynamic>? newData,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _AdminAuditLog;

  factory AdminAuditLog.fromJson(Map<String, dynamic> json) =>
      _$AdminAuditLogFromJson(json);

  String get actorDisplay {
    if (actorName.trim().isNotEmpty) {
      return actorName.trim();
    }
    if (actorEmail.trim().isNotEmpty) {
      return actorEmail.trim();
    }
    final actorId = actorUserId?.trim();
    if (actorId != null && actorId.isNotEmpty) {
      return _shortId(actorId);
    }
    return '-';
  }

  String get actorSubline {
    if (actorEmail.trim().isNotEmpty) {
      return actorEmail.trim();
    }
    return actorUserId?.trim().isNotEmpty == true ? actorUserId!.trim() : '-';
  }

  String get operationArabic {
    switch (operation.toUpperCase()) {
      case 'INSERT':
        return 'إضافة';
      case 'UPDATE':
        return 'تحديث';
      case 'DELETE':
        return 'حذف';
      default:
        return operation;
    }
  }

  String get detailsSummary {
    final op = operation.toUpperCase();
    if (op == 'INSERT') {
      return 'تم إنشاء سجل جديد';
    }
    if (op == 'DELETE') {
      return 'تم حذف السجل';
    }

    final before = oldData;
    final after = newData;
    if (before == null || after == null) {
      return 'تم تعديل السجل';
    }

    final changedKeys = <String>[];
    final keys = <String>{...before.keys, ...after.keys};
    for (final key in keys) {
      if (before[key] != after[key]) {
        changedKeys.add(key);
      }
    }

    if (changedKeys.isEmpty) {
      return 'تم تعديل السجل';
    }

    final preview = changedKeys.take(3).join('، ');
    if (changedKeys.length <= 3) {
      return 'تم تعديل الحقول: $preview';
    }
    return 'تم تعديل ${changedKeys.length} حقول: $preview...';
  }

  String get shortRecordId {
    final value = recordId?.trim();
    if (value == null || value.isEmpty) {
      return '-';
    }
    return _shortId(value);
  }

  String get createdAtShort {
    final parsed = DateTime.tryParse(createdAt);
    if (parsed == null) {
      return createdAt;
    }
    final month = parsed.month.toString().padLeft(2, '0');
    final day = parsed.day.toString().padLeft(2, '0');
    final hour = parsed.hour.toString().padLeft(2, '0');
    final minute = parsed.minute.toString().padLeft(2, '0');
    return '${parsed.year}/$month/$day - $hour:$minute';
  }

  static String _shortId(String value) {
    if (value.length <= 8) {
      return value;
    }
    return '${value.substring(0, 8)}...';
  }
}

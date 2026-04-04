// ignore_for_file: type=lint, type=warning



part of 'admin_audit_log.dart';





_AdminAuditLog _$AdminAuditLogFromJson(Map<String, dynamic> json) =>
    _AdminAuditLog(
      id: json['id'] as String,
      tableName: json['table_name'] as String,
      operation: json['operation'] as String,
      recordId: json['record_id'] as String?,
      actorUserId: json['actor_user_id'] as String?,
      actorName: json['actor_name'] as String? ?? '',
      actorEmail: json['actor_email'] as String? ?? '',
      oldData: json['old_data'] as Map<String, dynamic>?,
      newData: json['new_data'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$AdminAuditLogToJson(_AdminAuditLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'table_name': instance.tableName,
      'operation': instance.operation,
      'record_id': instance.recordId,
      'actor_user_id': instance.actorUserId,
      'actor_name': instance.actorName,
      'actor_email': instance.actorEmail,
      'old_data': instance.oldData,
      'new_data': instance.newData,
      'created_at': instance.createdAt,
    };

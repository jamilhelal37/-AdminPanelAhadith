// ignore_for_file: type=lint, type=warning



part of 'pro_upgrade_request.dart';





_ProUpgradeRequest _$ProUpgradeRequestFromJson(Map<String, dynamic> json) =>
    _ProUpgradeRequest(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      status: json['status'] as String? ?? 'pending_documents',
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$ProUpgradeRequestToJson(_ProUpgradeRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'status': instance.status,
      'created_at': instance.createdAt,
    };

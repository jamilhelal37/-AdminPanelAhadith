// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_upgrade_decision.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProUpgradeDecision _$ProUpgradeDecisionFromJson(Map<String, dynamic> json) =>
    _ProUpgradeDecision(
      id: json['id'] as String?,
      requestId: json['request_id'] as String,
      userId: json['user_id'] as String,
      approved: json['approved'] as bool,
      reviewedBy: json['reviewed_by'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$ProUpgradeDecisionToJson(_ProUpgradeDecision instance) =>
    <String, dynamic>{
      'id': instance.id,
      'request_id': instance.requestId,
      'user_id': instance.userId,
      'approved': instance.approved,
      'reviewed_by': instance.reviewedBy,
      'notes': instance.notes,
      'created_at': instance.createdAt,
    };

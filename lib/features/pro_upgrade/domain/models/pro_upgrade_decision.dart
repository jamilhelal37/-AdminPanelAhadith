

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pro_upgrade_decision.freezed.dart';
part 'pro_upgrade_decision.g.dart';

@freezed
abstract class ProUpgradeDecision with _$ProUpgradeDecision {
  const factory ProUpgradeDecision({
    String? id,
    @JsonKey(name: 'request_id') required String requestId,
    @JsonKey(name: 'user_id') required String userId,
    required bool approved,
    @JsonKey(name: 'reviewed_by') String? reviewedBy,
    String? notes,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _ProUpgradeDecision;

  factory ProUpgradeDecision.fromJson(Map<String, dynamic> json) =>
      _$ProUpgradeDecisionFromJson(json);
}

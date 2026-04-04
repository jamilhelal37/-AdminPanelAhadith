

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pro_upgrade_request.freezed.dart';
part 'pro_upgrade_request.g.dart';

@freezed
abstract class ProUpgradeRequest with _$ProUpgradeRequest {
  const factory ProUpgradeRequest({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    @Default('pending_documents') String status,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _ProUpgradeRequest;

  factory ProUpgradeRequest.fromJson(Map<String, dynamic> json) =>
      _$ProUpgradeRequestFromJson(json);
}

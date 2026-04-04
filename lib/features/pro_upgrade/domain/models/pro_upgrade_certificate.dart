

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pro_upgrade_certificate.freezed.dart';
part 'pro_upgrade_certificate.g.dart';

@freezed
abstract class ProUpgradeCertificate with _$ProUpgradeCertificate {
  const factory ProUpgradeCertificate({
    String? id,
    @JsonKey(name: 'request_id') required String requestId,
    @JsonKey(name: 'file_path') required String filePath,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _ProUpgradeCertificate;

  factory ProUpgradeCertificate.fromJson(Map<String, dynamic> json) =>
      _$ProUpgradeCertificateFromJson(json);
}

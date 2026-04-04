// ignore_for_file: type=lint, type=warning



part of 'pro_upgrade_certificate.dart';





_ProUpgradeCertificate _$ProUpgradeCertificateFromJson(
  Map<String, dynamic> json,
) => _ProUpgradeCertificate(
  id: json['id'] as String?,
  requestId: json['request_id'] as String,
  filePath: json['file_path'] as String,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$ProUpgradeCertificateToJson(
  _ProUpgradeCertificate instance,
) => <String, dynamic>{
  'id': instance.id,
  'request_id': instance.requestId,
  'file_path': instance.filePath,
  'created_at': instance.createdAt,
};

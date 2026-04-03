import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/pro_upgrade_repository_provider.dart';

final createProUpgradeRequestProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, void>((ref, _) async {
      final repo = ref.read(proUpgradeRepositoryProvider);
      return repo.createUpgradeRequest();
    });

final uploadProUpgradeCertificateProvider = FutureProvider.autoDispose
    .family<String, UploadProUpgradeCertificateParams>((ref, params) async {
      final repo = ref.read(proUpgradeRepositoryProvider);
      return repo.uploadCertificate(
        requestId: params.requestId,
        fileName: params.fileName,
        bytes: params.bytes,
        contentType: params.contentType,
      );
    });

class UploadProUpgradeCertificateParams {
  final String requestId;
  final String fileName;
  final List<int> bytes;
  final String? contentType;

  const UploadProUpgradeCertificateParams({
    required this.requestId,
    required this.fileName,
    required this.bytes,
    this.contentType,
  });
}

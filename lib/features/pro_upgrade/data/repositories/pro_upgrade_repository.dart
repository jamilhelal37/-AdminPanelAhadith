import '../../domain/models/pro_upgrade_certificate.dart';
import '../../domain/models/pro_upgrade_decision.dart';
import '../../domain/models/pro_upgrade_request.dart';

abstract class ProUpgradeRepository {
  Future<List<ProUpgradeRequest>> getMyRequests();

  Future<Map<String, dynamic>> createUpgradeRequest();

  Future<List<ProUpgradeCertificate>> getCertificatesByRequest(
    String requestId,
  );

  Future<String> uploadCertificate({
    required String requestId,
    required String fileName,
    required List<int> bytes,
    String? contentType,
  });

  Future<Map<String, dynamic>> submitUpgradeRequestForReview({
    required String requestId,
  });

  Future<String> getCertificateSignedUrl(
    String filePath, {
    int expiresInSeconds = 3600,
  });

  Future<List<ProUpgradeDecision>> getMyDecisions();
}

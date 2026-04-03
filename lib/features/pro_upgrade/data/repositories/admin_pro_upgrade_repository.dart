class AdminProRequestView {
  const AdminProRequestView({
    required this.requestId,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.userName,
    required this.userEmail,
    required this.certificates,
    required this.decision,
  });

  final String requestId;
  final String userId;
  final String status;
  final String createdAt;
  final String userName;
  final String userEmail;
  final List<AdminProCertificateAttachment> certificates;
  final AdminProDecisionView? decision;

  bool get hasDecision => decision != null;

  bool get isApproved => decision?.approved == true;

  bool get isRejected => hasDecision && !isApproved;

  bool get isPendingDecision => !hasDecision;

  String get displayName {
    if (userName.trim().isNotEmpty) {
      return userName.trim();
    }
    if (userEmail.trim().isNotEmpty) {
      return userEmail.trim();
    }
    return shortId(userId);
  }

  String get secondaryIdentity {
    if (userEmail.trim().isNotEmpty) {
      return userEmail.trim();
    }
    return userId;
  }
}

class AdminProCertificateAttachment {
  const AdminProCertificateAttachment({
    required this.filePath,
    required this.createdAt,
  });

  final String filePath;
  final String createdAt;

  String get fileName => filePath.split('/').last;

  bool get isImage {
    final lower = fileName.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp');
  }
}

class AdminProDecisionView {
  const AdminProDecisionView({
    required this.approved,
    required this.notes,
    required this.createdAt,
  });

  final bool approved;
  final String notes;
  final String createdAt;
}

String shortId(String value) {
  if (value.length <= 8) {
    return value;
  }
  return value.substring(0, 8);
}

abstract class AdminProUpgradeRepository {
  Future<List<AdminProRequestView>> getRequests();

  Future<void> submitDecision({
    required String requestId,
    required String userId,
    required bool approved,
    String? notes,
  });

  Future<String> getCertificateSignedUrl(
    String filePath, {
    int expiresInSeconds = 3600,
  });
}

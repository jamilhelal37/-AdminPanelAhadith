import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/pro_upgrade_repository_provider.dart';
import '../../domain/models/pro_upgrade_decision.dart';
import '../../domain/models/pro_upgrade_request.dart';
import '../../domain/models/pro_upgrade_certificate.dart';

final myProUpgradeRequestsProvider =
    FutureProvider.autoDispose<List<ProUpgradeRequest>>((ref) async {
      final repo = ref.read(proUpgradeRepositoryProvider);
      return repo.getMyRequests();
    });

final myProUpgradeDecisionsProvider =
    FutureProvider.autoDispose<List<ProUpgradeDecision>>((ref) async {
      final repo = ref.read(proUpgradeRepositoryProvider);
      return repo.getMyDecisions();
    });

final requestCertificatesProvider = FutureProvider.autoDispose
    .family<List<ProUpgradeCertificate>, String>((ref, requestId) async {
      final repo = ref.read(proUpgradeRepositoryProvider);
      return repo.getCertificatesByRequest(requestId);
    });

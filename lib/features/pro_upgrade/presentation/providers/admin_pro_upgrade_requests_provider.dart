import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/admin_pro_upgrade_repository.dart';
import '../../data/repositories/admin_pro_upgrade_repository_provider.dart';

export '../../data/repositories/admin_pro_upgrade_repository.dart';

final adminProUpgradeRequestsProvider =
    FutureProvider.autoDispose<List<AdminProRequestView>>((ref) async {
      final repo = ref.read(adminProUpgradeRepositoryProvider);
      return repo.getRequests();
    });

String shortDate(String value) {
  if (value.length >= 10) {
    return value.substring(0, 10);
  }
  return value;
}

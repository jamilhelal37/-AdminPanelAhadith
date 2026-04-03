import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/admin_metrics_repository.dart';
import '../../data/repositories/admin_metrics_repository_provider.dart';

final adminTableCountProvider = FutureProvider.autoDispose
    .family<int, AdminCountTarget>((ref, target) async {
      final repo = ref.read(adminMetricsRepositoryProvider);
      return repo.count(target);
    });

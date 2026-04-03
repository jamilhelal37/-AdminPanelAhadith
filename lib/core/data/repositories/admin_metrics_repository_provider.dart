import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasources/admin_metrics_supabase_datasource.dart';
import 'admin_metrics_repository.dart';

final adminMetricsRepositoryProvider = Provider<AdminMetricsRepository>((ref) {
  return AdminMetricsSupabaseDatasource();
});

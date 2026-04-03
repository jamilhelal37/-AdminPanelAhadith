import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasources/admin_pro_upgrade_supabase_datasource.dart';
import 'admin_pro_upgrade_repository.dart';

final adminProUpgradeRepositoryProvider = Provider<AdminProUpgradeRepository>((
  ref,
) {
  return AdminProUpgradeSupabaseDatasource();
});

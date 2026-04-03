import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasources/pro_upgrade_supabase_datasource.dart';
import 'pro_upgrade_repository.dart';

final proUpgradeRepositoryProvider = Provider<ProUpgradeRepository>((ref) {
  return ProUpgradeSupabaseDatasource();
});

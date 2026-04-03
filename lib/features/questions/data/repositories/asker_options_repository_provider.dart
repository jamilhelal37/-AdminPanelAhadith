import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasources/asker_options_supabase_datasource.dart';
import 'asker_options_repository.dart';

final askerOptionsRepositoryProvider = Provider<AskerOptionsRepository>((ref) {
  return AskerOptionsSupabaseDatasource();
});

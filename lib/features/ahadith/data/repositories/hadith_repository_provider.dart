import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasources/hadith_supabase_datasources.dart';
import 'hadith_repository.dart';

final hadithRepositoryProvider = Provider<HadithRepository>((ref) {
  return HadithSupabaseDatasource();
});

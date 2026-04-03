import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/ruling_supabase_datasources.dart';
import 'ruling_repository.dart';

final rulingRepositoryProvider = Provider<RulingRepository>((ref) {
  return RulingSupabaseDatasource();
});

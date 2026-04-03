import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/similar_ahadith_supabase_datasources.dart';
import 'similar_ahadith_repository.dart';

final similarAhadithRepositoryProvider = Provider<SimilarAhadithRepository>((
  ref,
) {
  return SimilarAhadithSupabaseDatasource();
});

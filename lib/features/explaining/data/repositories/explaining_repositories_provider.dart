import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/explaining_supabase_datasources.dart';
import 'explaining_repository.dart';

final explainingRepositoryProvider = Provider<ExplainingRepository>((ref) {
  return ExplainingSupabaseDatasource();
});

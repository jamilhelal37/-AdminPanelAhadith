import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/muhaddith_supabase_datasources.dart';
import 'muhaddith_repository.dart';

final muhaddithRepositoryProvider = Provider<MuhaddithRepository>((ref) {
  return MuhaddithSupabaseDatasource();
});

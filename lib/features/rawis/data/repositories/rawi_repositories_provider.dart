import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/rawi_supabase_datasources.dart';
import 'rawi_repository.dart';

final rawiRepositoryProvider = Provider<RawiRepository>((ref) {
  return RawiSupabaseDatasource();
});

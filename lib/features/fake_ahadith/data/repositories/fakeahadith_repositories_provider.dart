import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/fakeahadith_supabase_datasources.dart';
import 'fakeahadith_repository.dart';

final fakeAhadithRepositoryProvider = Provider<FakeAhadithRepository>((ref) {
  return FakeAhadithSupabaseDatasource();
});

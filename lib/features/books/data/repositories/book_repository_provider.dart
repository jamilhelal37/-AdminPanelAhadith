import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/book_supabase_datasources.dart';
import 'book_repository.dart';

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookSupabaseDatasource();
});

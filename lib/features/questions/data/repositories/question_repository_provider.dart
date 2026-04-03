import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasources/question_supabase_datasources.dart';
import 'question_repository.dart';

final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return QuestionSupabaseDatasource();
});

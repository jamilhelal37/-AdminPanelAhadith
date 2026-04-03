import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/topic_class_supabase_datasources.dart';
import 'topic_class_repository.dart';

final topicClassRepositoryProvider = Provider<TopicClassRepository>((ref) {
  return TopicClassSupabaseDatasource();
});

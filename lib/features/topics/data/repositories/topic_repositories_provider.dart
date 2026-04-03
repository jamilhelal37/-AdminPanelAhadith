import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/topic_supabase_datasources.dart';
import 'topic_repository.dart';

final topicRepositoryProvider = Provider<TopicRepository>((ref) {
  return TopicSupabaseDatasource();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/topic_class_repositories_provider.dart';
import '../../domain/models/topic_class.dart';
import 'search_provider.dart';

var adminTopicClassesFutureProvider = FutureProvider<List<TopicClass>>((
  ref,
) async {
  var repo = ref.read(topicClassRepositoryProvider);
  var search = ref.watch(searchProvider);
  return repo.getTopicClasses(search);
});

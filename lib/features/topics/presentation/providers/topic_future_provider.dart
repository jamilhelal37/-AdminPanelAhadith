import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/topic_repositories_provider.dart';
import '../../domain/models/topic.dart';
import 'search_provider.dart';

var adminTopicsFutureProvider = FutureProvider<List<Topic>>((ref) async {
  var repo = ref.read(topicRepositoryProvider);
  var search = ref.watch(searchProvider);
  return repo.getTopics(search);
});

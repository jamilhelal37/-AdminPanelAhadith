import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/topic_class_repositories_provider.dart';
import '../../domain/models/topic_class.dart';

/// جلب جميع TopicClass records المرتبطة بحديث معين
final topicClassesByHadithIdProvider =
    FutureProvider.family<List<TopicClass>, String>((ref, hadithId) async {
      final repo = ref.watch(topicClassRepositoryProvider);
      final allTopicClasses = await repo.getTopicClasses(null);
      return allTopicClasses.where((tc) => tc.hadithId == hadithId).toList();
    });


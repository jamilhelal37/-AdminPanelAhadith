import '../../domain/models/topic_class.dart';

abstract class TopicClassRepository {
  Future<List<TopicClass>> getTopicClasses(String? searchQuery);
  Future<TopicClass> createTopicClass(TopicClass topicClass);
  Future<TopicClass> updateTopicClass(TopicClass topicClass);
  Future<void> deleteTopicClass(String id);
  Stream<List<TopicClass>> getTopicClassesStream();
}

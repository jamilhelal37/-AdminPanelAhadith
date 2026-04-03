import '../../domain/models/topic.dart';

abstract class TopicRepository {
  Future<List<Topic>> getTopics(String? searchQuery);
  Future<void> createTopic(Topic topic);
  Future<void> updateTopic(Topic topic);
  Future<void> deleteTopic(String id);
  Stream<List<Topic>> getTopicsStream();
}

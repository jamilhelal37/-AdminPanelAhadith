import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/models/topic.dart';
import '../repositories/topic_repository.dart';

class TopicSupabaseDatasource implements TopicRepository {
  final _client = Supabase.instance.client;
  static const String _table = 'topics';

  @override
  Future<List<Topic>> getTopics(String? searchQuery) async {
    try {
      var query = _client.from(_table).select();
      if (searchQuery != null) {
        query = query.ilike('name', '%$searchQuery%');
      }

      final response = await query.order('created_at', ascending: false);
      return response.map((e) => Topic.fromJson(e)).toList();
    } catch (error) {
      throw AppFailure.network('تعذر تحميل الموضوعات.', cause: error);
    }
  }

  @override
  Stream<List<Topic>> getTopicsStream() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((event) => event.map((topic) => Topic.fromJson(topic)).toList());
  }

  @override
  Future<Topic> createTopic(Topic topic) async {
    try {
      final json = topic.toJson();
      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');

      final response = await _client
          .from(_table)
          .insert(json)
          .select()
          .single();
      return Topic.fromJson(response);
    } catch (error) {
      throw AppFailure.storage('تعذر إنشاء الموضوع.', cause: error);
    }
  }

  @override
  Future<void> deleteTopic(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
    } catch (error) {
      throw AppFailure.storage('تعذر حذف الموضوع.', cause: error);
    }
  }

  @override
  Future<Topic> updateTopic(Topic topic) async {
    try {
      if (topic.id == null) {
        throw AppFailure.validation('معرّف الموضوع مطلوب.');
      }

      final json = topic.toJson();
      json.remove('created_at');

      final response = await _client
          .from(_table)
          .update(json)
          .eq('id', topic.id!)
          .select()
          .single();
      return Topic.fromJson(response);
    } catch (error) {
      if (error is AppFailure) rethrow;
      throw AppFailure.storage('تعذر تحديث الموضوع.', cause: error);
    }
  }
}

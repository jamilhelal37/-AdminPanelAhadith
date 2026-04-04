import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/models/topic_class.dart';
import '../repositories/topic_class_repository.dart';

class TopicClassSupabaseDatasource implements TopicClassRepository {
  final _client = Supabase.instance.client;
  static const String _table = 'topic_class';

  
  static const String _selectWithRelations = '''
    *,
    topics!topic(name),
    ahadith!hadith(text, hadith_number, books!source(name))
  ''';

  @override
  Future<List<TopicClass>> getTopicClasses(String? searchQuery) async {
    try {
      var query = _client.from(_table).select(_selectWithRelations);

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        query = query.or(
          'topic.ilike.%${searchQuery.trim()}%,hadith.ilike.%${searchQuery.trim()}%',
        );
      }

      final res = await query.order('created_at', ascending: false);

      return (res as List).map((e) {
        final map = e as Map<String, dynamic>;

        
        String? topicName;
        String? hadithText;
        int? hadithNumber;
        String? bookName;

        if (map['topics'] != null) {
          topicName = map['topics']['name'] as String?;
        }

        if (map['ahadith'] != null) {
          final hadithData = map['ahadith'] as Map<String, dynamic>;
          hadithText = hadithData['text'] as String?;
          hadithNumber = hadithData['hadith_number'] as int?;

          if (hadithData['books'] != null) {
            bookName = hadithData['books']['name'] as String?;
          }
        }

        
        return TopicClass.fromJson(map).copyWith(
          topicName: topicName,
          hadithText: hadithText,
          hadithNumber: hadithNumber,
          bookName: bookName,
        );
      }).toList();
    } catch (error) {
      throw AppFailure.network('تعذر تحميل تصنيفات المواضيع.', cause: error);
    }
  }

  @override
  Future<TopicClass> createTopicClass(TopicClass topicClass) async {
    try {
      final json = topicClass.toJson();
      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');

      
      json.remove('topic_name');
      json.remove('hadith_text');
      json.remove('hadith_number');
      json.remove('book_name');

      final res = await _client.from(_table).insert(json).select().single();

      return TopicClass.fromJson(res);
    } catch (error) {
      throw AppFailure.storage('تعذر إنشاء تصنيف الموضوع.', cause: error);
    }
  }

  @override
  Future<TopicClass> updateTopicClass(TopicClass topicClass) async {
    try {
      if (topicClass.id == null) {
        throw AppFailure.validation('معرّف تصنيف الموضوع مطلوب.');
      }

      final json = topicClass.toJson();
      json.remove('id');
      json.remove('created_at');

      
      json.remove('topic_name');
      json.remove('hadith_text');
      json.remove('hadith_number');
      json.remove('book_name');

      final res = await _client
          .from(_table)
          .update(json)
          .eq('id', topicClass.id!)
          .select()
          .single();

      return TopicClass.fromJson(res);
    } catch (error) {
      if (error is AppFailure) rethrow;
      throw AppFailure.storage('تعذر تحديث تصنيف الموضوع.', cause: error);
    }
  }

  @override
  Future<void> deleteTopicClass(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
    } catch (error) {
      throw AppFailure.storage('تعذر حذف تصنيف الموضوع.', cause: error);
    }
  }

  @override
  Stream<List<TopicClass>> getTopicClassesStream() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((event) => event.map((row) => TopicClass.fromJson(row)).toList());
  }
}

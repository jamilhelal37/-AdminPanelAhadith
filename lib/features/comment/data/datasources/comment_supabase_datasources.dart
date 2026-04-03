import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/models/comment.dart';
import '../repositories/comment_repository.dart';

class CommentSupabaseDatasource implements CommentRepository {
  final _client = Supabase.instance.client;
  static const String _table = 'comments';

  @override
  Future<List<Comment>> getComments(String? searchQuery) async {
    try {
      var query = _client.from(_table).select();

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        query = query.ilike('text', '%${searchQuery.trim()}%');
      }

      final response = await query.order('created_at', ascending: false);
      return (response as List)
          .map((item) => Comment.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw AppFailure.network(
        'تعذر تحميل التعليقات الآن.',
        operation: 'comments.list',
        cause: error,
      );
    }
  }

  @override
  Future<Comment> createComment(Comment comment) async {
    try {
      final json = comment.toJson();
      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');

      final response = await _client
          .from(_table)
          .insert(json)
          .select()
          .single();
      return Comment.fromJson(response);
    } catch (error) {
      throw AppFailure.storage(
        'تعذر إضافة التعليق الآن.',
        operation: 'comments.create',
        cause: error,
      );
    }
  }

  @override
  Future<Comment> updateComment(Comment comment) async {
    final id = comment.id;
    if (id == null || id.isEmpty) {
      throw AppFailure.validation(
        'معرّف التعليق مطلوب قبل التعديل.',
        operation: 'comments.update',
      );
    }

    try {
      final json = comment.toJson();
      json.remove('id');
      json.remove('created_at');

      final response = await _client
          .from(_table)
          .update(json)
          .eq('id', id)
          .select()
          .single();

      return Comment.fromJson(response);
    } catch (error) {
      throw AppFailure.storage(
        'تعذر تعديل التعليق الآن.',
        operation: 'comments.update',
        cause: error,
      );
    }
  }

  @override
  Future<void> deleteComment(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
    } catch (error) {
      throw AppFailure.storage(
        'تعذر حذف التعليق الآن.',
        operation: 'comments.delete',
        cause: error,
      );
    }
  }

  @override
  Stream<List<Comment>> getCommentsStream() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((event) => event.map((row) => Comment.fromJson(row)).toList());
  }
}

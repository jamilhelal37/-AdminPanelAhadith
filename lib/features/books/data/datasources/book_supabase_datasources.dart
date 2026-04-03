import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/models/book.dart';
import '../repositories/book_repository.dart';

class BookSupabaseDatasource implements BookRepository {
  final _client = Supabase.instance.client;
  static const String _table = 'books';

  static const String _selectWithMuhaddith =
      'id,name,muhaddith,created_at,updated_at, muhaddith_rel:muhaddiths(name)';

  @override
  Future<List<Book>> getBooks(String? searchQuery) async {
    try {
      var query = _client.from(_table).select(_selectWithMuhaddith);

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        query = query.ilike('name', '%${searchQuery.trim()}%');
      }

      final res = await query.order('created_at', ascending: false);
      return (res as List)
          .map((e) => Book.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw AppFailure.network('تعذر تحميل الكتب.', cause: error);
    }
  }

  @override
  Future<Book> createBook(Book book) async {
    try {
      final json = book.toJson();
      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');

      final res = await _client
          .from(_table)
          .insert(json)
          .select(_selectWithMuhaddith)
          .single();

      return Book.fromJson(res);
    } catch (error) {
      throw AppFailure.storage('تعذر إنشاء الكتاب.', cause: error);
    }
  }

  @override
  Future<Book> updateBook(Book book) async {
    try {
      if (book.id == null) {
        throw AppFailure.validation('معرّف الكتاب مطلوب.');
      }

      final json = book.toJson();
      json.remove('id');
      json.remove('created_at');
      final res = await _client
          .from(_table)
          .update(json)
          .eq('id', book.id!)
          .select(_selectWithMuhaddith)
          .single();

      return Book.fromJson(res);
    } catch (error) {
      if (error is AppFailure) rethrow;
      throw AppFailure.storage('تعذر تحديث الكتاب.', cause: error);
    }
  }

  @override
  Future<void> deleteBook(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
    } catch (error) {
      throw AppFailure.storage('تعذر حذف الكتاب.', cause: error);
    }
  }

  @override
  Stream<List<Book>> getBooksStream() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((event) => event.map((row) => Book.fromJson(row)).toList());
  }
}

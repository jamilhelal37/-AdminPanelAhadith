import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/models/explaining.dart';
import '../repositories/explaining_repository.dart';

class ExplainingSupabaseDatasource implements ExplainingRepository {
  final _client = Supabase.instance.client;
  static const String _table = 'explaining';

  @override
  Future<List<Explaining>> getExplainings(String? searchQuery) async {
    try {
      var query = _client.from(_table).select();
      if (searchQuery != null) {
        query = query.ilike('text', '%$searchQuery%');
      }

      final response = await query.order('created_at', ascending: false);
      return response.map((e) => Explaining.fromJson(e)).toList();
    } catch (error) {
      throw AppFailure.network('تعذر تحميل الشروح.', cause: error);
    }
  }

  @override
  Stream<List<Explaining>> getExplainingsStream() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map(
          (event) => event
              .map((explaining) => Explaining.fromJson(explaining))
              .toList(),
        );
  }

  @override
  Future<Explaining> createExplaining(Explaining explaining) async {
    try {
      final json = explaining.toJson();
      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');
      final response = await _client
          .from(_table)
          .insert(json)
          .select()
          .single();

      return Explaining.fromJson(response);
    } catch (error) {
      throw AppFailure.storage('تعذر إنشاء الشرح.', cause: error);
    }
  }

  @override
  Future<void> deleteExplaining(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
    } catch (error) {
      throw AppFailure.storage('تعذر حذف الشرح.', cause: error);
    }
  }

  @override
  Future<Explaining> updateExplaining(Explaining explaining) async {
    try {
      if (explaining.id == null) {
        throw AppFailure.validation('معرّف الشرح مطلوب.');
      }
      final json = explaining.toJson();
      json.remove('created_at');
      final response = await _client
          .from(_table)
          .update(json)
          .eq('id', explaining.id!)
          .select()
          .single();
      return Explaining.fromJson(response);
    } catch (error) {
      if (error is AppFailure) rethrow;
      throw AppFailure.storage('تعذر تحديث الشرح.', cause: error);
    }
  }
}

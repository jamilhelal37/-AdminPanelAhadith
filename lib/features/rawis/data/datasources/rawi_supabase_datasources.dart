import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/models/rawi.dart';
import '../repositories/rawi_repository.dart';

class RawiSupabaseDatasource implements RawiRepository {
  final _client = Supabase.instance.client;
  static const String _table = 'rawis';

  @override
  Future<List<Rawi>> getRawis(String? searchQuery) async {
    try {
      var query = _client.from(_table).select();
      if (searchQuery != null) {
        query = query.ilike('name', '%$searchQuery%');
      }

      final response = await query.order('created_at', ascending: false);
      return response.map((e) => Rawi.fromJson(e)).toList();
    } catch (error) {
      throw AppFailure.network('تعذر تحميل الرواة.', cause: error);
    }
  }

  @override
  Stream<List<Rawi>> getRawisStream() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((event) => event.map((rawi) => Rawi.fromJson(rawi)).toList());
  }

  @override
  Future<Rawi> createRawi(Rawi rawi) async {
    try {
      final json = rawi.toJson();
      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');
      final response = await _client
          .from(_table)
          .insert(json)
          .select()
          .single();

      return Rawi.fromJson(response);
    } catch (error) {
      throw AppFailure.storage('تعذر إنشاء الراوي.', cause: error);
    }
  }

  @override
  Future<void> deleteRawi(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
    } catch (error) {
      throw AppFailure.storage('تعذر حذف الراوي.', cause: error);
    }
  }

  @override
  Future<Rawi> updateRawi(Rawi rawi) async {
    try {
      if (rawi.id == null) {
        throw AppFailure.validation('معرّف الراوي مطلوب.');
      }
      final json = rawi.toJson();
      json.remove('created_at');
      final response = await _client
          .from(_table)
          .update(json)
          .eq('id', rawi.id!)
          .select()
          .single();
      return Rawi.fromJson(response);
    } catch (error) {
      if (error is AppFailure) rethrow;
      throw AppFailure.storage('تعذر تحديث الراوي.', cause: error);
    }
  }
}

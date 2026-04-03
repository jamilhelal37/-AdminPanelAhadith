import 'package:ahadith/features/muhaddiths/domain/models/muhaddith.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../repositories/muhaddith_repository.dart';

class MuhaddithSupabaseDatasource implements MuhaddithRepository {
  final _client = Supabase.instance.client;
  static const String _table = 'muhaddiths';

  @override
  Future<List<Muhaddith>> getMuhaddiths(String? searchQuery) async {
    try {
      var query = _client.from(_table).select();
      if (searchQuery != null) {
        query = query.ilike('name', '%$searchQuery%');
      }

      final response = await query.order('created_at', ascending: false);
      return response.map((e) => Muhaddith.fromJson(e)).toList();
    } catch (error) {
      throw AppFailure.network('تعذر تحميل المحدّثين.', cause: error);
    }
  }

  @override
  Stream<List<Muhaddith>> getMuhaddithsStream() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map(
          (event) =>
              event.map((muhaddith) => Muhaddith.fromJson(muhaddith)).toList(),
        );
  }

  @override
  Future<Muhaddith> createMuhaddith(Muhaddith muhaddith) async {
    try {
      final json = muhaddith.toJson();
      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');
      final response = await _client
          .from(_table)
          .insert(json)
          .select()
          .single();

      return Muhaddith.fromJson(response);
    } catch (error) {
      throw AppFailure.storage('تعذر إنشاء المحدّث.', cause: error);
    }
  }

  @override
  Future<void> deleteMuhaddith(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
    } catch (error) {
      throw AppFailure.storage('تعذر حذف المحدّث.', cause: error);
    }
  }

  @override
  Future<Muhaddith> updateMuhaddith(Muhaddith muhaddith) async {
    try {
      if (muhaddith.id == null) {
        throw AppFailure.validation('معرّف المحدّث مطلوب.');
      }
      final json = muhaddith.toJson();
      json.remove('created_at');
      final response = await _client
          .from(_table)
          .update(json)
          .eq('id', muhaddith.id!)
          .select()
          .single();
      return Muhaddith.fromJson(response);
    } catch (error) {
      if (error is AppFailure) rethrow;
      throw AppFailure.storage('تعذر تحديث المحدّث.', cause: error);
    }
  }
}

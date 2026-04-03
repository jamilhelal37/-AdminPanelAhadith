import 'package:ahadith/features/ruling/domain/models/ruling.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../repositories/ruling_repository.dart';

class RulingSupabaseDatasource implements RulingRepository {
  final _client = Supabase.instance.client;
  static const String _table = 'ruling';

  @override
  Future<List<Ruling>> getRulings(String? searchQuery) async {
    try {
      var query = _client.from(_table).select();
      if (searchQuery != null) {
        query = query.ilike('name', '%$searchQuery%');
      }

      final response = await query.order('created_at', ascending: false);
      return response.map((e) => Ruling.fromJson(e)).toList();
    } on PostgrestException catch (error) {
      throw AppFailure.network(error.message, cause: error);
    } catch (error) {
      throw AppFailure.network('تعذر تحميل الأحكام.', cause: error);
    }
  }

  @override
  Stream<List<Ruling>> getRulingsStream() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map(
          (event) => event.map((ruling) => Ruling.fromJson(ruling)).toList(),
        );
  }

  @override
  Future<Ruling> createRuling(Ruling ruling) async {
    try {
      final json = ruling.toJson();
      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');
      final response = await _client
          .from(_table)
          .insert(json)
          .select()
          .single();

      return Ruling.fromJson(response);
    } on PostgrestException catch (error) {
      throw AppFailure.storage(error.message, cause: error);
    } catch (error) {
      throw AppFailure.storage('تعذر إنشاء الحكم.', cause: error);
    }
  }

  @override
  Future<void> deleteRuling(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
    } on PostgrestException catch (error) {
      throw AppFailure.storage(error.message, cause: error);
    } catch (error) {
      throw AppFailure.storage('تعذر حذف الحكم.', cause: error);
    }
  }

  @override
  Future<Ruling> updateRuling(Ruling ruling) async {
    try {
      if (ruling.id == null) {
        throw AppFailure.validation('معرّف الحكم مطلوب.');
      }
      final json = ruling.toJson();
      json.remove('created_at');
      final response = await _client
          .from(_table)
          .update(json)
          .eq('id', ruling.id!)
          .select()
          .single();
      return Ruling.fromJson(response);
    } on PostgrestException catch (error) {
      throw AppFailure.storage(error.message, cause: error);
    } catch (error) {
      if (error is AppFailure) rethrow;
      throw AppFailure.storage('تعذر تحديث الحكم.', cause: error);
    }
  }
}

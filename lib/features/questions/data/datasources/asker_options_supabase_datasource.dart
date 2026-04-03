import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../repositories/asker_options_repository.dart';

class AskerOptionsSupabaseDatasource implements AskerOptionsRepository {
  AskerOptionsSupabaseDatasource({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<Map<String, String>>> getAskerOptions() async {
    try {
      final res = await _client
          .from('app_user')
          .select('id,name')
          .order('name', ascending: true);

      return (res as List)
          .map(
            (e) => {
              'id': e['id'].toString(),
              'name': (e['name'] ?? '').toString(),
            },
          )
          .where((x) => (x['id'] ?? '').trim().isNotEmpty)
          .toList();
    } catch (error) {
      throw AppFailure.network(
        'تعذر تحميل قائمة السائلين.',
        details: error.toString(),
      );
    }
  }
}

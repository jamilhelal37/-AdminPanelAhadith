import 'package:supabase_flutter/supabase_flutter.dart';

import '../../errors/app_failure.dart';
import '../repositories/admin_metrics_repository.dart';

class AdminMetricsSupabaseDatasource implements AdminMetricsRepository {
  AdminMetricsSupabaseDatasource({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<int> count(AdminCountTarget target) async {
    try {
      return _client.from(target.table).count(CountOption.exact);
    } catch (error) {
      throw AppFailure.network(
        'تعذر تحميل الإحصائية المطلوبة.',
        details: error.toString(),
      );
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasources/admin_notifications_supabase_datasource.dart';
import 'admin_notifications_repository.dart';

final adminNotificationsRepositoryProvider =
    Provider<AdminNotificationsRepository>((ref) {
      return AdminNotificationsSupabaseDatasource();
    });

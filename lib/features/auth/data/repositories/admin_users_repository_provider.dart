import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'admin_users_supabase_repository.dart';
import 'admin_users_repository.dart';

final adminUsersRepositoryProvider = Provider<AdminUsersRepository>((ref) {
  return AdminUsersSupabaseRepository(Supabase.instance.client);
});

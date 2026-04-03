import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/app_user.dart';
import 'admin_users_repository.dart';

class AdminUsersSupabaseRepository implements AdminUsersRepository {
  final SupabaseClient _client;

  AdminUsersSupabaseRepository(this._client);

  @override
  Future<List<AppUser>> getUsers() async {
    final res = await _client
        .from('app_user')
        .select('*')
        .order('created_at', ascending: false);

    return (res as List)
        .cast<Map>()
        .map((e) => AppUser.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<void> updateUser({
    required String id,
    required UserType type,
    required bool isActivated,
  }) async {
    await _client
        .from('app_user')
        .update({'type': type.name, 'is_activated': isActivated})
        .eq('id', id);
  }
}

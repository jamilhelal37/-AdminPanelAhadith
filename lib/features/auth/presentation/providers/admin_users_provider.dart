import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/admin_users_repository_provider.dart';
import '../../domain/models/app_user.dart';

final adminUsersSearchProvider = StateProvider<String>((ref) => '');

final adminUsersProvider = FutureProvider.autoDispose<List<AppUser>>((
  ref,
) async {
  final repo = ref.read(adminUsersRepositoryProvider);
  return repo.getUsers();
});

class AdminUserUpdateParams {
  final String id;
  final UserType type;
  final bool isActivated;

  const AdminUserUpdateParams({
    required this.id,
    required this.type,
    required this.isActivated,
  });
}

final updateAdminUserProvider = FutureProvider.autoDispose
    .family<void, AdminUserUpdateParams>((ref, params) async {
      final repo = ref.read(adminUsersRepositoryProvider);
      await repo.updateUser(
        id: params.id,
        type: params.type,
        isActivated: params.isActivated,
      );
    });

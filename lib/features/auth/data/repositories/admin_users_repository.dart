import '../../domain/models/app_user.dart';

abstract class AdminUsersRepository {
  Future<List<AppUser>> getUsers();

  Future<void> updateUser({
    required String id,
    required UserType type,
    required bool isActivated,
  });
}

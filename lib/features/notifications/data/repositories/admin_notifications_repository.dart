abstract class AdminNotificationsRepository {
  Future<void> sendPush({
    required String title,
    required String body,
    String? userId,
  });
}

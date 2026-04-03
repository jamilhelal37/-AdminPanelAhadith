import 'dart:convert';

class AppNotificationPayload {
  const AppNotificationPayload._({
    required this.type,
    this.title,
    this.body,
    this.fakeHadithId,
  });

  static const String adminNotificationType = 'admin_notification';
  static const String fakeAhadithType = 'fake_ahadith';

  final String type;
  final String? title;
  final String? body;
  final String? fakeHadithId;

  factory AppNotificationPayload.admin({
    required String title,
    required String body,
  }) {
    return AppNotificationPayload._(
      type: adminNotificationType,
      title: title.trim(),
      body: body.trim(),
    );
  }

  factory AppNotificationPayload.fakeAhadith({required String fakeHadithId}) {
    return AppNotificationPayload._(
      type: fakeAhadithType,
      fakeHadithId: fakeHadithId.trim(),
    );
  }

  String encode() {
    return jsonEncode({
      'type': type,
      if (title != null && title!.isNotEmpty) 'title': title,
      if (body != null && body!.isNotEmpty) 'body': body,
      if (fakeHadithId != null && fakeHadithId!.isNotEmpty)
        'fake_ahadith_id': fakeHadithId,
    });
  }

  static AppNotificationPayload? tryParse(String payload) {
    final trimmed = payload.trim();
    if (trimmed.isEmpty || !trimmed.startsWith('{')) {
      return null;
    }

    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final type = decoded['type']?.toString().trim();
      if (type == null || type.isEmpty) {
        return null;
      }

      return AppNotificationPayload._(
        type: type,
        title: decoded['title']?.toString(),
        body: decoded['body']?.toString(),
        fakeHadithId: decoded['fake_ahadith_id']?.toString(),
      );
    } catch (_) {
      return null;
    }
  }
}

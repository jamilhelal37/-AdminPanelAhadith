class NotificationDetailsArgs {
  const NotificationDetailsArgs({required this.title, required this.body});

  final String title;
  final String body;

  Map<String, String> toQueryParameters() {
    return {'title': title, 'body': body};
  }

  static NotificationDetailsArgs? tryFromUri(Uri uri) {
    final title = uri.queryParameters['title']?.trim() ?? '';
    final body = uri.queryParameters['body']?.trim() ?? '';
    if (title.isEmpty || body.isEmpty) {
      return null;
    }

    return NotificationDetailsArgs(title: title, body: body);
  }
}

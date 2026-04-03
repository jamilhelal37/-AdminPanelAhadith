import 'package:web/web.dart' as web;

void openExternalUrl(String url) {
  web.window.open(url, '_blank');
}

void downloadExternalUrl(String url, {String? fileName}) {
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..target = '_blank'
    ..rel = 'noopener noreferrer';

  if (fileName != null && fileName.trim().isNotEmpty) {
    anchor.download = fileName.trim();
  }

  anchor.click();
}

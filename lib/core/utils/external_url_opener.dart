import 'external_url_opener_stub.dart'
    if (dart.library.html) 'external_url_opener_web.dart'
    as opener;

void openExternalUrl(String url) {
  opener.openExternalUrl(url);
}

void downloadExternalUrl(String url, {String? fileName}) {
  opener.downloadExternalUrl(url, fileName: fileName);
}

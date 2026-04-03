abstract final class ArabicTextNormalizer {
  static const String _arabicIndicDigits = '٠١٢٣٤٥٦٧٨٩';
  static const String _extendedArabicIndicDigits = '۰۱۲۳۴۵۶۷۸۹';
  static final RegExp _diacriticsRegExp = RegExp(
    r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED\u0640]',
  );
  static final RegExp _punctuationRegExp = RegExp(
    r'''[!"#\$%&'()*+,\-./:;<=>?@\[\]\\^_`{|}~،؛؟«»“”‘’…]''',
  );
  static final RegExp _spaceRegExp = RegExp(r'\s+');

  static String normalizeDigits(String? text) {
    if (text == null || text.isEmpty) {
      return '';
    }

    final buffer = StringBuffer();
    for (final char in text.split('')) {
      final arabicIndicIndex = _arabicIndicDigits.indexOf(char);
      if (arabicIndicIndex >= 0) {
        buffer.write(arabicIndicIndex);
        continue;
      }

      final extendedArabicIndicIndex = _extendedArabicIndicDigits.indexOf(char);
      if (extendedArabicIndicIndex >= 0) {
        buffer.write(extendedArabicIndicIndex);
        continue;
      }

      buffer.write(char);
    }

    return buffer.toString();
  }

  static int? tryParseArabicInteger(String? text) {
    final normalizedDigits = normalizeDigits(text).trim();
    if (normalizedDigits.isEmpty) {
      return null;
    }

    if (!RegExp(r'^\d+$').hasMatch(normalizedDigits)) {
      return null;
    }

    return int.tryParse(normalizedDigits);
  }

  static String normalize(String? text) {
    if (text == null || text.trim().isEmpty) {
      return '';
    }

    var value = text.trim().toLowerCase();

    value = value.replaceAll(_diacriticsRegExp, '');
    value = value
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll('ء', '');

    value = value.replaceAll(_punctuationRegExp, ' ');
    value = value.replaceAll(_spaceRegExp, ' ').trim();

    return value;
  }

  static bool containsNormalizedPhrase({
    required String source,
    required String query,
  }) {
    final normalizedQuery = normalize(query);
    if (normalizedQuery.isEmpty) {
      return true;
    }

    return normalize(source).contains(normalizedQuery);
  }
}

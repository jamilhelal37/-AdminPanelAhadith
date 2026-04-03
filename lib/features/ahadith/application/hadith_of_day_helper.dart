import '../domain/models/hadith.dart';

Hadith? selectHadithOfTheDay(List<Hadith> hadiths, {DateTime? date}) {
  if (hadiths.isEmpty) return null;

  final normalizedDate = date ?? DateTime.now();
  final dayKey = DateTime(
    normalizedDate.year,
    normalizedDate.month,
    normalizedDate.day,
  );
  final dayIndex = dayKey.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;

  final sorted = [...hadiths]
    ..sort((a, b) {
      final aKey = '${a.sourceId ?? ''}-${a.hadithNumber}-${a.id ?? ''}';
      final bKey = '${b.sourceId ?? ''}-${b.hadithNumber}-${b.id ?? ''}';
      return aKey.compareTo(bKey);
    });

  return sorted[dayIndex % sorted.length];
}

String buildHadithOfDayNotificationBody(String text) {
  final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (normalized.length <= 120) {
    return normalized;
  }
  return '${normalized.substring(0, 117)}...';
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/hadith.dart';

class HadithOfDayCache {
  HadithOfDayCache._();

  static const String _scheduledHadithsKey = 'hadith_of_day_scheduled_hadiths';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static Future<void> cacheScheduledHadiths(
    Map<DateTime, Hadith> hadiths,
  ) async {
    if (hadiths.isEmpty) return;

    final payload = <String, dynamic>{};
    final existing = await _prefs.getString(_scheduledHadithsKey);
    if (existing != null && existing.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(existing);
        if (decoded is Map<String, dynamic>) {
          payload.addAll(decoded);
        }
      } catch (_) {}
    }

    for (final entry in hadiths.entries) {
      payload[_dayKey(entry.key)] = _serializeHadith(entry.value);
    }

    await _prefs.setString(_scheduledHadithsKey, jsonEncode(payload));
  }

  static Future<Hadith?> loadHadithForDate([DateTime? date]) async {
    final raw = await _prefs.getString(_scheduledHadithsKey);
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final cached = decoded[_dayKey(date ?? DateTime.now())];
      if (cached is! Map) {
        return null;
      }

      return Hadith.fromJson(Map<String, dynamic>.from(cached));
    } catch (_) {
      return null;
    }
  }

  static Future<bool> hasCachedRange({
    DateTime? startDate,
    required int days,
  }) async {
    if (days <= 0) return true;

    final raw = await _prefs.getString(_scheduledHadithsKey);
    if (raw == null || raw.trim().isEmpty) {
      return false;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return false;
      }

      final baseDate = startDate ?? DateTime.now();
      for (var dayOffset = 0; dayOffset < days; dayOffset++) {
        final targetDate = baseDate.add(Duration(days: dayOffset));
        if (decoded[_dayKey(targetDate)] is! Map) {
          return false;
        }
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  static String _dayKey(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');
    return '${normalized.year}-$month-$day';
  }

  static Map<String, dynamic> _serializeHadith(Hadith hadith) {
    return {
      ...hadith.toJson(),
      'subValidText': hadith.subValidText,
      'explaining_rel': hadith.explainingText == null
          ? null
          : {'text': hadith.explainingText},
      'rawi_rel': hadith.rawiName == null ? null : {'name': hadith.rawiName},
      'source_rel': hadith.sourceName == null
          ? null
          : {'name': hadith.sourceName},
      'muhaddith_ruling_rel': hadith.muhaddithRulingName == null
          ? null
          : {'name': hadith.muhaddithRulingName},
      'final_ruling_rel': hadith.finalRulingName == null
          ? null
          : {'name': hadith.finalRulingName},
    };
  }
}

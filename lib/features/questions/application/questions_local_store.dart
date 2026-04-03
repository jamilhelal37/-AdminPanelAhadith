import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/question.dart';

class QuestionsLocalStore {
  QuestionsLocalStore._();

  static const String _snapshotPrefix = 'questions_snapshot_';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static Future<List<Question>> loadQuestions(String scope) async {
    final raw = await _prefs.getString(_key(scope));
    if (raw == null || raw.trim().isEmpty) {
      return const <Question>[];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const <Question>[];
      }

      return decoded
          .whereType<Map>()
          .map((item) => Question.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      return const <Question>[];
    }
  }

  static Future<void> saveQuestions(
    String scope,
    List<Question> questions,
  ) async {
    await _prefs.setString(
      _key(scope),
      jsonEncode(questions.map((question) => question.toJson()).toList()),
    );
  }

  static Future<void> clearQuestions(String scope) async {
    await _prefs.remove(_key(scope));
  }

  static String _key(String scope) => '$_snapshotPrefix$scope';
}

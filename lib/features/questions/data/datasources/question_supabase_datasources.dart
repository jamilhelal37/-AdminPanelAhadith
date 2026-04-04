import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../application/questions_local_store.dart';
import '../../domain/models/question.dart';
import '../repositories/question_repository.dart';

class QuestionSupabaseDatasource implements QuestionRepository {
  final SupabaseClient _client;
  static const String _table = 'questions';

  QuestionSupabaseDatasource({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  String get _cacheScope {
    final userId = _client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      return 'anonymous';
    }
    return userId;
  }

  List<Question> _sortNewestFirst(List<Question> questions) {
    final sorted = List<Question>.from(questions);
    DateTime parseDate(String value) {
      return DateTime.tryParse(value)?.toUtc() ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    }

    sorted.sort(
      (a, b) => parseDate(b.createdAt).compareTo(parseDate(a.createdAt)),
    );
    return sorted;
  }

  bool _matchesFilters(
    Question question, {
    String? searchQuery,
    bool? isActive,
  }) {
    if (isActive != null && question.isActive != isActive) {
      return false;
    }

    if (searchQuery == null || searchQuery.trim().isEmpty) {
      return true;
    }

    final q = searchQuery.trim().toLowerCase();
    final askerText = question.askerText.toLowerCase();
    final answerText = (question.answerText ?? '').toLowerCase();
    return askerText.contains(q) || answerText.contains(q);
  }

  List<Question> _applyFilters(
    List<Question> questions, {
    String? searchQuery,
    bool? isActive,
  }) {
    return _sortNewestFirst(
      questions.where((question) {
        return _matchesFilters(
          question,
          searchQuery: searchQuery,
          isActive: isActive,
        );
      }).toList(),
    );
  }

  @override
  Future<List<Question>> getQuestions({
    String? searchQuery,
    bool? isActive,
  }) async {
    try {
      var query = _client.from(_table).select();
      if (isActive != null) {
        query = query.eq('is_active', isActive);
      }

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim();
        query = query.or('asker_text.ilike.%$q%,answer_text.ilike.%$q%');
      }

      final res = await query.order('created_at', ascending: false);
      final questions = (res as List).map((e) => Question.fromJson(e)).toList();
      await QuestionsLocalStore.saveQuestions(_cacheScope, questions);
      return questions;
    } catch (error) {
      final cached = await QuestionsLocalStore.loadQuestions(_cacheScope);
      return _applyFilters(
        cached,
        searchQuery: searchQuery,
        isActive: isActive,
      );
    }
  }

  @override
  Future<List<Question>> getQuestionsByAsker(String askerId) async {
    try {
      final res = await _client
          .from(_table)
          .select()
          .eq('asker', askerId)
          .order('created_at', ascending: false);

      final questions = (res as List).map((e) => Question.fromJson(e)).toList();
      final cached = await QuestionsLocalStore.loadQuestions(_cacheScope);
      final merged = <Question>[
        ...questions,
        ...cached.where((question) => question.askerId != askerId),
      ];
      await QuestionsLocalStore.saveQuestions(
        _cacheScope,
        _sortNewestFirst(merged),
      );
      return questions;
    } catch (error) {
      final cached = await QuestionsLocalStore.loadQuestions(_cacheScope);
      return _sortNewestFirst(
        cached.where((question) => question.askerId == askerId).toList(),
      );
    }
  }

  @override
  Stream<List<Question>> watchQuestions() async* {
    final scope = _cacheScope;
    yield await QuestionsLocalStore.loadQuestions(scope);

    while (true) {
      try {
        await for (final rows
            in _client
                .from(_table)
                .stream(primaryKey: ['id'])
                .order('created_at', ascending: false)) {
          final questions = rows
              .map((row) => Question.fromJson(Map<String, dynamic>.from(row)))
              .toList();
          await QuestionsLocalStore.saveQuestions(scope, questions);
          yield _sortNewestFirst(questions);
        }
      } catch (_) {
        yield await QuestionsLocalStore.loadQuestions(scope);
        await Future<void>.delayed(const Duration(seconds: 3));
      }
    }
  }

  @override
  Stream<List<Question>> watchQuestionsByAsker(String askerId) {
    return watchQuestions().map((questions) {
      return _sortNewestFirst(
        questions.where((question) => question.askerId == askerId).toList(),
      );
    });
  }

  @override
  Future<Question> createQuestion(Question question) async {
    try {
      final json = question.toJson();

      
      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');

      final res = await _client.from(_table).insert(json).select().single();
      final created = Question.fromJson(res);

      final cached = await QuestionsLocalStore.loadQuestions(_cacheScope);
      final updated = _sortNewestFirst(<Question>[created, ...cached]);
      await QuestionsLocalStore.saveQuestions(_cacheScope, updated);

      return created;
    } catch (error) {
      throw AppFailure.storage('تعذر إنشاء السؤال.', cause: error);
    }
  }

  @override
  Future<Question> updateQuestion(Question question) async {
    try {
      if (question.id == null) {
        throw AppFailure.validation('معرّف السؤال مطلوب.');
      }

      final json = question.toJson();
      
      json.remove('created_at');

      final res = await _client
          .from(_table)
          .update(json)
          .eq('id', question.id!)
          .select()
          .single();

      final updatedQuestion = Question.fromJson(res);
      final cached = await QuestionsLocalStore.loadQuestions(_cacheScope);
      final merged = cached
          .map((item) => item.id == updatedQuestion.id ? updatedQuestion : item)
          .toList();
      final hasUpdated = merged.any((item) => item.id == updatedQuestion.id);
      if (!hasUpdated) {
        merged.add(updatedQuestion);
      }
      await QuestionsLocalStore.saveQuestions(
        _cacheScope,
        _sortNewestFirst(merged),
      );

      return updatedQuestion;
    } catch (error) {
      if (error is AppFailure) rethrow;
      throw AppFailure.storage('تعذر تحديث السؤال.', cause: error);
    }
  }

  @override
  Future<void> deleteQuestion(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);

      final cached = await QuestionsLocalStore.loadQuestions(_cacheScope);
      final updated = cached.where((question) => question.id != id).toList();
      await QuestionsLocalStore.saveQuestions(_cacheScope, updated);
    } catch (error) {
      throw AppFailure.storage('تعذر حذف السؤال.', cause: error);
    }
  }
}

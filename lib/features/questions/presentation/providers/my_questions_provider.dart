import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_notifier_provider.dart';
import '../../data/repositories/question_repository_provider.dart';
import '../../domain/models/question.dart';

final questionsStreamProvider = StreamProvider.autoDispose<List<Question>>((
  ref,
) {
  final userId = ref.watch(authNotifierProvider).valueOrNull?.id;
  if (userId == null || userId.isEmpty) {
    return Stream.value(const <Question>[]);
  }

  final repo = ref.read(questionRepositoryProvider);
  return repo.watchQuestions();
});

DateTime _parseQuestionDate(String value) {
  return DateTime.tryParse(value)?.toUtc() ??
      DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
}

final myQuestionsProvider = Provider.autoDispose<AsyncValue<List<Question>>>((
  ref,
) {
  final userId = ref.watch(authNotifierProvider).valueOrNull?.id;
  if (userId == null || userId.isEmpty) {
    return const AsyncValue.data(<Question>[]);
  }

  final questionsAsync = ref.watch(questionsStreamProvider);
  return questionsAsync.whenData((questions) {
    final filtered = questions
        .where((question) => question.askerId == userId)
        .toList();
    filtered.sort(
      (a, b) => _parseQuestionDate(
        b.createdAt,
      ).compareTo(_parseQuestionDate(a.createdAt)),
    );
    return filtered;
  });
});

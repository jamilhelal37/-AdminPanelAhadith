import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/question_repository_provider.dart';
import '../../domain/models/question.dart';

class AskQuestionParams {
  final String askerId;
  final String questionText;

  const AskQuestionParams({required this.askerId, required this.questionText});
}

final askQuestionProvider = FutureProvider.family<void, AskQuestionParams>((
  ref,
  params,
) async {
  final repo = ref.read(questionRepositoryProvider);
  final now = DateTime.now().toIso8601String();

  await repo.createQuestion(
    Question(
      askerId: params.askerId,
      askerText: params.questionText,
      isActive: false,
      answerText: null,
      createdAt: now,
      updatedAt: now,
    ),
  );
});

import '../../domain/models/question.dart';

abstract class QuestionRepository {
  Future<List<Question>> getQuestions({String? searchQuery, bool? isActive});

  Future<List<Question>> getQuestionsByAsker(String askerId);

  Stream<List<Question>> watchQuestions();

  Stream<List<Question>> watchQuestionsByAsker(String askerId);

  Future<Question> createQuestion(Question question);

  Future<Question> updateQuestion(Question question);

  Future<void> deleteQuestion(String id);
}



import 'package:freezed_annotation/freezed_annotation.dart';

part 'question.freezed.dart';
part 'question.g.dart';

@freezed
abstract class Question with _$Question {
  const factory Question({
    String? id,
    @JsonKey(name: 'asker') String? askerId,
    @JsonKey(name: 'asker_text') required String askerText,
    @Default(false) @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'answer_text') String? answerText,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}

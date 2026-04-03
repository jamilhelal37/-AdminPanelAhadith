// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Question _$QuestionFromJson(Map<String, dynamic> json) => _Question(
  id: json['id'] as String?,
  askerId: json['asker'] as String?,
  askerText: json['asker_text'] as String,
  isActive: json['is_active'] as bool? ?? false,
  answerText: json['answer_text'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$QuestionToJson(_Question instance) => <String, dynamic>{
  'id': instance.id,
  'asker': instance.askerId,
  'asker_text': instance.askerText,
  'is_active': instance.isActive,
  'answer_text': instance.answerText,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

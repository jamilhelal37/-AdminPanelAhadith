// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TopicClass _$TopicClassFromJson(Map<String, dynamic> json) => _TopicClass(
  id: json['id'] as String?,
  topicId: json['topic'] as String?,
  hadithId: json['hadith'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  topicName: json['topic_name'] as String?,
  hadithText: json['hadith_text'] as String?,
  hadithNumber: (json['hadith_number'] as num?)?.toInt(),
  bookName: json['book_name'] as String?,
);

Map<String, dynamic> _$TopicClassToJson(_TopicClass instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topic': instance.topicId,
      'hadith': instance.hadithId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'topic_name': instance.topicName,
      'hadith_text': instance.hadithText,
      'hadith_number': instance.hadithNumber,
      'book_name': instance.bookName,
    };

// ignore_for_file: type=lint, type=warning



part of 'comment.dart';





_Comment _$CommentFromJson(Map<String, dynamic> json) => _Comment(
  id: json['id'] as String?,
  hadithId: json['hadith'] as String?,
  userId: json['user'] as String?,
  text: json['text'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$CommentToJson(_Comment instance) => <String, dynamic>{
  'id': instance.id,
  'hadith': instance.hadithId,
  'user': instance.userId,
  'text': instance.text,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

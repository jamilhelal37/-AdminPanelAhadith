// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Topic _$TopicFromJson(Map<String, dynamic> json) => _Topic(
  id: json['id'] as String?,
  name: json['name'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$TopicToJson(_Topic instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

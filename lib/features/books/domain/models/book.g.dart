// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Book _$BookFromJson(Map<String, dynamic> json) => _Book(
  id: json['id'] as String?,
  name: json['name'] as String,
  muhaddithId: json['muhaddith'] as String?,
  muhaddithRel: json['muhaddith_rel'] as Map<String, dynamic>?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$BookToJson(_Book instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'muhaddith': instance.muhaddithId,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ruling.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Ruling _$RulingFromJson(Map<String, dynamic> json) => _Ruling(
  id: json['id'] as String?,
  name: json['name'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$RulingToJson(_Ruling instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

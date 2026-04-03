// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explaining.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Explaining _$ExplainingFromJson(Map<String, dynamic> json) => _Explaining(
  id: json['id'] as String?,
  text: json['text'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$ExplainingToJson(_Explaining instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

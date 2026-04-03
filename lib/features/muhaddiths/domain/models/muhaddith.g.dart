// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muhaddith.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Muhaddith _$MuhaddithFromJson(Map<String, dynamic> json) => _Muhaddith(
  id: json['id'] as String?,
  name: json['name'] as String,
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
  about: json['about'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$MuhaddithToJson(_Muhaddith instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gender': _$GenderEnumMap[instance.gender]!,
      'about': instance.about,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

const _$GenderEnumMap = {Gender.male: 'male', Gender.female: 'female'};

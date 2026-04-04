// ignore_for_file: type=lint, type=warning



part of 'rawi.dart';





_Rawi _$RawiFromJson(Map<String, dynamic> json) => _Rawi(
  id: json['id'] as String?,
  name: json['name'] as String,
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
  about: json['about'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$RawiToJson(_Rawi instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'gender': _$GenderEnumMap[instance.gender]!,
  'about': instance.about,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

const _$GenderEnumMap = {Gender.male: 'male', Gender.female: 'female'};

// ignore_for_file: type=lint, type=warning



part of 'fake_ahadith.dart';





_FakeAhadith _$FakeAhadithFromJson(Map<String, dynamic> json) => _FakeAhadith(
  id: json['id'] as String?,
  subValid: json['sub_valid'] as String?,
  subValidText: json['subValidText'] as String?,
  text: json['text'] as String,
  normalText: json['normal_text'] as String?,
  searchText: json['search_text'] as String?,
  ruling: json['ruling'] as String?,
  rulingName: json['rulingName'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$FakeAhadithToJson(_FakeAhadith instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sub_valid': instance.subValid,
      'text': instance.text,
      'normal_text': instance.normalText,
      'search_text': instance.searchText,
      'ruling': instance.ruling,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

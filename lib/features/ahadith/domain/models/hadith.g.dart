// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Hadith _$HadithFromJson(Map<String, dynamic> json) => _Hadith(
  id: json['id'] as String?,
  subValid: json['sub_valid'] as String?,
  subValidText: json['subValidText'] as String?,
  explainingId: json['explaining'] as String?,
  explainingText: _relText(json['explaining_rel']),
  type: _hadithTypeFromJson(json['type']),
  text: json['text'] as String,
  normalText: json['normal_text'] as String?,
  searchText: json['search_text'] as String?,
  hadithNumber: (json['hadith_number'] as num).toInt(),
  muhaddithRulingId: json['muhaddith_ruling'] as String?,
  muhaddithRulingName: _relName(json['muhaddith_ruling_rel']),
  finalRulingId: json['final_ruling'] as String?,
  finalRulingName: _relName(json['final_ruling_rel']),
  rawiId: json['rawi'] as String?,
  rawiName: _relName(json['rawi_rel']),
  sourceId: json['source'] as String?,
  sourceName: _relName(json['source_rel']),
  sanad: json['sanad'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  relatedTopics: (json['related_topics'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$HadithToJson(_Hadith instance) => <String, dynamic>{
  'id': instance.id,
  'sub_valid': instance.subValid,
  'explaining': instance.explainingId,
  'type': _hadithTypeToJson(instance.type),
  'text': instance.text,
  'normal_text': instance.normalText,
  'search_text': instance.searchText,
  'hadith_number': instance.hadithNumber,
  'muhaddith_ruling': instance.muhaddithRulingId,
  'final_ruling': instance.finalRulingId,
  'rawi': instance.rawiId,
  'source': instance.sourceId,
  'sanad': instance.sanad,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'related_topics': instance.relatedTopics,
};

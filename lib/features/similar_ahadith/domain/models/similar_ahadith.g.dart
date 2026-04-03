// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'similar_ahadith.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SimilarAhadith _$SimilarAhadithFromJson(Map<String, dynamic> json) =>
    _SimilarAhadith(
      id: json['id'] as String?,
      mainHadithId: json['main_hadith'] as String?,
      simHadithId: json['sim_hadith'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      mainHadithText: json['mainHadithText'] as String?,
      mainHadithNumber: (json['mainHadithNumber'] as num?)?.toInt(),
      mainBookName: json['mainBookName'] as String?,
      simHadithText: json['simHadithText'] as String?,
      simHadithNumber: (json['simHadithNumber'] as num?)?.toInt(),
      simBookName: json['simBookName'] as String?,
    );

Map<String, dynamic> _$SimilarAhadithToJson(_SimilarAhadith instance) =>
    <String, dynamic>{
      'id': instance.id,
      'main_hadith': instance.mainHadithId,
      'sim_hadith': instance.simHadithId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

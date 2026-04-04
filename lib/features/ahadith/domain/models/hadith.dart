

import 'package:freezed_annotation/freezed_annotation.dart';

part 'hadith.freezed.dart';
part 'hadith.g.dart';

enum HadithType { marfu, mawquf, qudsi, atharSahaba }

HadithType _hadithTypeFromJson(dynamic value) {
  if (value is String) {
    final v = value.trim();
    switch (v) {
      case 'مرفوع':
        return HadithType.marfu;
      case 'موقوف':
        return HadithType.mawquf;
      case 'قدسي':
        return HadithType.qudsi;
      case 'آثار الصحابة':
      case 'اثار الصحابة':
        return HadithType.atharSahaba;
      case 'marfu':
        return HadithType.marfu;
      case 'mawquf':
        return HadithType.mawquf;
      case 'qudsi':
        return HadithType.qudsi;
      case 'atharSahaba':
      case 'athar_sahaba':
      case 'AtharSahaba':
        return HadithType.atharSahaba;
    }
  }

  return HadithType.marfu;
}

String _hadithTypeToJson(HadithType type) {
  switch (type) {
    case HadithType.marfu:
      return 'marfu';
    case HadithType.mawquf:
      return 'mawquf';
    case HadithType.qudsi:
      return 'qudsi';
    case HadithType.atharSahaba:
      return 'atharSahaba';
  }
}

String? _relName(dynamic v) {
  if (v is Map) return v['name']?.toString();
  return null;
}

String? _relText(dynamic v) {
  if (v == null) return null;
  if (v is Map) {
    final text = v['text'];
    if (text != null) return text.toString();
  }
  return null;
}

@freezed
abstract class Hadith with _$Hadith {
  const factory Hadith({
    String? id,

    
    @JsonKey(name: 'sub_valid') String? subValid,

    
    @JsonKey(includeToJson: false) String? subValidText,

    
    @JsonKey(name: 'explaining') String? explainingId,

    
    @JsonKey(name: 'explaining_rel', fromJson: _relText, includeToJson: false)
    String? explainingText,

    
    @JsonKey(fromJson: _hadithTypeFromJson, toJson: _hadithTypeToJson)
    required HadithType type,

    required String text,

    @JsonKey(name: 'normal_text') String? normalText,
    @JsonKey(name: 'search_text') String? searchText,

    @JsonKey(name: 'hadith_number') required int hadithNumber,

    
    @JsonKey(name: 'muhaddith_ruling') String? muhaddithRulingId,

    
    @JsonKey(
      name: 'muhaddith_ruling_rel',
      fromJson: _relName,
      includeToJson: false,
    )
    String? muhaddithRulingName,

    
    @JsonKey(name: 'final_ruling') String? finalRulingId,

    
    @JsonKey(name: 'final_ruling_rel', fromJson: _relName, includeToJson: false)
    String? finalRulingName,

    
    @JsonKey(name: 'rawi') String? rawiId,

    
    @JsonKey(name: 'rawi_rel', fromJson: _relName, includeToJson: false)
    String? rawiName,

    
    @JsonKey(name: 'source') String? sourceId,

    
    @JsonKey(name: 'source_rel', fromJson: _relName, includeToJson: false)
    String? sourceName,

    String? sanad,

    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,

    
    @JsonKey(name: 'related_topics') List<String>? relatedTopics,
  }) = _Hadith;

  factory Hadith.fromJson(Map<String, dynamic> json) => _$HadithFromJson(json);
}

// ignore_for_file: invalid_annotation_target

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

    // FK -> ahadith.id (الحديث الصحيح)
    @JsonKey(name: 'sub_valid') String? subValid,

    // نص الحديث الصحيح (قادمة من استعلام منفصل)
    @JsonKey(includeToJson: false) String? subValidText,

    // FK -> explaining.id (أو explainings حسب جدولك)
    @JsonKey(name: 'explaining') String? explainingId,

    // نص الشرح (قادمة من join)
    @JsonKey(name: 'explaining_rel', fromJson: _relText, includeToJson: false)
    String? explainingText,

    // قراءة/حفظ نوع الحديث بالعربي من قاعدة البيانات
    @JsonKey(fromJson: _hadithTypeFromJson, toJson: _hadithTypeToJson)
    required HadithType type,

    required String text,

    @JsonKey(name: 'normal_text') String? normalText,
    @JsonKey(name: 'search_text') String? searchText,

    @JsonKey(name: 'hadith_number') required int hadithNumber,

    // FK -> ruling.id (حكم المحدث)
    @JsonKey(name: 'muhaddith_ruling') String? muhaddithRulingId,

    // اسم حكم المحدث
    @JsonKey(
      name: 'muhaddith_ruling_rel',
      fromJson: _relName,
      includeToJson: false,
    )
    String? muhaddithRulingName,

    // FK -> ruling.id (الحكم النهائي)
    @JsonKey(name: 'final_ruling') String? finalRulingId,

    // اسم الحكم النهائي
    @JsonKey(name: 'final_ruling_rel', fromJson: _relName, includeToJson: false)
    String? finalRulingName,

    // FK -> rawis.id
    @JsonKey(name: 'rawi') String? rawiId,

    // اسم الراوي
    @JsonKey(name: 'rawi_rel', fromJson: _relName, includeToJson: false)
    String? rawiName,

    // FK -> books.id
    @JsonKey(name: 'source') String? sourceId,

    // اسم الكتاب
    @JsonKey(name: 'source_rel', fromJson: _relName, includeToJson: false)
    String? sourceName,

    String? sanad,

    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,

    /// التصنيفات أو المواضيع المرتبطة بالحديث
    @JsonKey(name: 'related_topics') List<String>? relatedTopics,
  }) = _Hadith;

  factory Hadith.fromJson(Map<String, dynamic> json) => _$HadithFromJson(json);
}

// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'similar_ahadith.freezed.dart';
part 'similar_ahadith.g.dart';

@freezed
abstract class SimilarAhadith with _$SimilarAhadith {
  const factory SimilarAhadith({
    String? id,
    @JsonKey(name: 'main_hadith') String? mainHadithId,
    @JsonKey(name: 'sim_hadith') String? simHadithId,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,

    // حقول العلاقات (للقراءة فقط)
    @JsonKey(includeToJson: false) String? mainHadithText,
    @JsonKey(includeToJson: false) int? mainHadithNumber,
    @JsonKey(includeToJson: false) String? mainBookName,
    @JsonKey(includeToJson: false) String? simHadithText,
    @JsonKey(includeToJson: false) int? simHadithNumber,
    @JsonKey(includeToJson: false) String? simBookName,
  }) = _SimilarAhadith;

  factory SimilarAhadith.fromJson(Map<String, dynamic> json) =>
      _$SimilarAhadithFromJson(json);
}


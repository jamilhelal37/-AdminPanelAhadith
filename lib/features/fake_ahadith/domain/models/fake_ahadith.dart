// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'fake_ahadith.freezed.dart';
part 'fake_ahadith.g.dart';

@freezed
abstract class FakeAhadith with _$FakeAhadith {
  const factory FakeAhadith({
    String? id,
    @JsonKey(name: 'sub_valid') String? subValid,
    @JsonKey(includeToJson: false) String? subValidText,
    required String text,
    @JsonKey(name: 'normal_text') String? normalText,
    @JsonKey(name: 'search_text') String? searchText,
    String? ruling,
    @JsonKey(includeToJson: false) String? rulingName,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _FakeAhadith;

  factory FakeAhadith.fromJson(Map<String, dynamic> json) =>
      _$FakeAhadithFromJson(json);
}

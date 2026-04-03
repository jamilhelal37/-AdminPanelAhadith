// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_history.freezed.dart';
part 'search_history.g.dart';

@freezed
abstract class SearchHistory with _$SearchHistory {
  const factory SearchHistory({
    String? id,
    @JsonKey(name: 'user') String? userId,
    @JsonKey(name: 'search_text') required String searchText,
    @JsonKey(name: 'ishadith') @Default(true) bool isHadith,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _SearchHistory;

  factory SearchHistory.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryFromJson(json);
}

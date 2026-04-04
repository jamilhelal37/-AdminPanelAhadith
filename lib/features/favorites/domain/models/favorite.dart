

import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite.freezed.dart';
part 'favorite.g.dart';

@freezed
abstract class Favorite with _$Favorite {
  const factory Favorite({
    String? id,
    @JsonKey(name: 'user') String? userId,
    @JsonKey(name: 'hadith') String? hadithId,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _Favorite;

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);
}

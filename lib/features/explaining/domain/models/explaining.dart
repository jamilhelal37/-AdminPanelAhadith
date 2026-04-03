import 'package:freezed_annotation/freezed_annotation.dart';

part 'explaining.freezed.dart';
part 'explaining.g.dart';

@freezed
abstract class Explaining with _$Explaining {
  const factory Explaining({
    String? id,
    required String text,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _Explaining;

  factory Explaining.fromJson(Map<String, dynamic> json) =>
      _$ExplainingFromJson(json);
}

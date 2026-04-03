import 'package:freezed_annotation/freezed_annotation.dart';

part 'ruling.freezed.dart';
part 'ruling.g.dart';

@freezed
abstract class Ruling with _$Ruling {
  const factory Ruling({
    String? id,
    required String name,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _Ruling;

  factory Ruling.fromJson(Map<String, dynamic> json) => _$RulingFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'rawi.freezed.dart';
part 'rawi.g.dart';

enum Gender { male, female }

@freezed
abstract class Rawi with _$Rawi {
  const factory Rawi({
    String? id,
    required String name,
    required Gender gender,
    required String about,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _Rawi;

  factory Rawi.fromJson(Map<String, dynamic> json) => _$RawiFromJson(json);
}

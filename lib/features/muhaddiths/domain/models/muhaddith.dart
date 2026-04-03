import 'package:freezed_annotation/freezed_annotation.dart';

part 'muhaddith.freezed.dart';
part 'muhaddith.g.dart';

enum Gender { male, female }

@freezed
abstract class Muhaddith with _$Muhaddith {
  const factory Muhaddith({
    String? id,
    required String name,
    required Gender gender,
    required String about,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _Muhaddith;

  factory Muhaddith.fromJson(Map<String, dynamic> json) =>
      _$MuhaddithFromJson(json);
}

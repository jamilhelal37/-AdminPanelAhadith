// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
abstract class Book with _$Book {
  const Book._();

  const factory Book({
    String? id,
    required String name,
    @JsonKey(name: 'muhaddith') String? muhaddithId,
    @JsonKey(name: 'muhaddith_rel', includeToJson: false)
    Map<String, dynamic>? muhaddithRel,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _Book;

  String? get muhaddithName => muhaddithRel?['name'] as String?;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}

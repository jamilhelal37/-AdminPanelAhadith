

import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_class.freezed.dart';
part 'topic_class.g.dart';

@freezed
abstract class TopicClass with _$TopicClass {
  const factory TopicClass({
    String? id,
    @JsonKey(name: 'topic') String? topicId,
    @JsonKey(name: 'hadith') String? hadithId,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    
    @JsonKey(name: 'topic_name') String? topicName,
    @JsonKey(name: 'hadith_text') String? hadithText,
    @JsonKey(name: 'hadith_number') int? hadithNumber,
    @JsonKey(name: 'book_name') String? bookName,
  }) = _TopicClass;

  factory TopicClass.fromJson(Map<String, dynamic> json) =>
      _$TopicClassFromJson(json);
}

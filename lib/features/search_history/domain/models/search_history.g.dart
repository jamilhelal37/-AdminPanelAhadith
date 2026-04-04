// ignore_for_file: type=lint, type=warning



part of 'search_history.dart';





_SearchHistory _$SearchHistoryFromJson(Map<String, dynamic> json) =>
    _SearchHistory(
      id: json['id'] as String?,
      userId: json['user'] as String?,
      searchText: json['search_text'] as String,
      isHadith: json['ishadith'] as bool? ?? true,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$SearchHistoryToJson(_SearchHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.userId,
      'search_text': instance.searchText,
      'ishadith': instance.isHadith,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

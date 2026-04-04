// ignore_for_file: type=lint, type=warning



part of 'favorite.dart';





_Favorite _$FavoriteFromJson(Map<String, dynamic> json) => _Favorite(
  id: json['id'] as String?,
  userId: json['user'] as String?,
  hadithId: json['hadith'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$FavoriteToJson(_Favorite instance) => <String, dynamic>{
  'id': instance.id,
  'user': instance.userId,
  'hadith': instance.hadithId,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

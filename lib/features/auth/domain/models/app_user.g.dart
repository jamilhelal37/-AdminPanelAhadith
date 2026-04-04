// ignore_for_file: type=lint, type=warning


part of 'app_user.dart';





_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String,
  avatarUrl: json['avatar_url'] as String?,
  isActivated: json['is_activated'] as bool? ?? true,
  gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
  type: $enumDecodeNullable(_$UserTypeEnumMap, json['type']),
  birthDate: json['birth_date'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'avatar_url': instance.avatarUrl,
  'is_activated': instance.isActivated,
  'gender': _$GenderEnumMap[instance.gender],
  'type': _$UserTypeEnumMap[instance.type],
  'birth_date': instance.birthDate,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

const _$GenderEnumMap = {Gender.male: 'male', Gender.female: 'female'};

const _$UserTypeEnumMap = {
  UserType.admin: 'admin',
  UserType.member: 'member',
  UserType.scholar: 'scholar',
};

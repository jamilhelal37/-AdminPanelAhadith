// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

enum Gender { male, female }

enum UserType { admin, member, scholar }

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    String? id,
    String? name,
    required String email,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @Default(true) @JsonKey(name: 'is_activated') bool isActivated,
    Gender? gender,
    UserType? type,
    @JsonKey(name: 'birth_date') String? birthDate,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

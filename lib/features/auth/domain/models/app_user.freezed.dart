// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

 String? get id; String? get name; String get email;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'is_activated') bool get isActivated; Gender? get gender; UserType? get type;@JsonKey(name: 'birth_date') String? get birthDate;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isActivated, isActivated) || other.isActivated == isActivated)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.type, type) || other.type == type)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,avatarUrl,isActivated,gender,type,birthDate,createdAt,updatedAt);

@override
String toString() {
  return 'AppUser(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, isActivated: $isActivated, gender: $gender, type: $type, birthDate: $birthDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String email,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'is_activated') bool isActivated, Gender? gender, UserType? type,@JsonKey(name: 'birth_date') String? birthDate,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? email = null,Object? avatarUrl = freezed,Object? isActivated = null,Object? gender = freezed,Object? type = freezed,Object? birthDate = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isActivated: null == isActivated ? _self.isActivated : isActivated // ignore: cast_nullable_to_non_nullable
as bool,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as UserType?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name,  String email, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_activated')  bool isActivated,  Gender? gender,  UserType? type, @JsonKey(name: 'birth_date')  String? birthDate, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.isActivated,_that.gender,_that.type,_that.birthDate,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name,  String email, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_activated')  bool isActivated,  Gender? gender,  UserType? type, @JsonKey(name: 'birth_date')  String? birthDate, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.isActivated,_that.gender,_that.type,_that.birthDate,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name,  String email, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_activated')  bool isActivated,  Gender? gender,  UserType? type, @JsonKey(name: 'birth_date')  String? birthDate, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.isActivated,_that.gender,_that.type,_that.birthDate,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser implements AppUser {
  const _AppUser({this.id, this.name, required this.email, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'is_activated') this.isActivated = true, this.gender, this.type, @JsonKey(name: 'birth_date') this.birthDate, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override final  String? id;
@override final  String? name;
@override final  String email;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'is_activated') final  bool isActivated;
@override final  Gender? gender;
@override final  UserType? type;
@override@JsonKey(name: 'birth_date') final  String? birthDate;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isActivated, isActivated) || other.isActivated == isActivated)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.type, type) || other.type == type)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,avatarUrl,isActivated,gender,type,birthDate,createdAt,updatedAt);

@override
String toString() {
  return 'AppUser(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, isActivated: $isActivated, gender: $gender, type: $type, birthDate: $birthDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String email,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'is_activated') bool isActivated, Gender? gender, UserType? type,@JsonKey(name: 'birth_date') String? birthDate,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String? updatedAt
});




}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? email = null,Object? avatarUrl = freezed,Object? isActivated = null,Object? gender = freezed,Object? type = freezed,Object? birthDate = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_AppUser(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isActivated: null == isActivated ? _self.isActivated : isActivated // ignore: cast_nullable_to_non_nullable
as bool,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as UserType?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

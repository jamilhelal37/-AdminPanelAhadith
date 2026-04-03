// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pro_upgrade_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProUpgradeRequest {

 String? get id;@JsonKey(name: 'user_id') String get userId; String get status;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of ProUpgradeRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProUpgradeRequestCopyWith<ProUpgradeRequest> get copyWith => _$ProUpgradeRequestCopyWithImpl<ProUpgradeRequest>(this as ProUpgradeRequest, _$identity);

  /// Serializes this ProUpgradeRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProUpgradeRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,status,createdAt);

@override
String toString() {
  return 'ProUpgradeRequest(id: $id, userId: $userId, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProUpgradeRequestCopyWith<$Res>  {
  factory $ProUpgradeRequestCopyWith(ProUpgradeRequest value, $Res Function(ProUpgradeRequest) _then) = _$ProUpgradeRequestCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'user_id') String userId, String status,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$ProUpgradeRequestCopyWithImpl<$Res>
    implements $ProUpgradeRequestCopyWith<$Res> {
  _$ProUpgradeRequestCopyWithImpl(this._self, this._then);

  final ProUpgradeRequest _self;
  final $Res Function(ProUpgradeRequest) _then;

/// Create a copy of ProUpgradeRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProUpgradeRequest].
extension ProUpgradeRequestPatterns on ProUpgradeRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProUpgradeRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProUpgradeRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProUpgradeRequest value)  $default,){
final _that = this;
switch (_that) {
case _ProUpgradeRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProUpgradeRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ProUpgradeRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'user_id')  String userId,  String status, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProUpgradeRequest() when $default != null:
return $default(_that.id,_that.userId,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'user_id')  String userId,  String status, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _ProUpgradeRequest():
return $default(_that.id,_that.userId,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'user_id')  String userId,  String status, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ProUpgradeRequest() when $default != null:
return $default(_that.id,_that.userId,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProUpgradeRequest implements ProUpgradeRequest {
  const _ProUpgradeRequest({this.id, @JsonKey(name: 'user_id') required this.userId, this.status = 'pending_documents', @JsonKey(name: 'created_at') required this.createdAt});
  factory _ProUpgradeRequest.fromJson(Map<String, dynamic> json) => _$ProUpgradeRequestFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of ProUpgradeRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProUpgradeRequestCopyWith<_ProUpgradeRequest> get copyWith => __$ProUpgradeRequestCopyWithImpl<_ProUpgradeRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProUpgradeRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProUpgradeRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,status,createdAt);

@override
String toString() {
  return 'ProUpgradeRequest(id: $id, userId: $userId, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProUpgradeRequestCopyWith<$Res> implements $ProUpgradeRequestCopyWith<$Res> {
  factory _$ProUpgradeRequestCopyWith(_ProUpgradeRequest value, $Res Function(_ProUpgradeRequest) _then) = __$ProUpgradeRequestCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'user_id') String userId, String status,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$ProUpgradeRequestCopyWithImpl<$Res>
    implements _$ProUpgradeRequestCopyWith<$Res> {
  __$ProUpgradeRequestCopyWithImpl(this._self, this._then);

  final _ProUpgradeRequest _self;
  final $Res Function(_ProUpgradeRequest) _then;

/// Create a copy of ProUpgradeRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_ProUpgradeRequest(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

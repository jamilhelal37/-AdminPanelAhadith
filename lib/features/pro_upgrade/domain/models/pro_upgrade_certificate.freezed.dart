// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pro_upgrade_certificate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProUpgradeCertificate {

 String? get id;@JsonKey(name: 'request_id') String get requestId;@JsonKey(name: 'file_path') String get filePath;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of ProUpgradeCertificate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProUpgradeCertificateCopyWith<ProUpgradeCertificate> get copyWith => _$ProUpgradeCertificateCopyWithImpl<ProUpgradeCertificate>(this as ProUpgradeCertificate, _$identity);

  /// Serializes this ProUpgradeCertificate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProUpgradeCertificate&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestId,filePath,createdAt);

@override
String toString() {
  return 'ProUpgradeCertificate(id: $id, requestId: $requestId, filePath: $filePath, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProUpgradeCertificateCopyWith<$Res>  {
  factory $ProUpgradeCertificateCopyWith(ProUpgradeCertificate value, $Res Function(ProUpgradeCertificate) _then) = _$ProUpgradeCertificateCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'request_id') String requestId,@JsonKey(name: 'file_path') String filePath,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$ProUpgradeCertificateCopyWithImpl<$Res>
    implements $ProUpgradeCertificateCopyWith<$Res> {
  _$ProUpgradeCertificateCopyWithImpl(this._self, this._then);

  final ProUpgradeCertificate _self;
  final $Res Function(ProUpgradeCertificate) _then;

/// Create a copy of ProUpgradeCertificate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? requestId = null,Object? filePath = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProUpgradeCertificate].
extension ProUpgradeCertificatePatterns on ProUpgradeCertificate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProUpgradeCertificate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProUpgradeCertificate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProUpgradeCertificate value)  $default,){
final _that = this;
switch (_that) {
case _ProUpgradeCertificate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProUpgradeCertificate value)?  $default,){
final _that = this;
switch (_that) {
case _ProUpgradeCertificate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'file_path')  String filePath, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProUpgradeCertificate() when $default != null:
return $default(_that.id,_that.requestId,_that.filePath,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'file_path')  String filePath, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _ProUpgradeCertificate():
return $default(_that.id,_that.requestId,_that.filePath,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'file_path')  String filePath, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ProUpgradeCertificate() when $default != null:
return $default(_that.id,_that.requestId,_that.filePath,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProUpgradeCertificate implements ProUpgradeCertificate {
  const _ProUpgradeCertificate({this.id, @JsonKey(name: 'request_id') required this.requestId, @JsonKey(name: 'file_path') required this.filePath, @JsonKey(name: 'created_at') required this.createdAt});
  factory _ProUpgradeCertificate.fromJson(Map<String, dynamic> json) => _$ProUpgradeCertificateFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'request_id') final  String requestId;
@override@JsonKey(name: 'file_path') final  String filePath;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of ProUpgradeCertificate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProUpgradeCertificateCopyWith<_ProUpgradeCertificate> get copyWith => __$ProUpgradeCertificateCopyWithImpl<_ProUpgradeCertificate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProUpgradeCertificateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProUpgradeCertificate&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestId,filePath,createdAt);

@override
String toString() {
  return 'ProUpgradeCertificate(id: $id, requestId: $requestId, filePath: $filePath, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProUpgradeCertificateCopyWith<$Res> implements $ProUpgradeCertificateCopyWith<$Res> {
  factory _$ProUpgradeCertificateCopyWith(_ProUpgradeCertificate value, $Res Function(_ProUpgradeCertificate) _then) = __$ProUpgradeCertificateCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'request_id') String requestId,@JsonKey(name: 'file_path') String filePath,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$ProUpgradeCertificateCopyWithImpl<$Res>
    implements _$ProUpgradeCertificateCopyWith<$Res> {
  __$ProUpgradeCertificateCopyWithImpl(this._self, this._then);

  final _ProUpgradeCertificate _self;
  final $Res Function(_ProUpgradeCertificate) _then;

/// Create a copy of ProUpgradeCertificate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? requestId = null,Object? filePath = null,Object? createdAt = null,}) {
  return _then(_ProUpgradeCertificate(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pro_upgrade_decision.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProUpgradeDecision {

 String? get id;@JsonKey(name: 'request_id') String get requestId;@JsonKey(name: 'user_id') String get userId; bool get approved;@JsonKey(name: 'reviewed_by') String? get reviewedBy; String? get notes;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of ProUpgradeDecision
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProUpgradeDecisionCopyWith<ProUpgradeDecision> get copyWith => _$ProUpgradeDecisionCopyWithImpl<ProUpgradeDecision>(this as ProUpgradeDecision, _$identity);

  /// Serializes this ProUpgradeDecision to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProUpgradeDecision&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestId,userId,approved,reviewedBy,notes,createdAt);

@override
String toString() {
  return 'ProUpgradeDecision(id: $id, requestId: $requestId, userId: $userId, approved: $approved, reviewedBy: $reviewedBy, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProUpgradeDecisionCopyWith<$Res>  {
  factory $ProUpgradeDecisionCopyWith(ProUpgradeDecision value, $Res Function(ProUpgradeDecision) _then) = _$ProUpgradeDecisionCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'request_id') String requestId,@JsonKey(name: 'user_id') String userId, bool approved,@JsonKey(name: 'reviewed_by') String? reviewedBy, String? notes,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$ProUpgradeDecisionCopyWithImpl<$Res>
    implements $ProUpgradeDecisionCopyWith<$Res> {
  _$ProUpgradeDecisionCopyWithImpl(this._self, this._then);

  final ProUpgradeDecision _self;
  final $Res Function(ProUpgradeDecision) _then;

/// Create a copy of ProUpgradeDecision
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? requestId = null,Object? userId = null,Object? approved = null,Object? reviewedBy = freezed,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as bool,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProUpgradeDecision].
extension ProUpgradeDecisionPatterns on ProUpgradeDecision {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProUpgradeDecision value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProUpgradeDecision() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProUpgradeDecision value)  $default,){
final _that = this;
switch (_that) {
case _ProUpgradeDecision():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProUpgradeDecision value)?  $default,){
final _that = this;
switch (_that) {
case _ProUpgradeDecision() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'user_id')  String userId,  bool approved, @JsonKey(name: 'reviewed_by')  String? reviewedBy,  String? notes, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProUpgradeDecision() when $default != null:
return $default(_that.id,_that.requestId,_that.userId,_that.approved,_that.reviewedBy,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'user_id')  String userId,  bool approved, @JsonKey(name: 'reviewed_by')  String? reviewedBy,  String? notes, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _ProUpgradeDecision():
return $default(_that.id,_that.requestId,_that.userId,_that.approved,_that.reviewedBy,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'user_id')  String userId,  bool approved, @JsonKey(name: 'reviewed_by')  String? reviewedBy,  String? notes, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ProUpgradeDecision() when $default != null:
return $default(_that.id,_that.requestId,_that.userId,_that.approved,_that.reviewedBy,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProUpgradeDecision implements ProUpgradeDecision {
  const _ProUpgradeDecision({this.id, @JsonKey(name: 'request_id') required this.requestId, @JsonKey(name: 'user_id') required this.userId, required this.approved, @JsonKey(name: 'reviewed_by') this.reviewedBy, this.notes, @JsonKey(name: 'created_at') required this.createdAt});
  factory _ProUpgradeDecision.fromJson(Map<String, dynamic> json) => _$ProUpgradeDecisionFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'request_id') final  String requestId;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  bool approved;
@override@JsonKey(name: 'reviewed_by') final  String? reviewedBy;
@override final  String? notes;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of ProUpgradeDecision
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProUpgradeDecisionCopyWith<_ProUpgradeDecision> get copyWith => __$ProUpgradeDecisionCopyWithImpl<_ProUpgradeDecision>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProUpgradeDecisionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProUpgradeDecision&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestId,userId,approved,reviewedBy,notes,createdAt);

@override
String toString() {
  return 'ProUpgradeDecision(id: $id, requestId: $requestId, userId: $userId, approved: $approved, reviewedBy: $reviewedBy, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProUpgradeDecisionCopyWith<$Res> implements $ProUpgradeDecisionCopyWith<$Res> {
  factory _$ProUpgradeDecisionCopyWith(_ProUpgradeDecision value, $Res Function(_ProUpgradeDecision) _then) = __$ProUpgradeDecisionCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'request_id') String requestId,@JsonKey(name: 'user_id') String userId, bool approved,@JsonKey(name: 'reviewed_by') String? reviewedBy, String? notes,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$ProUpgradeDecisionCopyWithImpl<$Res>
    implements _$ProUpgradeDecisionCopyWith<$Res> {
  __$ProUpgradeDecisionCopyWithImpl(this._self, this._then);

  final _ProUpgradeDecision _self;
  final $Res Function(_ProUpgradeDecision) _then;

/// Create a copy of ProUpgradeDecision
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? requestId = null,Object? userId = null,Object? approved = null,Object? reviewedBy = freezed,Object? notes = freezed,Object? createdAt = null,}) {
  return _then(_ProUpgradeDecision(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as bool,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

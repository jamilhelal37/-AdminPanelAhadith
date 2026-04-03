// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_audit_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminAuditLog {

 String get id;@JsonKey(name: 'table_name') String get tableName; String get operation;@JsonKey(name: 'record_id') String? get recordId;@JsonKey(name: 'actor_user_id') String? get actorUserId;@JsonKey(name: 'actor_name') String get actorName;@JsonKey(name: 'actor_email') String get actorEmail;@JsonKey(name: 'old_data') Map<String, dynamic>? get oldData;@JsonKey(name: 'new_data') Map<String, dynamic>? get newData;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of AdminAuditLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminAuditLogCopyWith<AdminAuditLog> get copyWith => _$AdminAuditLogCopyWithImpl<AdminAuditLog>(this as AdminAuditLog, _$identity);

  /// Serializes this AdminAuditLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminAuditLog&&(identical(other.id, id) || other.id == id)&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.actorUserId, actorUserId) || other.actorUserId == actorUserId)&&(identical(other.actorName, actorName) || other.actorName == actorName)&&(identical(other.actorEmail, actorEmail) || other.actorEmail == actorEmail)&&const DeepCollectionEquality().equals(other.oldData, oldData)&&const DeepCollectionEquality().equals(other.newData, newData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tableName,operation,recordId,actorUserId,actorName,actorEmail,const DeepCollectionEquality().hash(oldData),const DeepCollectionEquality().hash(newData),createdAt);

@override
String toString() {
  return 'AdminAuditLog(id: $id, tableName: $tableName, operation: $operation, recordId: $recordId, actorUserId: $actorUserId, actorName: $actorName, actorEmail: $actorEmail, oldData: $oldData, newData: $newData, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AdminAuditLogCopyWith<$Res>  {
  factory $AdminAuditLogCopyWith(AdminAuditLog value, $Res Function(AdminAuditLog) _then) = _$AdminAuditLogCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'table_name') String tableName, String operation,@JsonKey(name: 'record_id') String? recordId,@JsonKey(name: 'actor_user_id') String? actorUserId,@JsonKey(name: 'actor_name') String actorName,@JsonKey(name: 'actor_email') String actorEmail,@JsonKey(name: 'old_data') Map<String, dynamic>? oldData,@JsonKey(name: 'new_data') Map<String, dynamic>? newData,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$AdminAuditLogCopyWithImpl<$Res>
    implements $AdminAuditLogCopyWith<$Res> {
  _$AdminAuditLogCopyWithImpl(this._self, this._then);

  final AdminAuditLog _self;
  final $Res Function(AdminAuditLog) _then;

/// Create a copy of AdminAuditLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tableName = null,Object? operation = null,Object? recordId = freezed,Object? actorUserId = freezed,Object? actorName = null,Object? actorEmail = null,Object? oldData = freezed,Object? newData = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tableName: null == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,recordId: freezed == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String?,actorUserId: freezed == actorUserId ? _self.actorUserId : actorUserId // ignore: cast_nullable_to_non_nullable
as String?,actorName: null == actorName ? _self.actorName : actorName // ignore: cast_nullable_to_non_nullable
as String,actorEmail: null == actorEmail ? _self.actorEmail : actorEmail // ignore: cast_nullable_to_non_nullable
as String,oldData: freezed == oldData ? _self.oldData : oldData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,newData: freezed == newData ? _self.newData : newData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminAuditLog].
extension AdminAuditLogPatterns on AdminAuditLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminAuditLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminAuditLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminAuditLog value)  $default,){
final _that = this;
switch (_that) {
case _AdminAuditLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminAuditLog value)?  $default,){
final _that = this;
switch (_that) {
case _AdminAuditLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'table_name')  String tableName,  String operation, @JsonKey(name: 'record_id')  String? recordId, @JsonKey(name: 'actor_user_id')  String? actorUserId, @JsonKey(name: 'actor_name')  String actorName, @JsonKey(name: 'actor_email')  String actorEmail, @JsonKey(name: 'old_data')  Map<String, dynamic>? oldData, @JsonKey(name: 'new_data')  Map<String, dynamic>? newData, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminAuditLog() when $default != null:
return $default(_that.id,_that.tableName,_that.operation,_that.recordId,_that.actorUserId,_that.actorName,_that.actorEmail,_that.oldData,_that.newData,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'table_name')  String tableName,  String operation, @JsonKey(name: 'record_id')  String? recordId, @JsonKey(name: 'actor_user_id')  String? actorUserId, @JsonKey(name: 'actor_name')  String actorName, @JsonKey(name: 'actor_email')  String actorEmail, @JsonKey(name: 'old_data')  Map<String, dynamic>? oldData, @JsonKey(name: 'new_data')  Map<String, dynamic>? newData, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _AdminAuditLog():
return $default(_that.id,_that.tableName,_that.operation,_that.recordId,_that.actorUserId,_that.actorName,_that.actorEmail,_that.oldData,_that.newData,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'table_name')  String tableName,  String operation, @JsonKey(name: 'record_id')  String? recordId, @JsonKey(name: 'actor_user_id')  String? actorUserId, @JsonKey(name: 'actor_name')  String actorName, @JsonKey(name: 'actor_email')  String actorEmail, @JsonKey(name: 'old_data')  Map<String, dynamic>? oldData, @JsonKey(name: 'new_data')  Map<String, dynamic>? newData, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AdminAuditLog() when $default != null:
return $default(_that.id,_that.tableName,_that.operation,_that.recordId,_that.actorUserId,_that.actorName,_that.actorEmail,_that.oldData,_that.newData,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminAuditLog extends AdminAuditLog {
  const _AdminAuditLog({required this.id, @JsonKey(name: 'table_name') required this.tableName, required this.operation, @JsonKey(name: 'record_id') this.recordId, @JsonKey(name: 'actor_user_id') this.actorUserId, @JsonKey(name: 'actor_name') this.actorName = '', @JsonKey(name: 'actor_email') this.actorEmail = '', @JsonKey(name: 'old_data') final  Map<String, dynamic>? oldData, @JsonKey(name: 'new_data') final  Map<String, dynamic>? newData, @JsonKey(name: 'created_at') required this.createdAt}): _oldData = oldData,_newData = newData,super._();
  factory _AdminAuditLog.fromJson(Map<String, dynamic> json) => _$AdminAuditLogFromJson(json);

@override final  String id;
@override@JsonKey(name: 'table_name') final  String tableName;
@override final  String operation;
@override@JsonKey(name: 'record_id') final  String? recordId;
@override@JsonKey(name: 'actor_user_id') final  String? actorUserId;
@override@JsonKey(name: 'actor_name') final  String actorName;
@override@JsonKey(name: 'actor_email') final  String actorEmail;
 final  Map<String, dynamic>? _oldData;
@override@JsonKey(name: 'old_data') Map<String, dynamic>? get oldData {
  final value = _oldData;
  if (value == null) return null;
  if (_oldData is EqualUnmodifiableMapView) return _oldData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _newData;
@override@JsonKey(name: 'new_data') Map<String, dynamic>? get newData {
  final value = _newData;
  if (value == null) return null;
  if (_newData is EqualUnmodifiableMapView) return _newData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of AdminAuditLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminAuditLogCopyWith<_AdminAuditLog> get copyWith => __$AdminAuditLogCopyWithImpl<_AdminAuditLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminAuditLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminAuditLog&&(identical(other.id, id) || other.id == id)&&(identical(other.tableName, tableName) || other.tableName == tableName)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.recordId, recordId) || other.recordId == recordId)&&(identical(other.actorUserId, actorUserId) || other.actorUserId == actorUserId)&&(identical(other.actorName, actorName) || other.actorName == actorName)&&(identical(other.actorEmail, actorEmail) || other.actorEmail == actorEmail)&&const DeepCollectionEquality().equals(other._oldData, _oldData)&&const DeepCollectionEquality().equals(other._newData, _newData)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tableName,operation,recordId,actorUserId,actorName,actorEmail,const DeepCollectionEquality().hash(_oldData),const DeepCollectionEquality().hash(_newData),createdAt);

@override
String toString() {
  return 'AdminAuditLog(id: $id, tableName: $tableName, operation: $operation, recordId: $recordId, actorUserId: $actorUserId, actorName: $actorName, actorEmail: $actorEmail, oldData: $oldData, newData: $newData, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AdminAuditLogCopyWith<$Res> implements $AdminAuditLogCopyWith<$Res> {
  factory _$AdminAuditLogCopyWith(_AdminAuditLog value, $Res Function(_AdminAuditLog) _then) = __$AdminAuditLogCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'table_name') String tableName, String operation,@JsonKey(name: 'record_id') String? recordId,@JsonKey(name: 'actor_user_id') String? actorUserId,@JsonKey(name: 'actor_name') String actorName,@JsonKey(name: 'actor_email') String actorEmail,@JsonKey(name: 'old_data') Map<String, dynamic>? oldData,@JsonKey(name: 'new_data') Map<String, dynamic>? newData,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$AdminAuditLogCopyWithImpl<$Res>
    implements _$AdminAuditLogCopyWith<$Res> {
  __$AdminAuditLogCopyWithImpl(this._self, this._then);

  final _AdminAuditLog _self;
  final $Res Function(_AdminAuditLog) _then;

/// Create a copy of AdminAuditLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tableName = null,Object? operation = null,Object? recordId = freezed,Object? actorUserId = freezed,Object? actorName = null,Object? actorEmail = null,Object? oldData = freezed,Object? newData = freezed,Object? createdAt = null,}) {
  return _then(_AdminAuditLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tableName: null == tableName ? _self.tableName : tableName // ignore: cast_nullable_to_non_nullable
as String,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,recordId: freezed == recordId ? _self.recordId : recordId // ignore: cast_nullable_to_non_nullable
as String?,actorUserId: freezed == actorUserId ? _self.actorUserId : actorUserId // ignore: cast_nullable_to_non_nullable
as String?,actorName: null == actorName ? _self.actorName : actorName // ignore: cast_nullable_to_non_nullable
as String,actorEmail: null == actorEmail ? _self.actorEmail : actorEmail // ignore: cast_nullable_to_non_nullable
as String,oldData: freezed == oldData ? _self._oldData : oldData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,newData: freezed == newData ? _self._newData : newData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

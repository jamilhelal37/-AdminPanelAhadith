// ignore_for_file: type=lint, type=warning






part of 'admin_audit_log.dart';






T _$identity<T>(T value) => value;


mixin _$AdminAuditLog {

 String get id;@JsonKey(name: 'table_name') String get tableName; String get operation;@JsonKey(name: 'record_id') String? get recordId;@JsonKey(name: 'actor_user_id') String? get actorUserId;@JsonKey(name: 'actor_name') String get actorName;@JsonKey(name: 'actor_email') String get actorEmail;@JsonKey(name: 'old_data') Map<String, dynamic>? get oldData;@JsonKey(name: 'new_data') Map<String, dynamic>? get newData;@JsonKey(name: 'created_at') String get createdAt;


@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminAuditLogCopyWith<AdminAuditLog> get copyWith => _$AdminAuditLogCopyWithImpl<AdminAuditLog>(this as AdminAuditLog, _$identity);

  
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


abstract mixin class $AdminAuditLogCopyWith<$Res>  {
  factory $AdminAuditLogCopyWith(AdminAuditLog value, $Res Function(AdminAuditLog) _then) = _$AdminAuditLogCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'table_name') String tableName, String operation,@JsonKey(name: 'record_id') String? recordId,@JsonKey(name: 'actor_user_id') String? actorUserId,@JsonKey(name: 'actor_name') String actorName,@JsonKey(name: 'actor_email') String actorEmail,@JsonKey(name: 'old_data') Map<String, dynamic>? oldData,@JsonKey(name: 'new_data') Map<String, dynamic>? newData,@JsonKey(name: 'created_at') String createdAt
});




}

class _$AdminAuditLogCopyWithImpl<$Res>
    implements $AdminAuditLogCopyWith<$Res> {
  _$AdminAuditLogCopyWithImpl(this._self, this._then);

  final AdminAuditLog _self;
  final $Res Function(AdminAuditLog) _then;



@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tableName = null,Object? operation = null,Object? recordId = freezed,Object? actorUserId = freezed,Object? actorName = null,Object? actorEmail = null,Object? oldData = freezed,Object? newData = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id 
as String,tableName: null == tableName ? _self.tableName : tableName 
as String,operation: null == operation ? _self.operation : operation 
as String,recordId: freezed == recordId ? _self.recordId : recordId 
as String?,actorUserId: freezed == actorUserId ? _self.actorUserId : actorUserId 
as String?,actorName: null == actorName ? _self.actorName : actorName 
as String,actorEmail: null == actorEmail ? _self.actorEmail : actorEmail 
as String,oldData: freezed == oldData ? _self.oldData : oldData 
as Map<String, dynamic>?,newData: freezed == newData ? _self.newData : newData 
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,
  ));
}

}



extension AdminAuditLogPatterns on AdminAuditLog {












@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminAuditLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminAuditLog() when $default != null:
return $default(_that);case _:
  return orElse();

}
}













@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminAuditLog value)  $default,){
final _that = this;
switch (_that) {
case _AdminAuditLog():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminAuditLog value)?  $default,){
final _that = this;
switch (_that) {
case _AdminAuditLog() when $default != null:
return $default(_that);case _:
  return null;

}
}












@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'table_name')  String tableName,  String operation, @JsonKey(name: 'record_id')  String? recordId, @JsonKey(name: 'actor_user_id')  String? actorUserId, @JsonKey(name: 'actor_name')  String actorName, @JsonKey(name: 'actor_email')  String actorEmail, @JsonKey(name: 'old_data')  Map<String, dynamic>? oldData, @JsonKey(name: 'new_data')  Map<String, dynamic>? newData, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminAuditLog() when $default != null:
return $default(_that.id,_that.tableName,_that.operation,_that.recordId,_that.actorUserId,_that.actorName,_that.actorEmail,_that.oldData,_that.newData,_that.createdAt);case _:
  return orElse();

}
}













@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'table_name')  String tableName,  String operation, @JsonKey(name: 'record_id')  String? recordId, @JsonKey(name: 'actor_user_id')  String? actorUserId, @JsonKey(name: 'actor_name')  String actorName, @JsonKey(name: 'actor_email')  String actorEmail, @JsonKey(name: 'old_data')  Map<String, dynamic>? oldData, @JsonKey(name: 'new_data')  Map<String, dynamic>? newData, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _AdminAuditLog():
return $default(_that.id,_that.tableName,_that.operation,_that.recordId,_that.actorUserId,_that.actorName,_that.actorEmail,_that.oldData,_that.newData,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'table_name')  String tableName,  String operation, @JsonKey(name: 'record_id')  String? recordId, @JsonKey(name: 'actor_user_id')  String? actorUserId, @JsonKey(name: 'actor_name')  String actorName, @JsonKey(name: 'actor_email')  String actorEmail, @JsonKey(name: 'old_data')  Map<String, dynamic>? oldData, @JsonKey(name: 'new_data')  Map<String, dynamic>? newData, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AdminAuditLog() when $default != null:
return $default(_that.id,_that.tableName,_that.operation,_that.recordId,_that.actorUserId,_that.actorName,_that.actorEmail,_that.oldData,_that.newData,_that.createdAt);case _:
  return null;

}
}

}


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
  
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _newData;
@override@JsonKey(name: 'new_data') Map<String, dynamic>? get newData {
  final value = _newData;
  if (value == null) return null;
  if (_newData is EqualUnmodifiableMapView) return _newData;
  
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'created_at') final  String createdAt;



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


abstract mixin class _$AdminAuditLogCopyWith<$Res> implements $AdminAuditLogCopyWith<$Res> {
  factory _$AdminAuditLogCopyWith(_AdminAuditLog value, $Res Function(_AdminAuditLog) _then) = __$AdminAuditLogCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'table_name') String tableName, String operation,@JsonKey(name: 'record_id') String? recordId,@JsonKey(name: 'actor_user_id') String? actorUserId,@JsonKey(name: 'actor_name') String actorName,@JsonKey(name: 'actor_email') String actorEmail,@JsonKey(name: 'old_data') Map<String, dynamic>? oldData,@JsonKey(name: 'new_data') Map<String, dynamic>? newData,@JsonKey(name: 'created_at') String createdAt
});




}

class __$AdminAuditLogCopyWithImpl<$Res>
    implements _$AdminAuditLogCopyWith<$Res> {
  __$AdminAuditLogCopyWithImpl(this._self, this._then);

  final _AdminAuditLog _self;
  final $Res Function(_AdminAuditLog) _then;



@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tableName = null,Object? operation = null,Object? recordId = freezed,Object? actorUserId = freezed,Object? actorName = null,Object? actorEmail = null,Object? oldData = freezed,Object? newData = freezed,Object? createdAt = null,}) {
  return _then(_AdminAuditLog(
id: null == id ? _self.id : id 
as String,tableName: null == tableName ? _self.tableName : tableName 
as String,operation: null == operation ? _self.operation : operation 
as String,recordId: freezed == recordId ? _self.recordId : recordId 
as String?,actorUserId: freezed == actorUserId ? _self.actorUserId : actorUserId 
as String?,actorName: null == actorName ? _self.actorName : actorName 
as String,actorEmail: null == actorEmail ? _self.actorEmail : actorEmail 
as String,oldData: freezed == oldData ? _self._oldData : oldData 
as Map<String, dynamic>?,newData: freezed == newData ? _self._newData : newData 
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,
  ));
}


}



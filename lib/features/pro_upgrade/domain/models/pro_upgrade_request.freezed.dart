// ignore_for_file: type=lint, type=warning






part of 'pro_upgrade_request.dart';






T _$identity<T>(T value) => value;


mixin _$ProUpgradeRequest {

 String? get id;@JsonKey(name: 'user_id') String get userId; String get status;@JsonKey(name: 'created_at') String get createdAt;


@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProUpgradeRequestCopyWith<ProUpgradeRequest> get copyWith => _$ProUpgradeRequestCopyWithImpl<ProUpgradeRequest>(this as ProUpgradeRequest, _$identity);

  
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


abstract mixin class $ProUpgradeRequestCopyWith<$Res>  {
  factory $ProUpgradeRequestCopyWith(ProUpgradeRequest value, $Res Function(ProUpgradeRequest) _then) = _$ProUpgradeRequestCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'user_id') String userId, String status,@JsonKey(name: 'created_at') String createdAt
});




}

class _$ProUpgradeRequestCopyWithImpl<$Res>
    implements $ProUpgradeRequestCopyWith<$Res> {
  _$ProUpgradeRequestCopyWithImpl(this._self, this._then);

  final ProUpgradeRequest _self;
  final $Res Function(ProUpgradeRequest) _then;



@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id 
as String?,userId: null == userId ? _self.userId : userId 
as String,status: null == status ? _self.status : status 
as String,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,
  ));
}

}



extension ProUpgradeRequestPatterns on ProUpgradeRequest {












@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProUpgradeRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProUpgradeRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}













@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProUpgradeRequest value)  $default,){
final _that = this;
switch (_that) {
case _ProUpgradeRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProUpgradeRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ProUpgradeRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}












@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'user_id')  String userId,  String status, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProUpgradeRequest() when $default != null:
return $default(_that.id,_that.userId,_that.status,_that.createdAt);case _:
  return orElse();

}
}













@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'user_id')  String userId,  String status, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _ProUpgradeRequest():
return $default(_that.id,_that.userId,_that.status,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'user_id')  String userId,  String status, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ProUpgradeRequest() when $default != null:
return $default(_that.id,_that.userId,_that.status,_that.createdAt);case _:
  return null;

}
}

}


@JsonSerializable()

class _ProUpgradeRequest implements ProUpgradeRequest {
  const _ProUpgradeRequest({this.id, @JsonKey(name: 'user_id') required this.userId, this.status = 'pending_documents', @JsonKey(name: 'created_at') required this.createdAt});
  factory _ProUpgradeRequest.fromJson(Map<String, dynamic> json) => _$ProUpgradeRequestFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'created_at') final  String createdAt;



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


abstract mixin class _$ProUpgradeRequestCopyWith<$Res> implements $ProUpgradeRequestCopyWith<$Res> {
  factory _$ProUpgradeRequestCopyWith(_ProUpgradeRequest value, $Res Function(_ProUpgradeRequest) _then) = __$ProUpgradeRequestCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'user_id') String userId, String status,@JsonKey(name: 'created_at') String createdAt
});




}

class __$ProUpgradeRequestCopyWithImpl<$Res>
    implements _$ProUpgradeRequestCopyWith<$Res> {
  __$ProUpgradeRequestCopyWithImpl(this._self, this._then);

  final _ProUpgradeRequest _self;
  final $Res Function(_ProUpgradeRequest) _then;



@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_ProUpgradeRequest(
id: freezed == id ? _self.id : id 
as String?,userId: null == userId ? _self.userId : userId 
as String,status: null == status ? _self.status : status 
as String,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,
  ));
}


}



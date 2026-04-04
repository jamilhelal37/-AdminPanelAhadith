// ignore_for_file: type=lint, type=warning






part of 'favorite.dart';






T _$identity<T>(T value) => value;


mixin _$Favorite {

 String? get id;@JsonKey(name: 'user') String? get userId;@JsonKey(name: 'hadith') String? get hadithId;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;


@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteCopyWith<Favorite> get copyWith => _$FavoriteCopyWithImpl<Favorite>(this as Favorite, _$identity);

  
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Favorite&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.hadithId, hadithId) || other.hadithId == hadithId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,hadithId,createdAt,updatedAt);

@override
String toString() {
  return 'Favorite(id: $id, userId: $userId, hadithId: $hadithId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}


abstract mixin class $FavoriteCopyWith<$Res>  {
  factory $FavoriteCopyWith(Favorite value, $Res Function(Favorite) _then) = _$FavoriteCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'user') String? userId,@JsonKey(name: 'hadith') String? hadithId,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class _$FavoriteCopyWithImpl<$Res>
    implements $FavoriteCopyWith<$Res> {
  _$FavoriteCopyWithImpl(this._self, this._then);

  final Favorite _self;
  final $Res Function(Favorite) _then;



@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? hadithId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id 
as String?,userId: freezed == userId ? _self.userId : userId 
as String?,hadithId: freezed == hadithId ? _self.hadithId : hadithId 
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}

}



extension FavoritePatterns on Favorite {












@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Favorite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Favorite() when $default != null:
return $default(_that);case _:
  return orElse();

}
}













@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Favorite value)  $default,){
final _that = this;
switch (_that) {
case _Favorite():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Favorite value)?  $default,){
final _that = this;
switch (_that) {
case _Favorite() when $default != null:
return $default(_that);case _:
  return null;

}
}












@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'user')  String? userId, @JsonKey(name: 'hadith')  String? hadithId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Favorite() when $default != null:
return $default(_that.id,_that.userId,_that.hadithId,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}













@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'user')  String? userId, @JsonKey(name: 'hadith')  String? hadithId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Favorite():
return $default(_that.id,_that.userId,_that.hadithId,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'user')  String? userId, @JsonKey(name: 'hadith')  String? hadithId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Favorite() when $default != null:
return $default(_that.id,_that.userId,_that.hadithId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}


@JsonSerializable()

class _Favorite implements Favorite {
  const _Favorite({this.id, @JsonKey(name: 'user') this.userId, @JsonKey(name: 'hadith') this.hadithId, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _Favorite.fromJson(Map<String, dynamic> json) => _$FavoriteFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'user') final  String? userId;
@override@JsonKey(name: 'hadith') final  String? hadithId;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;



@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteCopyWith<_Favorite> get copyWith => __$FavoriteCopyWithImpl<_Favorite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Favorite&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.hadithId, hadithId) || other.hadithId == hadithId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,hadithId,createdAt,updatedAt);

@override
String toString() {
  return 'Favorite(id: $id, userId: $userId, hadithId: $hadithId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}


abstract mixin class _$FavoriteCopyWith<$Res> implements $FavoriteCopyWith<$Res> {
  factory _$FavoriteCopyWith(_Favorite value, $Res Function(_Favorite) _then) = __$FavoriteCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'user') String? userId,@JsonKey(name: 'hadith') String? hadithId,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class __$FavoriteCopyWithImpl<$Res>
    implements _$FavoriteCopyWith<$Res> {
  __$FavoriteCopyWithImpl(this._self, this._then);

  final _Favorite _self;
  final $Res Function(_Favorite) _then;



@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? hadithId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Favorite(
id: freezed == id ? _self.id : id 
as String?,userId: freezed == userId ? _self.userId : userId 
as String?,hadithId: freezed == hadithId ? _self.hadithId : hadithId 
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}


}



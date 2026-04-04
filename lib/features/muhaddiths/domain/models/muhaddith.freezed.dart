// ignore_for_file: type=lint, type=warning






part of 'muhaddith.dart';






T _$identity<T>(T value) => value;


mixin _$Muhaddith {

 String? get id; String get name; Gender get gender; String get about;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;


@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MuhaddithCopyWith<Muhaddith> get copyWith => _$MuhaddithCopyWithImpl<Muhaddith>(this as Muhaddith, _$identity);

  
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Muhaddith&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.about, about) || other.about == about)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,gender,about,createdAt,updatedAt);

@override
String toString() {
  return 'Muhaddith(id: $id, name: $name, gender: $gender, about: $about, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}


abstract mixin class $MuhaddithCopyWith<$Res>  {
  factory $MuhaddithCopyWith(Muhaddith value, $Res Function(Muhaddith) _then) = _$MuhaddithCopyWithImpl;
@useResult
$Res call({
 String? id, String name, Gender gender, String about,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class _$MuhaddithCopyWithImpl<$Res>
    implements $MuhaddithCopyWith<$Res> {
  _$MuhaddithCopyWithImpl(this._self, this._then);

  final Muhaddith _self;
  final $Res Function(Muhaddith) _then;



@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? gender = null,Object? about = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id 
as String?,name: null == name ? _self.name : name 
as String,gender: null == gender ? _self.gender : gender 
as Gender,about: null == about ? _self.about : about 
as String,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}

}



extension MuhaddithPatterns on Muhaddith {












@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Muhaddith value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Muhaddith() when $default != null:
return $default(_that);case _:
  return orElse();

}
}













@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Muhaddith value)  $default,){
final _that = this;
switch (_that) {
case _Muhaddith():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Muhaddith value)?  $default,){
final _that = this;
switch (_that) {
case _Muhaddith() when $default != null:
return $default(_that);case _:
  return null;

}
}












@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String name,  Gender gender,  String about, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Muhaddith() when $default != null:
return $default(_that.id,_that.name,_that.gender,_that.about,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}













@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String name,  Gender gender,  String about, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Muhaddith():
return $default(_that.id,_that.name,_that.gender,_that.about,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String name,  Gender gender,  String about, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Muhaddith() when $default != null:
return $default(_that.id,_that.name,_that.gender,_that.about,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}


@JsonSerializable()

class _Muhaddith implements Muhaddith {
  const _Muhaddith({this.id, required this.name, required this.gender, required this.about, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _Muhaddith.fromJson(Map<String, dynamic> json) => _$MuhaddithFromJson(json);

@override final  String? id;
@override final  String name;
@override final  Gender gender;
@override final  String about;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;



@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MuhaddithCopyWith<_Muhaddith> get copyWith => __$MuhaddithCopyWithImpl<_Muhaddith>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MuhaddithToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Muhaddith&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.about, about) || other.about == about)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,gender,about,createdAt,updatedAt);

@override
String toString() {
  return 'Muhaddith(id: $id, name: $name, gender: $gender, about: $about, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}


abstract mixin class _$MuhaddithCopyWith<$Res> implements $MuhaddithCopyWith<$Res> {
  factory _$MuhaddithCopyWith(_Muhaddith value, $Res Function(_Muhaddith) _then) = __$MuhaddithCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name, Gender gender, String about,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class __$MuhaddithCopyWithImpl<$Res>
    implements _$MuhaddithCopyWith<$Res> {
  __$MuhaddithCopyWithImpl(this._self, this._then);

  final _Muhaddith _self;
  final $Res Function(_Muhaddith) _then;



@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? gender = null,Object? about = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Muhaddith(
id: freezed == id ? _self.id : id 
as String?,name: null == name ? _self.name : name 
as String,gender: null == gender ? _self.gender : gender 
as Gender,about: null == about ? _self.about : about 
as String,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}


}



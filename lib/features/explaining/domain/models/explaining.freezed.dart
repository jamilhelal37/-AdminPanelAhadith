// ignore_for_file: type=lint, type=warning






part of 'explaining.dart';






T _$identity<T>(T value) => value;


mixin _$Explaining {

 String? get id; String get text;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;


@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExplainingCopyWith<Explaining> get copyWith => _$ExplainingCopyWithImpl<Explaining>(this as Explaining, _$identity);

  
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Explaining&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,createdAt,updatedAt);

@override
String toString() {
  return 'Explaining(id: $id, text: $text, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}


abstract mixin class $ExplainingCopyWith<$Res>  {
  factory $ExplainingCopyWith(Explaining value, $Res Function(Explaining) _then) = _$ExplainingCopyWithImpl;
@useResult
$Res call({
 String? id, String text,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class _$ExplainingCopyWithImpl<$Res>
    implements $ExplainingCopyWith<$Res> {
  _$ExplainingCopyWithImpl(this._self, this._then);

  final Explaining _self;
  final $Res Function(Explaining) _then;



@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? text = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id 
as String?,text: null == text ? _self.text : text 
as String,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}

}



extension ExplainingPatterns on Explaining {












@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Explaining value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Explaining() when $default != null:
return $default(_that);case _:
  return orElse();

}
}













@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Explaining value)  $default,){
final _that = this;
switch (_that) {
case _Explaining():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Explaining value)?  $default,){
final _that = this;
switch (_that) {
case _Explaining() when $default != null:
return $default(_that);case _:
  return null;

}
}












@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String text, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Explaining() when $default != null:
return $default(_that.id,_that.text,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}













@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String text, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Explaining():
return $default(_that.id,_that.text,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String text, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Explaining() when $default != null:
return $default(_that.id,_that.text,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}


@JsonSerializable()

class _Explaining implements Explaining {
  const _Explaining({this.id, required this.text, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _Explaining.fromJson(Map<String, dynamic> json) => _$ExplainingFromJson(json);

@override final  String? id;
@override final  String text;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;



@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExplainingCopyWith<_Explaining> get copyWith => __$ExplainingCopyWithImpl<_Explaining>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExplainingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Explaining&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,createdAt,updatedAt);

@override
String toString() {
  return 'Explaining(id: $id, text: $text, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}


abstract mixin class _$ExplainingCopyWith<$Res> implements $ExplainingCopyWith<$Res> {
  factory _$ExplainingCopyWith(_Explaining value, $Res Function(_Explaining) _then) = __$ExplainingCopyWithImpl;
@override @useResult
$Res call({
 String? id, String text,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class __$ExplainingCopyWithImpl<$Res>
    implements _$ExplainingCopyWith<$Res> {
  __$ExplainingCopyWithImpl(this._self, this._then);

  final _Explaining _self;
  final $Res Function(_Explaining) _then;



@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? text = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Explaining(
id: freezed == id ? _self.id : id 
as String?,text: null == text ? _self.text : text 
as String,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}


}



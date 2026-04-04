// ignore_for_file: type=lint, type=warning






part of 'book.dart';






T _$identity<T>(T value) => value;


mixin _$Book {

 String? get id; String get name;@JsonKey(name: 'muhaddith') String? get muhaddithId;@JsonKey(name: 'muhaddith_rel', includeToJson: false) Map<String, dynamic>? get muhaddithRel;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;


@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookCopyWith<Book> get copyWith => _$BookCopyWithImpl<Book>(this as Book, _$identity);

  
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Book&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.muhaddithId, muhaddithId) || other.muhaddithId == muhaddithId)&&const DeepCollectionEquality().equals(other.muhaddithRel, muhaddithRel)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,muhaddithId,const DeepCollectionEquality().hash(muhaddithRel),createdAt,updatedAt);

@override
String toString() {
  return 'Book(id: $id, name: $name, muhaddithId: $muhaddithId, muhaddithRel: $muhaddithRel, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}


abstract mixin class $BookCopyWith<$Res>  {
  factory $BookCopyWith(Book value, $Res Function(Book) _then) = _$BookCopyWithImpl;
@useResult
$Res call({
 String? id, String name,@JsonKey(name: 'muhaddith') String? muhaddithId,@JsonKey(name: 'muhaddith_rel', includeToJson: false) Map<String, dynamic>? muhaddithRel,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class _$BookCopyWithImpl<$Res>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._self, this._then);

  final Book _self;
  final $Res Function(Book) _then;



@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? muhaddithId = freezed,Object? muhaddithRel = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id 
as String?,name: null == name ? _self.name : name 
as String,muhaddithId: freezed == muhaddithId ? _self.muhaddithId : muhaddithId 
as String?,muhaddithRel: freezed == muhaddithRel ? _self.muhaddithRel : muhaddithRel 
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}

}



extension BookPatterns on Book {












@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Book value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that);case _:
  return orElse();

}
}













@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Book value)  $default,){
final _that = this;
switch (_that) {
case _Book():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Book value)?  $default,){
final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that);case _:
  return null;

}
}












@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String name, @JsonKey(name: 'muhaddith')  String? muhaddithId, @JsonKey(name: 'muhaddith_rel', includeToJson: false)  Map<String, dynamic>? muhaddithRel, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.name,_that.muhaddithId,_that.muhaddithRel,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}













@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String name, @JsonKey(name: 'muhaddith')  String? muhaddithId, @JsonKey(name: 'muhaddith_rel', includeToJson: false)  Map<String, dynamic>? muhaddithRel, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Book():
return $default(_that.id,_that.name,_that.muhaddithId,_that.muhaddithRel,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String name, @JsonKey(name: 'muhaddith')  String? muhaddithId, @JsonKey(name: 'muhaddith_rel', includeToJson: false)  Map<String, dynamic>? muhaddithRel, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.name,_that.muhaddithId,_that.muhaddithRel,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}


@JsonSerializable()

class _Book extends Book {
  const _Book({this.id, required this.name, @JsonKey(name: 'muhaddith') this.muhaddithId, @JsonKey(name: 'muhaddith_rel', includeToJson: false) final  Map<String, dynamic>? muhaddithRel, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): _muhaddithRel = muhaddithRel,super._();
  factory _Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

@override final  String? id;
@override final  String name;
@override@JsonKey(name: 'muhaddith') final  String? muhaddithId;
 final  Map<String, dynamic>? _muhaddithRel;
@override@JsonKey(name: 'muhaddith_rel', includeToJson: false) Map<String, dynamic>? get muhaddithRel {
  final value = _muhaddithRel;
  if (value == null) return null;
  if (_muhaddithRel is EqualUnmodifiableMapView) return _muhaddithRel;
  
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;



@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookCopyWith<_Book> get copyWith => __$BookCopyWithImpl<_Book>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Book&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.muhaddithId, muhaddithId) || other.muhaddithId == muhaddithId)&&const DeepCollectionEquality().equals(other._muhaddithRel, _muhaddithRel)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,muhaddithId,const DeepCollectionEquality().hash(_muhaddithRel),createdAt,updatedAt);

@override
String toString() {
  return 'Book(id: $id, name: $name, muhaddithId: $muhaddithId, muhaddithRel: $muhaddithRel, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}


abstract mixin class _$BookCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$BookCopyWith(_Book value, $Res Function(_Book) _then) = __$BookCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name,@JsonKey(name: 'muhaddith') String? muhaddithId,@JsonKey(name: 'muhaddith_rel', includeToJson: false) Map<String, dynamic>? muhaddithRel,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class __$BookCopyWithImpl<$Res>
    implements _$BookCopyWith<$Res> {
  __$BookCopyWithImpl(this._self, this._then);

  final _Book _self;
  final $Res Function(_Book) _then;



@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? muhaddithId = freezed,Object? muhaddithRel = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Book(
id: freezed == id ? _self.id : id 
as String?,name: null == name ? _self.name : name 
as String,muhaddithId: freezed == muhaddithId ? _self.muhaddithId : muhaddithId 
as String?,muhaddithRel: freezed == muhaddithRel ? _self._muhaddithRel : muhaddithRel 
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}


}



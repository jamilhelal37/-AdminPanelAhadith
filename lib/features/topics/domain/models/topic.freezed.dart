// ignore_for_file: type=lint, type=warning






part of 'topic.dart';






T _$identity<T>(T value) => value;


mixin _$Topic {

 String? get id; String get name;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;


@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopicCopyWith<Topic> get copyWith => _$TopicCopyWithImpl<Topic>(this as Topic, _$identity);

  
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Topic&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,createdAt,updatedAt);

@override
String toString() {
  return 'Topic(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}


abstract mixin class $TopicCopyWith<$Res>  {
  factory $TopicCopyWith(Topic value, $Res Function(Topic) _then) = _$TopicCopyWithImpl;
@useResult
$Res call({
 String? id, String name,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class _$TopicCopyWithImpl<$Res>
    implements $TopicCopyWith<$Res> {
  _$TopicCopyWithImpl(this._self, this._then);

  final Topic _self;
  final $Res Function(Topic) _then;



@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id 
as String?,name: null == name ? _self.name : name 
as String,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}

}



extension TopicPatterns on Topic {












@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Topic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Topic() when $default != null:
return $default(_that);case _:
  return orElse();

}
}













@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Topic value)  $default,){
final _that = this;
switch (_that) {
case _Topic():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Topic value)?  $default,){
final _that = this;
switch (_that) {
case _Topic() when $default != null:
return $default(_that);case _:
  return null;

}
}












@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String name, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Topic() when $default != null:
return $default(_that.id,_that.name,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}













@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String name, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Topic():
return $default(_that.id,_that.name,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String name, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Topic() when $default != null:
return $default(_that.id,_that.name,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}


@JsonSerializable()

class _Topic implements Topic {
  const _Topic({this.id, required this.name, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

@override final  String? id;
@override final  String name;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;



@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicCopyWith<_Topic> get copyWith => __$TopicCopyWithImpl<_Topic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Topic&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,createdAt,updatedAt);

@override
String toString() {
  return 'Topic(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}


abstract mixin class _$TopicCopyWith<$Res> implements $TopicCopyWith<$Res> {
  factory _$TopicCopyWith(_Topic value, $Res Function(_Topic) _then) = __$TopicCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class __$TopicCopyWithImpl<$Res>
    implements _$TopicCopyWith<$Res> {
  __$TopicCopyWithImpl(this._self, this._then);

  final _Topic _self;
  final $Res Function(_Topic) _then;



@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Topic(
id: freezed == id ? _self.id : id 
as String?,name: null == name ? _self.name : name 
as String,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}


}



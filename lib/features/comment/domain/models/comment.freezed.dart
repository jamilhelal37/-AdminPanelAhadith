// ignore_for_file: type=lint, type=warning






part of 'comment.dart';






T _$identity<T>(T value) => value;


mixin _$Comment {

 String? get id;@JsonKey(name: 'hadith') String? get hadithId;@JsonKey(name: 'user') String? get userId; String get text;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;


@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentCopyWith<Comment> get copyWith => _$CommentCopyWithImpl<Comment>(this as Comment, _$identity);

  
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Comment&&(identical(other.id, id) || other.id == id)&&(identical(other.hadithId, hadithId) || other.hadithId == hadithId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hadithId,userId,text,createdAt,updatedAt);

@override
String toString() {
  return 'Comment(id: $id, hadithId: $hadithId, userId: $userId, text: $text, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}


abstract mixin class $CommentCopyWith<$Res>  {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) _then) = _$CommentCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'hadith') String? hadithId,@JsonKey(name: 'user') String? userId, String text,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class _$CommentCopyWithImpl<$Res>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._self, this._then);

  final Comment _self;
  final $Res Function(Comment) _then;



@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? hadithId = freezed,Object? userId = freezed,Object? text = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id 
as String?,hadithId: freezed == hadithId ? _self.hadithId : hadithId 
as String?,userId: freezed == userId ? _self.userId : userId 
as String?,text: null == text ? _self.text : text 
as String,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}

}



extension CommentPatterns on Comment {












@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Comment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that);case _:
  return orElse();

}
}













@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Comment value)  $default,){
final _that = this;
switch (_that) {
case _Comment():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Comment value)?  $default,){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that);case _:
  return null;

}
}












@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'hadith')  String? hadithId, @JsonKey(name: 'user')  String? userId,  String text, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.id,_that.hadithId,_that.userId,_that.text,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}













@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'hadith')  String? hadithId, @JsonKey(name: 'user')  String? userId,  String text, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Comment():
return $default(_that.id,_that.hadithId,_that.userId,_that.text,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'hadith')  String? hadithId, @JsonKey(name: 'user')  String? userId,  String text, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.id,_that.hadithId,_that.userId,_that.text,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}


@JsonSerializable()

class _Comment implements Comment {
  const _Comment({this.id, @JsonKey(name: 'hadith') this.hadithId, @JsonKey(name: 'user') this.userId, required this.text, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'hadith') final  String? hadithId;
@override@JsonKey(name: 'user') final  String? userId;
@override final  String text;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;



@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentCopyWith<_Comment> get copyWith => __$CommentCopyWithImpl<_Comment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Comment&&(identical(other.id, id) || other.id == id)&&(identical(other.hadithId, hadithId) || other.hadithId == hadithId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hadithId,userId,text,createdAt,updatedAt);

@override
String toString() {
  return 'Comment(id: $id, hadithId: $hadithId, userId: $userId, text: $text, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}


abstract mixin class _$CommentCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$CommentCopyWith(_Comment value, $Res Function(_Comment) _then) = __$CommentCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'hadith') String? hadithId,@JsonKey(name: 'user') String? userId, String text,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class __$CommentCopyWithImpl<$Res>
    implements _$CommentCopyWith<$Res> {
  __$CommentCopyWithImpl(this._self, this._then);

  final _Comment _self;
  final $Res Function(_Comment) _then;



@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? hadithId = freezed,Object? userId = freezed,Object? text = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Comment(
id: freezed == id ? _self.id : id 
as String?,hadithId: freezed == hadithId ? _self.hadithId : hadithId 
as String?,userId: freezed == userId ? _self.userId : userId 
as String?,text: null == text ? _self.text : text 
as String,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}


}



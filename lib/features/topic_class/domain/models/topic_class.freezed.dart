// ignore_for_file: type=lint, type=warning






part of 'topic_class.dart';






T _$identity<T>(T value) => value;


mixin _$TopicClass {

 String? get id;@JsonKey(name: 'topic') String? get topicId;@JsonKey(name: 'hadith') String? get hadithId;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;
@JsonKey(name: 'topic_name') String? get topicName;@JsonKey(name: 'hadith_text') String? get hadithText;@JsonKey(name: 'hadith_number') int? get hadithNumber;@JsonKey(name: 'book_name') String? get bookName;


@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopicClassCopyWith<TopicClass> get copyWith => _$TopicClassCopyWithImpl<TopicClass>(this as TopicClass, _$identity);

  
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopicClass&&(identical(other.id, id) || other.id == id)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.hadithId, hadithId) || other.hadithId == hadithId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.topicName, topicName) || other.topicName == topicName)&&(identical(other.hadithText, hadithText) || other.hadithText == hadithText)&&(identical(other.hadithNumber, hadithNumber) || other.hadithNumber == hadithNumber)&&(identical(other.bookName, bookName) || other.bookName == bookName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,topicId,hadithId,createdAt,updatedAt,topicName,hadithText,hadithNumber,bookName);

@override
String toString() {
  return 'TopicClass(id: $id, topicId: $topicId, hadithId: $hadithId, createdAt: $createdAt, updatedAt: $updatedAt, topicName: $topicName, hadithText: $hadithText, hadithNumber: $hadithNumber, bookName: $bookName)';
}


}


abstract mixin class $TopicClassCopyWith<$Res>  {
  factory $TopicClassCopyWith(TopicClass value, $Res Function(TopicClass) _then) = _$TopicClassCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'topic') String? topicId,@JsonKey(name: 'hadith') String? hadithId,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'topic_name') String? topicName,@JsonKey(name: 'hadith_text') String? hadithText,@JsonKey(name: 'hadith_number') int? hadithNumber,@JsonKey(name: 'book_name') String? bookName
});




}

class _$TopicClassCopyWithImpl<$Res>
    implements $TopicClassCopyWith<$Res> {
  _$TopicClassCopyWithImpl(this._self, this._then);

  final TopicClass _self;
  final $Res Function(TopicClass) _then;



@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? topicId = freezed,Object? hadithId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? topicName = freezed,Object? hadithText = freezed,Object? hadithNumber = freezed,Object? bookName = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id 
as String?,topicId: freezed == topicId ? _self.topicId : topicId 
as String?,hadithId: freezed == hadithId ? _self.hadithId : hadithId 
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,topicName: freezed == topicName ? _self.topicName : topicName 
as String?,hadithText: freezed == hadithText ? _self.hadithText : hadithText 
as String?,hadithNumber: freezed == hadithNumber ? _self.hadithNumber : hadithNumber 
as int?,bookName: freezed == bookName ? _self.bookName : bookName 
as String?,
  ));
}

}



extension TopicClassPatterns on TopicClass {












@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopicClass value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopicClass() when $default != null:
return $default(_that);case _:
  return orElse();

}
}













@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopicClass value)  $default,){
final _that = this;
switch (_that) {
case _TopicClass():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopicClass value)?  $default,){
final _that = this;
switch (_that) {
case _TopicClass() when $default != null:
return $default(_that);case _:
  return null;

}
}












@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'topic')  String? topicId, @JsonKey(name: 'hadith')  String? hadithId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'topic_name')  String? topicName, @JsonKey(name: 'hadith_text')  String? hadithText, @JsonKey(name: 'hadith_number')  int? hadithNumber, @JsonKey(name: 'book_name')  String? bookName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopicClass() when $default != null:
return $default(_that.id,_that.topicId,_that.hadithId,_that.createdAt,_that.updatedAt,_that.topicName,_that.hadithText,_that.hadithNumber,_that.bookName);case _:
  return orElse();

}
}













@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'topic')  String? topicId, @JsonKey(name: 'hadith')  String? hadithId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'topic_name')  String? topicName, @JsonKey(name: 'hadith_text')  String? hadithText, @JsonKey(name: 'hadith_number')  int? hadithNumber, @JsonKey(name: 'book_name')  String? bookName)  $default,) {final _that = this;
switch (_that) {
case _TopicClass():
return $default(_that.id,_that.topicId,_that.hadithId,_that.createdAt,_that.updatedAt,_that.topicName,_that.hadithText,_that.hadithNumber,_that.bookName);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'topic')  String? topicId, @JsonKey(name: 'hadith')  String? hadithId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'topic_name')  String? topicName, @JsonKey(name: 'hadith_text')  String? hadithText, @JsonKey(name: 'hadith_number')  int? hadithNumber, @JsonKey(name: 'book_name')  String? bookName)?  $default,) {final _that = this;
switch (_that) {
case _TopicClass() when $default != null:
return $default(_that.id,_that.topicId,_that.hadithId,_that.createdAt,_that.updatedAt,_that.topicName,_that.hadithText,_that.hadithNumber,_that.bookName);case _:
  return null;

}
}

}


@JsonSerializable()

class _TopicClass implements TopicClass {
  const _TopicClass({this.id, @JsonKey(name: 'topic') this.topicId, @JsonKey(name: 'hadith') this.hadithId, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'topic_name') this.topicName, @JsonKey(name: 'hadith_text') this.hadithText, @JsonKey(name: 'hadith_number') this.hadithNumber, @JsonKey(name: 'book_name') this.bookName});
  factory _TopicClass.fromJson(Map<String, dynamic> json) => _$TopicClassFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'topic') final  String? topicId;
@override@JsonKey(name: 'hadith') final  String? hadithId;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;

@override@JsonKey(name: 'topic_name') final  String? topicName;
@override@JsonKey(name: 'hadith_text') final  String? hadithText;
@override@JsonKey(name: 'hadith_number') final  int? hadithNumber;
@override@JsonKey(name: 'book_name') final  String? bookName;



@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicClassCopyWith<_TopicClass> get copyWith => __$TopicClassCopyWithImpl<_TopicClass>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopicClassToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopicClass&&(identical(other.id, id) || other.id == id)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.hadithId, hadithId) || other.hadithId == hadithId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.topicName, topicName) || other.topicName == topicName)&&(identical(other.hadithText, hadithText) || other.hadithText == hadithText)&&(identical(other.hadithNumber, hadithNumber) || other.hadithNumber == hadithNumber)&&(identical(other.bookName, bookName) || other.bookName == bookName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,topicId,hadithId,createdAt,updatedAt,topicName,hadithText,hadithNumber,bookName);

@override
String toString() {
  return 'TopicClass(id: $id, topicId: $topicId, hadithId: $hadithId, createdAt: $createdAt, updatedAt: $updatedAt, topicName: $topicName, hadithText: $hadithText, hadithNumber: $hadithNumber, bookName: $bookName)';
}


}


abstract mixin class _$TopicClassCopyWith<$Res> implements $TopicClassCopyWith<$Res> {
  factory _$TopicClassCopyWith(_TopicClass value, $Res Function(_TopicClass) _then) = __$TopicClassCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'topic') String? topicId,@JsonKey(name: 'hadith') String? hadithId,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'topic_name') String? topicName,@JsonKey(name: 'hadith_text') String? hadithText,@JsonKey(name: 'hadith_number') int? hadithNumber,@JsonKey(name: 'book_name') String? bookName
});




}

class __$TopicClassCopyWithImpl<$Res>
    implements _$TopicClassCopyWith<$Res> {
  __$TopicClassCopyWithImpl(this._self, this._then);

  final _TopicClass _self;
  final $Res Function(_TopicClass) _then;



@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? topicId = freezed,Object? hadithId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? topicName = freezed,Object? hadithText = freezed,Object? hadithNumber = freezed,Object? bookName = freezed,}) {
  return _then(_TopicClass(
id: freezed == id ? _self.id : id 
as String?,topicId: freezed == topicId ? _self.topicId : topicId 
as String?,hadithId: freezed == hadithId ? _self.hadithId : hadithId 
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,topicName: freezed == topicName ? _self.topicName : topicName 
as String?,hadithText: freezed == hadithText ? _self.hadithText : hadithText 
as String?,hadithNumber: freezed == hadithNumber ? _self.hadithNumber : hadithNumber 
as int?,bookName: freezed == bookName ? _self.bookName : bookName 
as String?,
  ));
}


}



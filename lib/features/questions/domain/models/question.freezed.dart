// ignore_for_file: type=lint, type=warning






part of 'question.dart';






T _$identity<T>(T value) => value;


mixin _$Question {

 String? get id;@JsonKey(name: 'asker') String? get askerId;@JsonKey(name: 'asker_text') String get askerText;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'answer_text') String? get answerText;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;


@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionCopyWith<Question> get copyWith => _$QuestionCopyWithImpl<Question>(this as Question, _$identity);

  
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Question&&(identical(other.id, id) || other.id == id)&&(identical(other.askerId, askerId) || other.askerId == askerId)&&(identical(other.askerText, askerText) || other.askerText == askerText)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.answerText, answerText) || other.answerText == answerText)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,askerId,askerText,isActive,answerText,createdAt,updatedAt);

@override
String toString() {
  return 'Question(id: $id, askerId: $askerId, askerText: $askerText, isActive: $isActive, answerText: $answerText, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}


abstract mixin class $QuestionCopyWith<$Res>  {
  factory $QuestionCopyWith(Question value, $Res Function(Question) _then) = _$QuestionCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'asker') String? askerId,@JsonKey(name: 'asker_text') String askerText,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'answer_text') String? answerText,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class _$QuestionCopyWithImpl<$Res>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._self, this._then);

  final Question _self;
  final $Res Function(Question) _then;



@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? askerId = freezed,Object? askerText = null,Object? isActive = null,Object? answerText = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id 
as String?,askerId: freezed == askerId ? _self.askerId : askerId 
as String?,askerText: null == askerText ? _self.askerText : askerText 
as String,isActive: null == isActive ? _self.isActive : isActive 
as bool,answerText: freezed == answerText ? _self.answerText : answerText 
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}

}



extension QuestionPatterns on Question {












@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Question value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that);case _:
  return orElse();

}
}













@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Question value)  $default,){
final _that = this;
switch (_that) {
case _Question():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Question value)?  $default,){
final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that);case _:
  return null;

}
}












@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'asker')  String? askerId, @JsonKey(name: 'asker_text')  String askerText, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'answer_text')  String? answerText, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.id,_that.askerId,_that.askerText,_that.isActive,_that.answerText,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}













@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'asker')  String? askerId, @JsonKey(name: 'asker_text')  String askerText, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'answer_text')  String? answerText, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Question():
return $default(_that.id,_that.askerId,_that.askerText,_that.isActive,_that.answerText,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'asker')  String? askerId, @JsonKey(name: 'asker_text')  String askerText, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'answer_text')  String? answerText, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.id,_that.askerId,_that.askerText,_that.isActive,_that.answerText,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}


@JsonSerializable()

class _Question implements Question {
  const _Question({this.id, @JsonKey(name: 'asker') this.askerId, @JsonKey(name: 'asker_text') required this.askerText, @JsonKey(name: 'is_active') this.isActive = false, @JsonKey(name: 'answer_text') this.answerText, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'asker') final  String? askerId;
@override@JsonKey(name: 'asker_text') final  String askerText;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'answer_text') final  String? answerText;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;



@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionCopyWith<_Question> get copyWith => __$QuestionCopyWithImpl<_Question>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Question&&(identical(other.id, id) || other.id == id)&&(identical(other.askerId, askerId) || other.askerId == askerId)&&(identical(other.askerText, askerText) || other.askerText == askerText)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.answerText, answerText) || other.answerText == answerText)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,askerId,askerText,isActive,answerText,createdAt,updatedAt);

@override
String toString() {
  return 'Question(id: $id, askerId: $askerId, askerText: $askerText, isActive: $isActive, answerText: $answerText, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}


abstract mixin class _$QuestionCopyWith<$Res> implements $QuestionCopyWith<$Res> {
  factory _$QuestionCopyWith(_Question value, $Res Function(_Question) _then) = __$QuestionCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'asker') String? askerId,@JsonKey(name: 'asker_text') String askerText,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'answer_text') String? answerText,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class __$QuestionCopyWithImpl<$Res>
    implements _$QuestionCopyWith<$Res> {
  __$QuestionCopyWithImpl(this._self, this._then);

  final _Question _self;
  final $Res Function(_Question) _then;



@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? askerId = freezed,Object? askerText = null,Object? isActive = null,Object? answerText = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Question(
id: freezed == id ? _self.id : id 
as String?,askerId: freezed == askerId ? _self.askerId : askerId 
as String?,askerText: null == askerText ? _self.askerText : askerText 
as String,isActive: null == isActive ? _self.isActive : isActive 
as bool,answerText: freezed == answerText ? _self.answerText : answerText 
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}


}



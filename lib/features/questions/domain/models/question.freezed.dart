// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Question {

 String? get id;@JsonKey(name: 'asker') String? get askerId;@JsonKey(name: 'asker_text') String get askerText;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'answer_text') String? get answerText;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;
/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionCopyWith<Question> get copyWith => _$QuestionCopyWithImpl<Question>(this as Question, _$identity);

  /// Serializes this Question to a JSON map.
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

/// @nodoc
abstract mixin class $QuestionCopyWith<$Res>  {
  factory $QuestionCopyWith(Question value, $Res Function(Question) _then) = _$QuestionCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'asker') String? askerId,@JsonKey(name: 'asker_text') String askerText,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'answer_text') String? answerText,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class _$QuestionCopyWithImpl<$Res>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._self, this._then);

  final Question _self;
  final $Res Function(Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? askerId = freezed,Object? askerText = null,Object? isActive = null,Object? answerText = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,askerId: freezed == askerId ? _self.askerId : askerId // ignore: cast_nullable_to_non_nullable
as String?,askerText: null == askerText ? _self.askerText : askerText // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,answerText: freezed == answerText ? _self.answerText : answerText // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Question].
extension QuestionPatterns on Question {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Question value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Question value)  $default,){
final _that = this;
switch (_that) {
case _Question():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Question value)?  $default,){
final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'asker')  String? askerId, @JsonKey(name: 'asker_text')  String askerText, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'answer_text')  String? answerText, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.id,_that.askerId,_that.askerText,_that.isActive,_that.answerText,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'asker')  String? askerId, @JsonKey(name: 'asker_text')  String askerText, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'answer_text')  String? answerText, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Question():
return $default(_that.id,_that.askerId,_that.askerText,_that.isActive,_that.answerText,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'asker')  String? askerId, @JsonKey(name: 'asker_text')  String askerText, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'answer_text')  String? answerText, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.id,_that.askerId,_that.askerText,_that.isActive,_that.answerText,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
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

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
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

/// @nodoc
abstract mixin class _$QuestionCopyWith<$Res> implements $QuestionCopyWith<$Res> {
  factory _$QuestionCopyWith(_Question value, $Res Function(_Question) _then) = __$QuestionCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'asker') String? askerId,@JsonKey(name: 'asker_text') String askerText,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'answer_text') String? answerText,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class __$QuestionCopyWithImpl<$Res>
    implements _$QuestionCopyWith<$Res> {
  __$QuestionCopyWithImpl(this._self, this._then);

  final _Question _self;
  final $Res Function(_Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? askerId = freezed,Object? askerText = null,Object? isActive = null,Object? answerText = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Question(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,askerId: freezed == askerId ? _self.askerId : askerId // ignore: cast_nullable_to_non_nullable
as String?,askerText: null == askerText ? _self.askerText : askerText // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,answerText: freezed == answerText ? _self.answerText : answerText // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

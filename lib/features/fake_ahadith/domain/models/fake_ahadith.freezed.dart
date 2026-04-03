// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fake_ahadith.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FakeAhadith {

 String? get id;@JsonKey(name: 'sub_valid') String? get subValid;@JsonKey(includeToJson: false) String? get subValidText; String get text;@JsonKey(name: 'normal_text') String? get normalText;@JsonKey(name: 'search_text') String? get searchText; String? get ruling;@JsonKey(includeToJson: false) String? get rulingName;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;
/// Create a copy of FakeAhadith
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FakeAhadithCopyWith<FakeAhadith> get copyWith => _$FakeAhadithCopyWithImpl<FakeAhadith>(this as FakeAhadith, _$identity);

  /// Serializes this FakeAhadith to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FakeAhadith&&(identical(other.id, id) || other.id == id)&&(identical(other.subValid, subValid) || other.subValid == subValid)&&(identical(other.subValidText, subValidText) || other.subValidText == subValidText)&&(identical(other.text, text) || other.text == text)&&(identical(other.normalText, normalText) || other.normalText == normalText)&&(identical(other.searchText, searchText) || other.searchText == searchText)&&(identical(other.ruling, ruling) || other.ruling == ruling)&&(identical(other.rulingName, rulingName) || other.rulingName == rulingName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subValid,subValidText,text,normalText,searchText,ruling,rulingName,createdAt,updatedAt);

@override
String toString() {
  return 'FakeAhadith(id: $id, subValid: $subValid, subValidText: $subValidText, text: $text, normalText: $normalText, searchText: $searchText, ruling: $ruling, rulingName: $rulingName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FakeAhadithCopyWith<$Res>  {
  factory $FakeAhadithCopyWith(FakeAhadith value, $Res Function(FakeAhadith) _then) = _$FakeAhadithCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'sub_valid') String? subValid,@JsonKey(includeToJson: false) String? subValidText, String text,@JsonKey(name: 'normal_text') String? normalText,@JsonKey(name: 'search_text') String? searchText, String? ruling,@JsonKey(includeToJson: false) String? rulingName,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class _$FakeAhadithCopyWithImpl<$Res>
    implements $FakeAhadithCopyWith<$Res> {
  _$FakeAhadithCopyWithImpl(this._self, this._then);

  final FakeAhadith _self;
  final $Res Function(FakeAhadith) _then;

/// Create a copy of FakeAhadith
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? subValid = freezed,Object? subValidText = freezed,Object? text = null,Object? normalText = freezed,Object? searchText = freezed,Object? ruling = freezed,Object? rulingName = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,subValid: freezed == subValid ? _self.subValid : subValid // ignore: cast_nullable_to_non_nullable
as String?,subValidText: freezed == subValidText ? _self.subValidText : subValidText // ignore: cast_nullable_to_non_nullable
as String?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,normalText: freezed == normalText ? _self.normalText : normalText // ignore: cast_nullable_to_non_nullable
as String?,searchText: freezed == searchText ? _self.searchText : searchText // ignore: cast_nullable_to_non_nullable
as String?,ruling: freezed == ruling ? _self.ruling : ruling // ignore: cast_nullable_to_non_nullable
as String?,rulingName: freezed == rulingName ? _self.rulingName : rulingName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FakeAhadith].
extension FakeAhadithPatterns on FakeAhadith {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FakeAhadith value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FakeAhadith() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FakeAhadith value)  $default,){
final _that = this;
switch (_that) {
case _FakeAhadith():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FakeAhadith value)?  $default,){
final _that = this;
switch (_that) {
case _FakeAhadith() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'sub_valid')  String? subValid, @JsonKey(includeToJson: false)  String? subValidText,  String text, @JsonKey(name: 'normal_text')  String? normalText, @JsonKey(name: 'search_text')  String? searchText,  String? ruling, @JsonKey(includeToJson: false)  String? rulingName, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FakeAhadith() when $default != null:
return $default(_that.id,_that.subValid,_that.subValidText,_that.text,_that.normalText,_that.searchText,_that.ruling,_that.rulingName,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'sub_valid')  String? subValid, @JsonKey(includeToJson: false)  String? subValidText,  String text, @JsonKey(name: 'normal_text')  String? normalText, @JsonKey(name: 'search_text')  String? searchText,  String? ruling, @JsonKey(includeToJson: false)  String? rulingName, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FakeAhadith():
return $default(_that.id,_that.subValid,_that.subValidText,_that.text,_that.normalText,_that.searchText,_that.ruling,_that.rulingName,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'sub_valid')  String? subValid, @JsonKey(includeToJson: false)  String? subValidText,  String text, @JsonKey(name: 'normal_text')  String? normalText, @JsonKey(name: 'search_text')  String? searchText,  String? ruling, @JsonKey(includeToJson: false)  String? rulingName, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FakeAhadith() when $default != null:
return $default(_that.id,_that.subValid,_that.subValidText,_that.text,_that.normalText,_that.searchText,_that.ruling,_that.rulingName,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FakeAhadith implements FakeAhadith {
  const _FakeAhadith({this.id, @JsonKey(name: 'sub_valid') this.subValid, @JsonKey(includeToJson: false) this.subValidText, required this.text, @JsonKey(name: 'normal_text') this.normalText, @JsonKey(name: 'search_text') this.searchText, this.ruling, @JsonKey(includeToJson: false) this.rulingName, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _FakeAhadith.fromJson(Map<String, dynamic> json) => _$FakeAhadithFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'sub_valid') final  String? subValid;
@override@JsonKey(includeToJson: false) final  String? subValidText;
@override final  String text;
@override@JsonKey(name: 'normal_text') final  String? normalText;
@override@JsonKey(name: 'search_text') final  String? searchText;
@override final  String? ruling;
@override@JsonKey(includeToJson: false) final  String? rulingName;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;

/// Create a copy of FakeAhadith
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FakeAhadithCopyWith<_FakeAhadith> get copyWith => __$FakeAhadithCopyWithImpl<_FakeAhadith>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FakeAhadithToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FakeAhadith&&(identical(other.id, id) || other.id == id)&&(identical(other.subValid, subValid) || other.subValid == subValid)&&(identical(other.subValidText, subValidText) || other.subValidText == subValidText)&&(identical(other.text, text) || other.text == text)&&(identical(other.normalText, normalText) || other.normalText == normalText)&&(identical(other.searchText, searchText) || other.searchText == searchText)&&(identical(other.ruling, ruling) || other.ruling == ruling)&&(identical(other.rulingName, rulingName) || other.rulingName == rulingName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subValid,subValidText,text,normalText,searchText,ruling,rulingName,createdAt,updatedAt);

@override
String toString() {
  return 'FakeAhadith(id: $id, subValid: $subValid, subValidText: $subValidText, text: $text, normalText: $normalText, searchText: $searchText, ruling: $ruling, rulingName: $rulingName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FakeAhadithCopyWith<$Res> implements $FakeAhadithCopyWith<$Res> {
  factory _$FakeAhadithCopyWith(_FakeAhadith value, $Res Function(_FakeAhadith) _then) = __$FakeAhadithCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'sub_valid') String? subValid,@JsonKey(includeToJson: false) String? subValidText, String text,@JsonKey(name: 'normal_text') String? normalText,@JsonKey(name: 'search_text') String? searchText, String? ruling,@JsonKey(includeToJson: false) String? rulingName,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class __$FakeAhadithCopyWithImpl<$Res>
    implements _$FakeAhadithCopyWith<$Res> {
  __$FakeAhadithCopyWithImpl(this._self, this._then);

  final _FakeAhadith _self;
  final $Res Function(_FakeAhadith) _then;

/// Create a copy of FakeAhadith
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? subValid = freezed,Object? subValidText = freezed,Object? text = null,Object? normalText = freezed,Object? searchText = freezed,Object? ruling = freezed,Object? rulingName = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_FakeAhadith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,subValid: freezed == subValid ? _self.subValid : subValid // ignore: cast_nullable_to_non_nullable
as String?,subValidText: freezed == subValidText ? _self.subValidText : subValidText // ignore: cast_nullable_to_non_nullable
as String?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,normalText: freezed == normalText ? _self.normalText : normalText // ignore: cast_nullable_to_non_nullable
as String?,searchText: freezed == searchText ? _self.searchText : searchText // ignore: cast_nullable_to_non_nullable
as String?,ruling: freezed == ruling ? _self.ruling : ruling // ignore: cast_nullable_to_non_nullable
as String?,rulingName: freezed == rulingName ? _self.rulingName : rulingName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

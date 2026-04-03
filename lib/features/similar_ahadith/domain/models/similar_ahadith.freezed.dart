// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'similar_ahadith.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SimilarAhadith {

 String? get id;@JsonKey(name: 'main_hadith') String? get mainHadithId;@JsonKey(name: 'sim_hadith') String? get simHadithId;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;// حقول العلاقات (للقراءة فقط)
@JsonKey(includeToJson: false) String? get mainHadithText;@JsonKey(includeToJson: false) int? get mainHadithNumber;@JsonKey(includeToJson: false) String? get mainBookName;@JsonKey(includeToJson: false) String? get simHadithText;@JsonKey(includeToJson: false) int? get simHadithNumber;@JsonKey(includeToJson: false) String? get simBookName;
/// Create a copy of SimilarAhadith
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SimilarAhadithCopyWith<SimilarAhadith> get copyWith => _$SimilarAhadithCopyWithImpl<SimilarAhadith>(this as SimilarAhadith, _$identity);

  /// Serializes this SimilarAhadith to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SimilarAhadith&&(identical(other.id, id) || other.id == id)&&(identical(other.mainHadithId, mainHadithId) || other.mainHadithId == mainHadithId)&&(identical(other.simHadithId, simHadithId) || other.simHadithId == simHadithId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.mainHadithText, mainHadithText) || other.mainHadithText == mainHadithText)&&(identical(other.mainHadithNumber, mainHadithNumber) || other.mainHadithNumber == mainHadithNumber)&&(identical(other.mainBookName, mainBookName) || other.mainBookName == mainBookName)&&(identical(other.simHadithText, simHadithText) || other.simHadithText == simHadithText)&&(identical(other.simHadithNumber, simHadithNumber) || other.simHadithNumber == simHadithNumber)&&(identical(other.simBookName, simBookName) || other.simBookName == simBookName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mainHadithId,simHadithId,createdAt,updatedAt,mainHadithText,mainHadithNumber,mainBookName,simHadithText,simHadithNumber,simBookName);

@override
String toString() {
  return 'SimilarAhadith(id: $id, mainHadithId: $mainHadithId, simHadithId: $simHadithId, createdAt: $createdAt, updatedAt: $updatedAt, mainHadithText: $mainHadithText, mainHadithNumber: $mainHadithNumber, mainBookName: $mainBookName, simHadithText: $simHadithText, simHadithNumber: $simHadithNumber, simBookName: $simBookName)';
}


}

/// @nodoc
abstract mixin class $SimilarAhadithCopyWith<$Res>  {
  factory $SimilarAhadithCopyWith(SimilarAhadith value, $Res Function(SimilarAhadith) _then) = _$SimilarAhadithCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'main_hadith') String? mainHadithId,@JsonKey(name: 'sim_hadith') String? simHadithId,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(includeToJson: false) String? mainHadithText,@JsonKey(includeToJson: false) int? mainHadithNumber,@JsonKey(includeToJson: false) String? mainBookName,@JsonKey(includeToJson: false) String? simHadithText,@JsonKey(includeToJson: false) int? simHadithNumber,@JsonKey(includeToJson: false) String? simBookName
});




}
/// @nodoc
class _$SimilarAhadithCopyWithImpl<$Res>
    implements $SimilarAhadithCopyWith<$Res> {
  _$SimilarAhadithCopyWithImpl(this._self, this._then);

  final SimilarAhadith _self;
  final $Res Function(SimilarAhadith) _then;

/// Create a copy of SimilarAhadith
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? mainHadithId = freezed,Object? simHadithId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? mainHadithText = freezed,Object? mainHadithNumber = freezed,Object? mainBookName = freezed,Object? simHadithText = freezed,Object? simHadithNumber = freezed,Object? simBookName = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,mainHadithId: freezed == mainHadithId ? _self.mainHadithId : mainHadithId // ignore: cast_nullable_to_non_nullable
as String?,simHadithId: freezed == simHadithId ? _self.simHadithId : simHadithId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,mainHadithText: freezed == mainHadithText ? _self.mainHadithText : mainHadithText // ignore: cast_nullable_to_non_nullable
as String?,mainHadithNumber: freezed == mainHadithNumber ? _self.mainHadithNumber : mainHadithNumber // ignore: cast_nullable_to_non_nullable
as int?,mainBookName: freezed == mainBookName ? _self.mainBookName : mainBookName // ignore: cast_nullable_to_non_nullable
as String?,simHadithText: freezed == simHadithText ? _self.simHadithText : simHadithText // ignore: cast_nullable_to_non_nullable
as String?,simHadithNumber: freezed == simHadithNumber ? _self.simHadithNumber : simHadithNumber // ignore: cast_nullable_to_non_nullable
as int?,simBookName: freezed == simBookName ? _self.simBookName : simBookName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SimilarAhadith].
extension SimilarAhadithPatterns on SimilarAhadith {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SimilarAhadith value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SimilarAhadith() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SimilarAhadith value)  $default,){
final _that = this;
switch (_that) {
case _SimilarAhadith():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SimilarAhadith value)?  $default,){
final _that = this;
switch (_that) {
case _SimilarAhadith() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'main_hadith')  String? mainHadithId, @JsonKey(name: 'sim_hadith')  String? simHadithId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(includeToJson: false)  String? mainHadithText, @JsonKey(includeToJson: false)  int? mainHadithNumber, @JsonKey(includeToJson: false)  String? mainBookName, @JsonKey(includeToJson: false)  String? simHadithText, @JsonKey(includeToJson: false)  int? simHadithNumber, @JsonKey(includeToJson: false)  String? simBookName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SimilarAhadith() when $default != null:
return $default(_that.id,_that.mainHadithId,_that.simHadithId,_that.createdAt,_that.updatedAt,_that.mainHadithText,_that.mainHadithNumber,_that.mainBookName,_that.simHadithText,_that.simHadithNumber,_that.simBookName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'main_hadith')  String? mainHadithId, @JsonKey(name: 'sim_hadith')  String? simHadithId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(includeToJson: false)  String? mainHadithText, @JsonKey(includeToJson: false)  int? mainHadithNumber, @JsonKey(includeToJson: false)  String? mainBookName, @JsonKey(includeToJson: false)  String? simHadithText, @JsonKey(includeToJson: false)  int? simHadithNumber, @JsonKey(includeToJson: false)  String? simBookName)  $default,) {final _that = this;
switch (_that) {
case _SimilarAhadith():
return $default(_that.id,_that.mainHadithId,_that.simHadithId,_that.createdAt,_that.updatedAt,_that.mainHadithText,_that.mainHadithNumber,_that.mainBookName,_that.simHadithText,_that.simHadithNumber,_that.simBookName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'main_hadith')  String? mainHadithId, @JsonKey(name: 'sim_hadith')  String? simHadithId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(includeToJson: false)  String? mainHadithText, @JsonKey(includeToJson: false)  int? mainHadithNumber, @JsonKey(includeToJson: false)  String? mainBookName, @JsonKey(includeToJson: false)  String? simHadithText, @JsonKey(includeToJson: false)  int? simHadithNumber, @JsonKey(includeToJson: false)  String? simBookName)?  $default,) {final _that = this;
switch (_that) {
case _SimilarAhadith() when $default != null:
return $default(_that.id,_that.mainHadithId,_that.simHadithId,_that.createdAt,_that.updatedAt,_that.mainHadithText,_that.mainHadithNumber,_that.mainBookName,_that.simHadithText,_that.simHadithNumber,_that.simBookName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SimilarAhadith implements SimilarAhadith {
  const _SimilarAhadith({this.id, @JsonKey(name: 'main_hadith') this.mainHadithId, @JsonKey(name: 'sim_hadith') this.simHadithId, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(includeToJson: false) this.mainHadithText, @JsonKey(includeToJson: false) this.mainHadithNumber, @JsonKey(includeToJson: false) this.mainBookName, @JsonKey(includeToJson: false) this.simHadithText, @JsonKey(includeToJson: false) this.simHadithNumber, @JsonKey(includeToJson: false) this.simBookName});
  factory _SimilarAhadith.fromJson(Map<String, dynamic> json) => _$SimilarAhadithFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'main_hadith') final  String? mainHadithId;
@override@JsonKey(name: 'sim_hadith') final  String? simHadithId;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;
// حقول العلاقات (للقراءة فقط)
@override@JsonKey(includeToJson: false) final  String? mainHadithText;
@override@JsonKey(includeToJson: false) final  int? mainHadithNumber;
@override@JsonKey(includeToJson: false) final  String? mainBookName;
@override@JsonKey(includeToJson: false) final  String? simHadithText;
@override@JsonKey(includeToJson: false) final  int? simHadithNumber;
@override@JsonKey(includeToJson: false) final  String? simBookName;

/// Create a copy of SimilarAhadith
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SimilarAhadithCopyWith<_SimilarAhadith> get copyWith => __$SimilarAhadithCopyWithImpl<_SimilarAhadith>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SimilarAhadithToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SimilarAhadith&&(identical(other.id, id) || other.id == id)&&(identical(other.mainHadithId, mainHadithId) || other.mainHadithId == mainHadithId)&&(identical(other.simHadithId, simHadithId) || other.simHadithId == simHadithId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.mainHadithText, mainHadithText) || other.mainHadithText == mainHadithText)&&(identical(other.mainHadithNumber, mainHadithNumber) || other.mainHadithNumber == mainHadithNumber)&&(identical(other.mainBookName, mainBookName) || other.mainBookName == mainBookName)&&(identical(other.simHadithText, simHadithText) || other.simHadithText == simHadithText)&&(identical(other.simHadithNumber, simHadithNumber) || other.simHadithNumber == simHadithNumber)&&(identical(other.simBookName, simBookName) || other.simBookName == simBookName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mainHadithId,simHadithId,createdAt,updatedAt,mainHadithText,mainHadithNumber,mainBookName,simHadithText,simHadithNumber,simBookName);

@override
String toString() {
  return 'SimilarAhadith(id: $id, mainHadithId: $mainHadithId, simHadithId: $simHadithId, createdAt: $createdAt, updatedAt: $updatedAt, mainHadithText: $mainHadithText, mainHadithNumber: $mainHadithNumber, mainBookName: $mainBookName, simHadithText: $simHadithText, simHadithNumber: $simHadithNumber, simBookName: $simBookName)';
}


}

/// @nodoc
abstract mixin class _$SimilarAhadithCopyWith<$Res> implements $SimilarAhadithCopyWith<$Res> {
  factory _$SimilarAhadithCopyWith(_SimilarAhadith value, $Res Function(_SimilarAhadith) _then) = __$SimilarAhadithCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'main_hadith') String? mainHadithId,@JsonKey(name: 'sim_hadith') String? simHadithId,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(includeToJson: false) String? mainHadithText,@JsonKey(includeToJson: false) int? mainHadithNumber,@JsonKey(includeToJson: false) String? mainBookName,@JsonKey(includeToJson: false) String? simHadithText,@JsonKey(includeToJson: false) int? simHadithNumber,@JsonKey(includeToJson: false) String? simBookName
});




}
/// @nodoc
class __$SimilarAhadithCopyWithImpl<$Res>
    implements _$SimilarAhadithCopyWith<$Res> {
  __$SimilarAhadithCopyWithImpl(this._self, this._then);

  final _SimilarAhadith _self;
  final $Res Function(_SimilarAhadith) _then;

/// Create a copy of SimilarAhadith
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? mainHadithId = freezed,Object? simHadithId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? mainHadithText = freezed,Object? mainHadithNumber = freezed,Object? mainBookName = freezed,Object? simHadithText = freezed,Object? simHadithNumber = freezed,Object? simBookName = freezed,}) {
  return _then(_SimilarAhadith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,mainHadithId: freezed == mainHadithId ? _self.mainHadithId : mainHadithId // ignore: cast_nullable_to_non_nullable
as String?,simHadithId: freezed == simHadithId ? _self.simHadithId : simHadithId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,mainHadithText: freezed == mainHadithText ? _self.mainHadithText : mainHadithText // ignore: cast_nullable_to_non_nullable
as String?,mainHadithNumber: freezed == mainHadithNumber ? _self.mainHadithNumber : mainHadithNumber // ignore: cast_nullable_to_non_nullable
as int?,mainBookName: freezed == mainBookName ? _self.mainBookName : mainBookName // ignore: cast_nullable_to_non_nullable
as String?,simHadithText: freezed == simHadithText ? _self.simHadithText : simHadithText // ignore: cast_nullable_to_non_nullable
as String?,simHadithNumber: freezed == simHadithNumber ? _self.simHadithNumber : simHadithNumber // ignore: cast_nullable_to_non_nullable
as int?,simBookName: freezed == simBookName ? _self.simBookName : simBookName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on


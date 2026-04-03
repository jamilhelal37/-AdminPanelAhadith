// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchHistory {

 String? get id;@JsonKey(name: 'user') String? get userId;@JsonKey(name: 'search_text') String get searchText;@JsonKey(name: 'ishadith') bool get isHadith;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;
/// Create a copy of SearchHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchHistoryCopyWith<SearchHistory> get copyWith => _$SearchHistoryCopyWithImpl<SearchHistory>(this as SearchHistory, _$identity);

  /// Serializes this SearchHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.searchText, searchText) || other.searchText == searchText)&&(identical(other.isHadith, isHadith) || other.isHadith == isHadith)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,searchText,isHadith,createdAt,updatedAt);

@override
String toString() {
  return 'SearchHistory(id: $id, userId: $userId, searchText: $searchText, isHadith: $isHadith, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SearchHistoryCopyWith<$Res>  {
  factory $SearchHistoryCopyWith(SearchHistory value, $Res Function(SearchHistory) _then) = _$SearchHistoryCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'user') String? userId,@JsonKey(name: 'search_text') String searchText,@JsonKey(name: 'ishadith') bool isHadith,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class _$SearchHistoryCopyWithImpl<$Res>
    implements $SearchHistoryCopyWith<$Res> {
  _$SearchHistoryCopyWithImpl(this._self, this._then);

  final SearchHistory _self;
  final $Res Function(SearchHistory) _then;

/// Create a copy of SearchHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? searchText = null,Object? isHadith = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,searchText: null == searchText ? _self.searchText : searchText // ignore: cast_nullable_to_non_nullable
as String,isHadith: null == isHadith ? _self.isHadith : isHadith // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchHistory].
extension SearchHistoryPatterns on SearchHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchHistory value)  $default,){
final _that = this;
switch (_that) {
case _SearchHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchHistory value)?  $default,){
final _that = this;
switch (_that) {
case _SearchHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'user')  String? userId, @JsonKey(name: 'search_text')  String searchText, @JsonKey(name: 'ishadith')  bool isHadith, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchHistory() when $default != null:
return $default(_that.id,_that.userId,_that.searchText,_that.isHadith,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'user')  String? userId, @JsonKey(name: 'search_text')  String searchText, @JsonKey(name: 'ishadith')  bool isHadith, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SearchHistory():
return $default(_that.id,_that.userId,_that.searchText,_that.isHadith,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'user')  String? userId, @JsonKey(name: 'search_text')  String searchText, @JsonKey(name: 'ishadith')  bool isHadith, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SearchHistory() when $default != null:
return $default(_that.id,_that.userId,_that.searchText,_that.isHadith,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchHistory implements SearchHistory {
  const _SearchHistory({this.id, @JsonKey(name: 'user') this.userId, @JsonKey(name: 'search_text') required this.searchText, @JsonKey(name: 'ishadith') this.isHadith = true, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _SearchHistory.fromJson(Map<String, dynamic> json) => _$SearchHistoryFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'user') final  String? userId;
@override@JsonKey(name: 'search_text') final  String searchText;
@override@JsonKey(name: 'ishadith') final  bool isHadith;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;

/// Create a copy of SearchHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchHistoryCopyWith<_SearchHistory> get copyWith => __$SearchHistoryCopyWithImpl<_SearchHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.searchText, searchText) || other.searchText == searchText)&&(identical(other.isHadith, isHadith) || other.isHadith == isHadith)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,searchText,isHadith,createdAt,updatedAt);

@override
String toString() {
  return 'SearchHistory(id: $id, userId: $userId, searchText: $searchText, isHadith: $isHadith, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SearchHistoryCopyWith<$Res> implements $SearchHistoryCopyWith<$Res> {
  factory _$SearchHistoryCopyWith(_SearchHistory value, $Res Function(_SearchHistory) _then) = __$SearchHistoryCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'user') String? userId,@JsonKey(name: 'search_text') String searchText,@JsonKey(name: 'ishadith') bool isHadith,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class __$SearchHistoryCopyWithImpl<$Res>
    implements _$SearchHistoryCopyWith<$Res> {
  __$SearchHistoryCopyWithImpl(this._self, this._then);

  final _SearchHistory _self;
  final $Res Function(_SearchHistory) _then;

/// Create a copy of SearchHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? searchText = null,Object? isHadith = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_SearchHistory(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,searchText: null == searchText ? _self.searchText : searchText // ignore: cast_nullable_to_non_nullable
as String,isHadith: null == isHadith ? _self.isHadith : isHadith // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

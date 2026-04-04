// ignore_for_file: type=lint, type=warning






part of 'search_history.dart';






T _$identity<T>(T value) => value;


mixin _$SearchHistory {

 String? get id;@JsonKey(name: 'user') String? get userId;@JsonKey(name: 'search_text') String get searchText;@JsonKey(name: 'ishadith') bool get isHadith;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;


@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchHistoryCopyWith<SearchHistory> get copyWith => _$SearchHistoryCopyWithImpl<SearchHistory>(this as SearchHistory, _$identity);

  
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


abstract mixin class $SearchHistoryCopyWith<$Res>  {
  factory $SearchHistoryCopyWith(SearchHistory value, $Res Function(SearchHistory) _then) = _$SearchHistoryCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'user') String? userId,@JsonKey(name: 'search_text') String searchText,@JsonKey(name: 'ishadith') bool isHadith,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class _$SearchHistoryCopyWithImpl<$Res>
    implements $SearchHistoryCopyWith<$Res> {
  _$SearchHistoryCopyWithImpl(this._self, this._then);

  final SearchHistory _self;
  final $Res Function(SearchHistory) _then;



@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? searchText = null,Object? isHadith = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id 
as String?,userId: freezed == userId ? _self.userId : userId 
as String?,searchText: null == searchText ? _self.searchText : searchText 
as String,isHadith: null == isHadith ? _self.isHadith : isHadith 
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}

}



extension SearchHistoryPatterns on SearchHistory {












@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchHistory() when $default != null:
return $default(_that);case _:
  return orElse();

}
}













@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchHistory value)  $default,){
final _that = this;
switch (_that) {
case _SearchHistory():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchHistory value)?  $default,){
final _that = this;
switch (_that) {
case _SearchHistory() when $default != null:
return $default(_that);case _:
  return null;

}
}












@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'user')  String? userId, @JsonKey(name: 'search_text')  String searchText, @JsonKey(name: 'ishadith')  bool isHadith, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchHistory() when $default != null:
return $default(_that.id,_that.userId,_that.searchText,_that.isHadith,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}













@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'user')  String? userId, @JsonKey(name: 'search_text')  String searchText, @JsonKey(name: 'ishadith')  bool isHadith, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SearchHistory():
return $default(_that.id,_that.userId,_that.searchText,_that.isHadith,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'user')  String? userId, @JsonKey(name: 'search_text')  String searchText, @JsonKey(name: 'ishadith')  bool isHadith, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SearchHistory() when $default != null:
return $default(_that.id,_that.userId,_that.searchText,_that.isHadith,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}


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


abstract mixin class _$SearchHistoryCopyWith<$Res> implements $SearchHistoryCopyWith<$Res> {
  factory _$SearchHistoryCopyWith(_SearchHistory value, $Res Function(_SearchHistory) _then) = __$SearchHistoryCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'user') String? userId,@JsonKey(name: 'search_text') String searchText,@JsonKey(name: 'ishadith') bool isHadith,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}

class __$SearchHistoryCopyWithImpl<$Res>
    implements _$SearchHistoryCopyWith<$Res> {
  __$SearchHistoryCopyWithImpl(this._self, this._then);

  final _SearchHistory _self;
  final $Res Function(_SearchHistory) _then;



@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? searchText = null,Object? isHadith = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_SearchHistory(
id: freezed == id ? _self.id : id 
as String?,userId: freezed == userId ? _self.userId : userId 
as String?,searchText: null == searchText ? _self.searchText : searchText 
as String,isHadith: null == isHadith ? _self.isHadith : isHadith 
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,
  ));
}


}



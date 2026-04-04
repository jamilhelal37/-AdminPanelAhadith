// ignore_for_file: type=lint, type=warning






part of 'similar_ahadith.dart';






T _$identity<T>(T value) => value;


mixin _$SimilarAhadith {

 String? get id;@JsonKey(name: 'main_hadith') String? get mainHadithId;@JsonKey(name: 'sim_hadith') String? get simHadithId;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;
@JsonKey(includeToJson: false) String? get mainHadithText;@JsonKey(includeToJson: false) int? get mainHadithNumber;@JsonKey(includeToJson: false) String? get mainBookName;@JsonKey(includeToJson: false) String? get simHadithText;@JsonKey(includeToJson: false) int? get simHadithNumber;@JsonKey(includeToJson: false) String? get simBookName;


@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SimilarAhadithCopyWith<SimilarAhadith> get copyWith => _$SimilarAhadithCopyWithImpl<SimilarAhadith>(this as SimilarAhadith, _$identity);

  
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


abstract mixin class $SimilarAhadithCopyWith<$Res>  {
  factory $SimilarAhadithCopyWith(SimilarAhadith value, $Res Function(SimilarAhadith) _then) = _$SimilarAhadithCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'main_hadith') String? mainHadithId,@JsonKey(name: 'sim_hadith') String? simHadithId,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(includeToJson: false) String? mainHadithText,@JsonKey(includeToJson: false) int? mainHadithNumber,@JsonKey(includeToJson: false) String? mainBookName,@JsonKey(includeToJson: false) String? simHadithText,@JsonKey(includeToJson: false) int? simHadithNumber,@JsonKey(includeToJson: false) String? simBookName
});




}

class _$SimilarAhadithCopyWithImpl<$Res>
    implements $SimilarAhadithCopyWith<$Res> {
  _$SimilarAhadithCopyWithImpl(this._self, this._then);

  final SimilarAhadith _self;
  final $Res Function(SimilarAhadith) _then;



@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? mainHadithId = freezed,Object? simHadithId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? mainHadithText = freezed,Object? mainHadithNumber = freezed,Object? mainBookName = freezed,Object? simHadithText = freezed,Object? simHadithNumber = freezed,Object? simBookName = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id 
as String?,mainHadithId: freezed == mainHadithId ? _self.mainHadithId : mainHadithId 
as String?,simHadithId: freezed == simHadithId ? _self.simHadithId : simHadithId 
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,mainHadithText: freezed == mainHadithText ? _self.mainHadithText : mainHadithText 
as String?,mainHadithNumber: freezed == mainHadithNumber ? _self.mainHadithNumber : mainHadithNumber 
as int?,mainBookName: freezed == mainBookName ? _self.mainBookName : mainBookName 
as String?,simHadithText: freezed == simHadithText ? _self.simHadithText : simHadithText 
as String?,simHadithNumber: freezed == simHadithNumber ? _self.simHadithNumber : simHadithNumber 
as int?,simBookName: freezed == simBookName ? _self.simBookName : simBookName 
as String?,
  ));
}

}



extension SimilarAhadithPatterns on SimilarAhadith {












@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SimilarAhadith value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SimilarAhadith() when $default != null:
return $default(_that);case _:
  return orElse();

}
}













@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SimilarAhadith value)  $default,){
final _that = this;
switch (_that) {
case _SimilarAhadith():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SimilarAhadith value)?  $default,){
final _that = this;
switch (_that) {
case _SimilarAhadith() when $default != null:
return $default(_that);case _:
  return null;

}
}












@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'main_hadith')  String? mainHadithId, @JsonKey(name: 'sim_hadith')  String? simHadithId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(includeToJson: false)  String? mainHadithText, @JsonKey(includeToJson: false)  int? mainHadithNumber, @JsonKey(includeToJson: false)  String? mainBookName, @JsonKey(includeToJson: false)  String? simHadithText, @JsonKey(includeToJson: false)  int? simHadithNumber, @JsonKey(includeToJson: false)  String? simBookName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SimilarAhadith() when $default != null:
return $default(_that.id,_that.mainHadithId,_that.simHadithId,_that.createdAt,_that.updatedAt,_that.mainHadithText,_that.mainHadithNumber,_that.mainBookName,_that.simHadithText,_that.simHadithNumber,_that.simBookName);case _:
  return orElse();

}
}













@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'main_hadith')  String? mainHadithId, @JsonKey(name: 'sim_hadith')  String? simHadithId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(includeToJson: false)  String? mainHadithText, @JsonKey(includeToJson: false)  int? mainHadithNumber, @JsonKey(includeToJson: false)  String? mainBookName, @JsonKey(includeToJson: false)  String? simHadithText, @JsonKey(includeToJson: false)  int? simHadithNumber, @JsonKey(includeToJson: false)  String? simBookName)  $default,) {final _that = this;
switch (_that) {
case _SimilarAhadith():
return $default(_that.id,_that.mainHadithId,_that.simHadithId,_that.createdAt,_that.updatedAt,_that.mainHadithText,_that.mainHadithNumber,_that.mainBookName,_that.simHadithText,_that.simHadithNumber,_that.simBookName);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'main_hadith')  String? mainHadithId, @JsonKey(name: 'sim_hadith')  String? simHadithId, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(includeToJson: false)  String? mainHadithText, @JsonKey(includeToJson: false)  int? mainHadithNumber, @JsonKey(includeToJson: false)  String? mainBookName, @JsonKey(includeToJson: false)  String? simHadithText, @JsonKey(includeToJson: false)  int? simHadithNumber, @JsonKey(includeToJson: false)  String? simBookName)?  $default,) {final _that = this;
switch (_that) {
case _SimilarAhadith() when $default != null:
return $default(_that.id,_that.mainHadithId,_that.simHadithId,_that.createdAt,_that.updatedAt,_that.mainHadithText,_that.mainHadithNumber,_that.mainBookName,_that.simHadithText,_that.simHadithNumber,_that.simBookName);case _:
  return null;

}
}

}


@JsonSerializable()

class _SimilarAhadith implements SimilarAhadith {
  const _SimilarAhadith({this.id, @JsonKey(name: 'main_hadith') this.mainHadithId, @JsonKey(name: 'sim_hadith') this.simHadithId, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(includeToJson: false) this.mainHadithText, @JsonKey(includeToJson: false) this.mainHadithNumber, @JsonKey(includeToJson: false) this.mainBookName, @JsonKey(includeToJson: false) this.simHadithText, @JsonKey(includeToJson: false) this.simHadithNumber, @JsonKey(includeToJson: false) this.simBookName});
  factory _SimilarAhadith.fromJson(Map<String, dynamic> json) => _$SimilarAhadithFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'main_hadith') final  String? mainHadithId;
@override@JsonKey(name: 'sim_hadith') final  String? simHadithId;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;

@override@JsonKey(includeToJson: false) final  String? mainHadithText;
@override@JsonKey(includeToJson: false) final  int? mainHadithNumber;
@override@JsonKey(includeToJson: false) final  String? mainBookName;
@override@JsonKey(includeToJson: false) final  String? simHadithText;
@override@JsonKey(includeToJson: false) final  int? simHadithNumber;
@override@JsonKey(includeToJson: false) final  String? simBookName;



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


abstract mixin class _$SimilarAhadithCopyWith<$Res> implements $SimilarAhadithCopyWith<$Res> {
  factory _$SimilarAhadithCopyWith(_SimilarAhadith value, $Res Function(_SimilarAhadith) _then) = __$SimilarAhadithCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'main_hadith') String? mainHadithId,@JsonKey(name: 'sim_hadith') String? simHadithId,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(includeToJson: false) String? mainHadithText,@JsonKey(includeToJson: false) int? mainHadithNumber,@JsonKey(includeToJson: false) String? mainBookName,@JsonKey(includeToJson: false) String? simHadithText,@JsonKey(includeToJson: false) int? simHadithNumber,@JsonKey(includeToJson: false) String? simBookName
});




}

class __$SimilarAhadithCopyWithImpl<$Res>
    implements _$SimilarAhadithCopyWith<$Res> {
  __$SimilarAhadithCopyWithImpl(this._self, this._then);

  final _SimilarAhadith _self;
  final $Res Function(_SimilarAhadith) _then;



@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? mainHadithId = freezed,Object? simHadithId = freezed,Object? createdAt = null,Object? updatedAt = null,Object? mainHadithText = freezed,Object? mainHadithNumber = freezed,Object? mainBookName = freezed,Object? simHadithText = freezed,Object? simHadithNumber = freezed,Object? simBookName = freezed,}) {
  return _then(_SimilarAhadith(
id: freezed == id ? _self.id : id 
as String?,mainHadithId: freezed == mainHadithId ? _self.mainHadithId : mainHadithId 
as String?,simHadithId: freezed == simHadithId ? _self.simHadithId : simHadithId 
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,mainHadithText: freezed == mainHadithText ? _self.mainHadithText : mainHadithText 
as String?,mainHadithNumber: freezed == mainHadithNumber ? _self.mainHadithNumber : mainHadithNumber 
as int?,mainBookName: freezed == mainBookName ? _self.mainBookName : mainBookName 
as String?,simHadithText: freezed == simHadithText ? _self.simHadithText : simHadithText 
as String?,simHadithNumber: freezed == simHadithNumber ? _self.simHadithNumber : simHadithNumber 
as int?,simBookName: freezed == simBookName ? _self.simBookName : simBookName 
as String?,
  ));
}


}




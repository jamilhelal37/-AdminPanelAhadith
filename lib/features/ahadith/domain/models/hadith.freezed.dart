// ignore_for_file: type=lint, type=warning






part of 'hadith.dart';






T _$identity<T>(T value) => value;


mixin _$Hadith {

 String? get id;
@JsonKey(name: 'sub_valid') String? get subValid;
@JsonKey(includeToJson: false) String? get subValidText;
@JsonKey(name: 'explaining') String? get explainingId;
@JsonKey(name: 'explaining_rel', fromJson: _relText, includeToJson: false) String? get explainingText;
@JsonKey(fromJson: _hadithTypeFromJson, toJson: _hadithTypeToJson) HadithType get type; String get text;@JsonKey(name: 'normal_text') String? get normalText;@JsonKey(name: 'search_text') String? get searchText;@JsonKey(name: 'hadith_number') int get hadithNumber;
@JsonKey(name: 'muhaddith_ruling') String? get muhaddithRulingId;
@JsonKey(name: 'muhaddith_ruling_rel', fromJson: _relName, includeToJson: false) String? get muhaddithRulingName;
@JsonKey(name: 'final_ruling') String? get finalRulingId;
@JsonKey(name: 'final_ruling_rel', fromJson: _relName, includeToJson: false) String? get finalRulingName;
@JsonKey(name: 'rawi') String? get rawiId;
@JsonKey(name: 'rawi_rel', fromJson: _relName, includeToJson: false) String? get rawiName;
@JsonKey(name: 'source') String? get sourceId;
@JsonKey(name: 'source_rel', fromJson: _relName, includeToJson: false) String? get sourceName; String? get sanad;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;
@JsonKey(name: 'related_topics') List<String>? get relatedTopics;


@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HadithCopyWith<Hadith> get copyWith => _$HadithCopyWithImpl<Hadith>(this as Hadith, _$identity);

  
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hadith&&(identical(other.id, id) || other.id == id)&&(identical(other.subValid, subValid) || other.subValid == subValid)&&(identical(other.subValidText, subValidText) || other.subValidText == subValidText)&&(identical(other.explainingId, explainingId) || other.explainingId == explainingId)&&(identical(other.explainingText, explainingText) || other.explainingText == explainingText)&&(identical(other.type, type) || other.type == type)&&(identical(other.text, text) || other.text == text)&&(identical(other.normalText, normalText) || other.normalText == normalText)&&(identical(other.searchText, searchText) || other.searchText == searchText)&&(identical(other.hadithNumber, hadithNumber) || other.hadithNumber == hadithNumber)&&(identical(other.muhaddithRulingId, muhaddithRulingId) || other.muhaddithRulingId == muhaddithRulingId)&&(identical(other.muhaddithRulingName, muhaddithRulingName) || other.muhaddithRulingName == muhaddithRulingName)&&(identical(other.finalRulingId, finalRulingId) || other.finalRulingId == finalRulingId)&&(identical(other.finalRulingName, finalRulingName) || other.finalRulingName == finalRulingName)&&(identical(other.rawiId, rawiId) || other.rawiId == rawiId)&&(identical(other.rawiName, rawiName) || other.rawiName == rawiName)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName)&&(identical(other.sanad, sanad) || other.sanad == sanad)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.relatedTopics, relatedTopics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,subValid,subValidText,explainingId,explainingText,type,text,normalText,searchText,hadithNumber,muhaddithRulingId,muhaddithRulingName,finalRulingId,finalRulingName,rawiId,rawiName,sourceId,sourceName,sanad,createdAt,updatedAt,const DeepCollectionEquality().hash(relatedTopics)]);

@override
String toString() {
  return 'Hadith(id: $id, subValid: $subValid, subValidText: $subValidText, explainingId: $explainingId, explainingText: $explainingText, type: $type, text: $text, normalText: $normalText, searchText: $searchText, hadithNumber: $hadithNumber, muhaddithRulingId: $muhaddithRulingId, muhaddithRulingName: $muhaddithRulingName, finalRulingId: $finalRulingId, finalRulingName: $finalRulingName, rawiId: $rawiId, rawiName: $rawiName, sourceId: $sourceId, sourceName: $sourceName, sanad: $sanad, createdAt: $createdAt, updatedAt: $updatedAt, relatedTopics: $relatedTopics)';
}


}


abstract mixin class $HadithCopyWith<$Res>  {
  factory $HadithCopyWith(Hadith value, $Res Function(Hadith) _then) = _$HadithCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'sub_valid') String? subValid,@JsonKey(includeToJson: false) String? subValidText,@JsonKey(name: 'explaining') String? explainingId,@JsonKey(name: 'explaining_rel', fromJson: _relText, includeToJson: false) String? explainingText,@JsonKey(fromJson: _hadithTypeFromJson, toJson: _hadithTypeToJson) HadithType type, String text,@JsonKey(name: 'normal_text') String? normalText,@JsonKey(name: 'search_text') String? searchText,@JsonKey(name: 'hadith_number') int hadithNumber,@JsonKey(name: 'muhaddith_ruling') String? muhaddithRulingId,@JsonKey(name: 'muhaddith_ruling_rel', fromJson: _relName, includeToJson: false) String? muhaddithRulingName,@JsonKey(name: 'final_ruling') String? finalRulingId,@JsonKey(name: 'final_ruling_rel', fromJson: _relName, includeToJson: false) String? finalRulingName,@JsonKey(name: 'rawi') String? rawiId,@JsonKey(name: 'rawi_rel', fromJson: _relName, includeToJson: false) String? rawiName,@JsonKey(name: 'source') String? sourceId,@JsonKey(name: 'source_rel', fromJson: _relName, includeToJson: false) String? sourceName, String? sanad,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'related_topics') List<String>? relatedTopics
});




}

class _$HadithCopyWithImpl<$Res>
    implements $HadithCopyWith<$Res> {
  _$HadithCopyWithImpl(this._self, this._then);

  final Hadith _self;
  final $Res Function(Hadith) _then;



@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? subValid = freezed,Object? subValidText = freezed,Object? explainingId = freezed,Object? explainingText = freezed,Object? type = null,Object? text = null,Object? normalText = freezed,Object? searchText = freezed,Object? hadithNumber = null,Object? muhaddithRulingId = freezed,Object? muhaddithRulingName = freezed,Object? finalRulingId = freezed,Object? finalRulingName = freezed,Object? rawiId = freezed,Object? rawiName = freezed,Object? sourceId = freezed,Object? sourceName = freezed,Object? sanad = freezed,Object? createdAt = null,Object? updatedAt = null,Object? relatedTopics = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id 
as String?,subValid: freezed == subValid ? _self.subValid : subValid 
as String?,subValidText: freezed == subValidText ? _self.subValidText : subValidText 
as String?,explainingId: freezed == explainingId ? _self.explainingId : explainingId 
as String?,explainingText: freezed == explainingText ? _self.explainingText : explainingText 
as String?,type: null == type ? _self.type : type 
as HadithType,text: null == text ? _self.text : text 
as String,normalText: freezed == normalText ? _self.normalText : normalText 
as String?,searchText: freezed == searchText ? _self.searchText : searchText 
as String?,hadithNumber: null == hadithNumber ? _self.hadithNumber : hadithNumber 
as int,muhaddithRulingId: freezed == muhaddithRulingId ? _self.muhaddithRulingId : muhaddithRulingId 
as String?,muhaddithRulingName: freezed == muhaddithRulingName ? _self.muhaddithRulingName : muhaddithRulingName 
as String?,finalRulingId: freezed == finalRulingId ? _self.finalRulingId : finalRulingId 
as String?,finalRulingName: freezed == finalRulingName ? _self.finalRulingName : finalRulingName 
as String?,rawiId: freezed == rawiId ? _self.rawiId : rawiId 
as String?,rawiName: freezed == rawiName ? _self.rawiName : rawiName 
as String?,sourceId: freezed == sourceId ? _self.sourceId : sourceId 
as String?,sourceName: freezed == sourceName ? _self.sourceName : sourceName 
as String?,sanad: freezed == sanad ? _self.sanad : sanad 
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,relatedTopics: freezed == relatedTopics ? _self.relatedTopics : relatedTopics 
as List<String>?,
  ));
}

}



extension HadithPatterns on Hadith {












@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hadith value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hadith() when $default != null:
return $default(_that);case _:
  return orElse();

}
}













@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hadith value)  $default,){
final _that = this;
switch (_that) {
case _Hadith():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hadith value)?  $default,){
final _that = this;
switch (_that) {
case _Hadith() when $default != null:
return $default(_that);case _:
  return null;

}
}












@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'sub_valid')  String? subValid, @JsonKey(includeToJson: false)  String? subValidText, @JsonKey(name: 'explaining')  String? explainingId, @JsonKey(name: 'explaining_rel', fromJson: _relText, includeToJson: false)  String? explainingText, @JsonKey(fromJson: _hadithTypeFromJson, toJson: _hadithTypeToJson)  HadithType type,  String text, @JsonKey(name: 'normal_text')  String? normalText, @JsonKey(name: 'search_text')  String? searchText, @JsonKey(name: 'hadith_number')  int hadithNumber, @JsonKey(name: 'muhaddith_ruling')  String? muhaddithRulingId, @JsonKey(name: 'muhaddith_ruling_rel', fromJson: _relName, includeToJson: false)  String? muhaddithRulingName, @JsonKey(name: 'final_ruling')  String? finalRulingId, @JsonKey(name: 'final_ruling_rel', fromJson: _relName, includeToJson: false)  String? finalRulingName, @JsonKey(name: 'rawi')  String? rawiId, @JsonKey(name: 'rawi_rel', fromJson: _relName, includeToJson: false)  String? rawiName, @JsonKey(name: 'source')  String? sourceId, @JsonKey(name: 'source_rel', fromJson: _relName, includeToJson: false)  String? sourceName,  String? sanad, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'related_topics')  List<String>? relatedTopics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hadith() when $default != null:
return $default(_that.id,_that.subValid,_that.subValidText,_that.explainingId,_that.explainingText,_that.type,_that.text,_that.normalText,_that.searchText,_that.hadithNumber,_that.muhaddithRulingId,_that.muhaddithRulingName,_that.finalRulingId,_that.finalRulingName,_that.rawiId,_that.rawiName,_that.sourceId,_that.sourceName,_that.sanad,_that.createdAt,_that.updatedAt,_that.relatedTopics);case _:
  return orElse();

}
}













@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'sub_valid')  String? subValid, @JsonKey(includeToJson: false)  String? subValidText, @JsonKey(name: 'explaining')  String? explainingId, @JsonKey(name: 'explaining_rel', fromJson: _relText, includeToJson: false)  String? explainingText, @JsonKey(fromJson: _hadithTypeFromJson, toJson: _hadithTypeToJson)  HadithType type,  String text, @JsonKey(name: 'normal_text')  String? normalText, @JsonKey(name: 'search_text')  String? searchText, @JsonKey(name: 'hadith_number')  int hadithNumber, @JsonKey(name: 'muhaddith_ruling')  String? muhaddithRulingId, @JsonKey(name: 'muhaddith_ruling_rel', fromJson: _relName, includeToJson: false)  String? muhaddithRulingName, @JsonKey(name: 'final_ruling')  String? finalRulingId, @JsonKey(name: 'final_ruling_rel', fromJson: _relName, includeToJson: false)  String? finalRulingName, @JsonKey(name: 'rawi')  String? rawiId, @JsonKey(name: 'rawi_rel', fromJson: _relName, includeToJson: false)  String? rawiName, @JsonKey(name: 'source')  String? sourceId, @JsonKey(name: 'source_rel', fromJson: _relName, includeToJson: false)  String? sourceName,  String? sanad, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'related_topics')  List<String>? relatedTopics)  $default,) {final _that = this;
switch (_that) {
case _Hadith():
return $default(_that.id,_that.subValid,_that.subValidText,_that.explainingId,_that.explainingText,_that.type,_that.text,_that.normalText,_that.searchText,_that.hadithNumber,_that.muhaddithRulingId,_that.muhaddithRulingName,_that.finalRulingId,_that.finalRulingName,_that.rawiId,_that.rawiName,_that.sourceId,_that.sourceName,_that.sanad,_that.createdAt,_that.updatedAt,_that.relatedTopics);case _:
  throw StateError('Unexpected subclass');

}
}












@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'sub_valid')  String? subValid, @JsonKey(includeToJson: false)  String? subValidText, @JsonKey(name: 'explaining')  String? explainingId, @JsonKey(name: 'explaining_rel', fromJson: _relText, includeToJson: false)  String? explainingText, @JsonKey(fromJson: _hadithTypeFromJson, toJson: _hadithTypeToJson)  HadithType type,  String text, @JsonKey(name: 'normal_text')  String? normalText, @JsonKey(name: 'search_text')  String? searchText, @JsonKey(name: 'hadith_number')  int hadithNumber, @JsonKey(name: 'muhaddith_ruling')  String? muhaddithRulingId, @JsonKey(name: 'muhaddith_ruling_rel', fromJson: _relName, includeToJson: false)  String? muhaddithRulingName, @JsonKey(name: 'final_ruling')  String? finalRulingId, @JsonKey(name: 'final_ruling_rel', fromJson: _relName, includeToJson: false)  String? finalRulingName, @JsonKey(name: 'rawi')  String? rawiId, @JsonKey(name: 'rawi_rel', fromJson: _relName, includeToJson: false)  String? rawiName, @JsonKey(name: 'source')  String? sourceId, @JsonKey(name: 'source_rel', fromJson: _relName, includeToJson: false)  String? sourceName,  String? sanad, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'related_topics')  List<String>? relatedTopics)?  $default,) {final _that = this;
switch (_that) {
case _Hadith() when $default != null:
return $default(_that.id,_that.subValid,_that.subValidText,_that.explainingId,_that.explainingText,_that.type,_that.text,_that.normalText,_that.searchText,_that.hadithNumber,_that.muhaddithRulingId,_that.muhaddithRulingName,_that.finalRulingId,_that.finalRulingName,_that.rawiId,_that.rawiName,_that.sourceId,_that.sourceName,_that.sanad,_that.createdAt,_that.updatedAt,_that.relatedTopics);case _:
  return null;

}
}

}


@JsonSerializable()

class _Hadith implements Hadith {
  const _Hadith({this.id, @JsonKey(name: 'sub_valid') this.subValid, @JsonKey(includeToJson: false) this.subValidText, @JsonKey(name: 'explaining') this.explainingId, @JsonKey(name: 'explaining_rel', fromJson: _relText, includeToJson: false) this.explainingText, @JsonKey(fromJson: _hadithTypeFromJson, toJson: _hadithTypeToJson) required this.type, required this.text, @JsonKey(name: 'normal_text') this.normalText, @JsonKey(name: 'search_text') this.searchText, @JsonKey(name: 'hadith_number') required this.hadithNumber, @JsonKey(name: 'muhaddith_ruling') this.muhaddithRulingId, @JsonKey(name: 'muhaddith_ruling_rel', fromJson: _relName, includeToJson: false) this.muhaddithRulingName, @JsonKey(name: 'final_ruling') this.finalRulingId, @JsonKey(name: 'final_ruling_rel', fromJson: _relName, includeToJson: false) this.finalRulingName, @JsonKey(name: 'rawi') this.rawiId, @JsonKey(name: 'rawi_rel', fromJson: _relName, includeToJson: false) this.rawiName, @JsonKey(name: 'source') this.sourceId, @JsonKey(name: 'source_rel', fromJson: _relName, includeToJson: false) this.sourceName, this.sanad, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'related_topics') final  List<String>? relatedTopics}): _relatedTopics = relatedTopics;
  factory _Hadith.fromJson(Map<String, dynamic> json) => _$HadithFromJson(json);

@override final  String? id;

@override@JsonKey(name: 'sub_valid') final  String? subValid;

@override@JsonKey(includeToJson: false) final  String? subValidText;

@override@JsonKey(name: 'explaining') final  String? explainingId;

@override@JsonKey(name: 'explaining_rel', fromJson: _relText, includeToJson: false) final  String? explainingText;

@override@JsonKey(fromJson: _hadithTypeFromJson, toJson: _hadithTypeToJson) final  HadithType type;
@override final  String text;
@override@JsonKey(name: 'normal_text') final  String? normalText;
@override@JsonKey(name: 'search_text') final  String? searchText;
@override@JsonKey(name: 'hadith_number') final  int hadithNumber;

@override@JsonKey(name: 'muhaddith_ruling') final  String? muhaddithRulingId;

@override@JsonKey(name: 'muhaddith_ruling_rel', fromJson: _relName, includeToJson: false) final  String? muhaddithRulingName;

@override@JsonKey(name: 'final_ruling') final  String? finalRulingId;

@override@JsonKey(name: 'final_ruling_rel', fromJson: _relName, includeToJson: false) final  String? finalRulingName;

@override@JsonKey(name: 'rawi') final  String? rawiId;

@override@JsonKey(name: 'rawi_rel', fromJson: _relName, includeToJson: false) final  String? rawiName;

@override@JsonKey(name: 'source') final  String? sourceId;

@override@JsonKey(name: 'source_rel', fromJson: _relName, includeToJson: false) final  String? sourceName;
@override final  String? sanad;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;

 final  List<String>? _relatedTopics;

@override@JsonKey(name: 'related_topics') List<String>? get relatedTopics {
  final value = _relatedTopics;
  if (value == null) return null;
  if (_relatedTopics is EqualUnmodifiableListView) return _relatedTopics;
  
  return EqualUnmodifiableListView(value);
}




@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HadithCopyWith<_Hadith> get copyWith => __$HadithCopyWithImpl<_Hadith>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HadithToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hadith&&(identical(other.id, id) || other.id == id)&&(identical(other.subValid, subValid) || other.subValid == subValid)&&(identical(other.subValidText, subValidText) || other.subValidText == subValidText)&&(identical(other.explainingId, explainingId) || other.explainingId == explainingId)&&(identical(other.explainingText, explainingText) || other.explainingText == explainingText)&&(identical(other.type, type) || other.type == type)&&(identical(other.text, text) || other.text == text)&&(identical(other.normalText, normalText) || other.normalText == normalText)&&(identical(other.searchText, searchText) || other.searchText == searchText)&&(identical(other.hadithNumber, hadithNumber) || other.hadithNumber == hadithNumber)&&(identical(other.muhaddithRulingId, muhaddithRulingId) || other.muhaddithRulingId == muhaddithRulingId)&&(identical(other.muhaddithRulingName, muhaddithRulingName) || other.muhaddithRulingName == muhaddithRulingName)&&(identical(other.finalRulingId, finalRulingId) || other.finalRulingId == finalRulingId)&&(identical(other.finalRulingName, finalRulingName) || other.finalRulingName == finalRulingName)&&(identical(other.rawiId, rawiId) || other.rawiId == rawiId)&&(identical(other.rawiName, rawiName) || other.rawiName == rawiName)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName)&&(identical(other.sanad, sanad) || other.sanad == sanad)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._relatedTopics, _relatedTopics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,subValid,subValidText,explainingId,explainingText,type,text,normalText,searchText,hadithNumber,muhaddithRulingId,muhaddithRulingName,finalRulingId,finalRulingName,rawiId,rawiName,sourceId,sourceName,sanad,createdAt,updatedAt,const DeepCollectionEquality().hash(_relatedTopics)]);

@override
String toString() {
  return 'Hadith(id: $id, subValid: $subValid, subValidText: $subValidText, explainingId: $explainingId, explainingText: $explainingText, type: $type, text: $text, normalText: $normalText, searchText: $searchText, hadithNumber: $hadithNumber, muhaddithRulingId: $muhaddithRulingId, muhaddithRulingName: $muhaddithRulingName, finalRulingId: $finalRulingId, finalRulingName: $finalRulingName, rawiId: $rawiId, rawiName: $rawiName, sourceId: $sourceId, sourceName: $sourceName, sanad: $sanad, createdAt: $createdAt, updatedAt: $updatedAt, relatedTopics: $relatedTopics)';
}


}


abstract mixin class _$HadithCopyWith<$Res> implements $HadithCopyWith<$Res> {
  factory _$HadithCopyWith(_Hadith value, $Res Function(_Hadith) _then) = __$HadithCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'sub_valid') String? subValid,@JsonKey(includeToJson: false) String? subValidText,@JsonKey(name: 'explaining') String? explainingId,@JsonKey(name: 'explaining_rel', fromJson: _relText, includeToJson: false) String? explainingText,@JsonKey(fromJson: _hadithTypeFromJson, toJson: _hadithTypeToJson) HadithType type, String text,@JsonKey(name: 'normal_text') String? normalText,@JsonKey(name: 'search_text') String? searchText,@JsonKey(name: 'hadith_number') int hadithNumber,@JsonKey(name: 'muhaddith_ruling') String? muhaddithRulingId,@JsonKey(name: 'muhaddith_ruling_rel', fromJson: _relName, includeToJson: false) String? muhaddithRulingName,@JsonKey(name: 'final_ruling') String? finalRulingId,@JsonKey(name: 'final_ruling_rel', fromJson: _relName, includeToJson: false) String? finalRulingName,@JsonKey(name: 'rawi') String? rawiId,@JsonKey(name: 'rawi_rel', fromJson: _relName, includeToJson: false) String? rawiName,@JsonKey(name: 'source') String? sourceId,@JsonKey(name: 'source_rel', fromJson: _relName, includeToJson: false) String? sourceName, String? sanad,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'related_topics') List<String>? relatedTopics
});




}

class __$HadithCopyWithImpl<$Res>
    implements _$HadithCopyWith<$Res> {
  __$HadithCopyWithImpl(this._self, this._then);

  final _Hadith _self;
  final $Res Function(_Hadith) _then;



@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? subValid = freezed,Object? subValidText = freezed,Object? explainingId = freezed,Object? explainingText = freezed,Object? type = null,Object? text = null,Object? normalText = freezed,Object? searchText = freezed,Object? hadithNumber = null,Object? muhaddithRulingId = freezed,Object? muhaddithRulingName = freezed,Object? finalRulingId = freezed,Object? finalRulingName = freezed,Object? rawiId = freezed,Object? rawiName = freezed,Object? sourceId = freezed,Object? sourceName = freezed,Object? sanad = freezed,Object? createdAt = null,Object? updatedAt = null,Object? relatedTopics = freezed,}) {
  return _then(_Hadith(
id: freezed == id ? _self.id : id 
as String?,subValid: freezed == subValid ? _self.subValid : subValid 
as String?,subValidText: freezed == subValidText ? _self.subValidText : subValidText 
as String?,explainingId: freezed == explainingId ? _self.explainingId : explainingId 
as String?,explainingText: freezed == explainingText ? _self.explainingText : explainingText 
as String?,type: null == type ? _self.type : type 
as HadithType,text: null == text ? _self.text : text 
as String,normalText: freezed == normalText ? _self.normalText : normalText 
as String?,searchText: freezed == searchText ? _self.searchText : searchText 
as String?,hadithNumber: null == hadithNumber ? _self.hadithNumber : hadithNumber 
as int,muhaddithRulingId: freezed == muhaddithRulingId ? _self.muhaddithRulingId : muhaddithRulingId 
as String?,muhaddithRulingName: freezed == muhaddithRulingName ? _self.muhaddithRulingName : muhaddithRulingName 
as String?,finalRulingId: freezed == finalRulingId ? _self.finalRulingId : finalRulingId 
as String?,finalRulingName: freezed == finalRulingName ? _self.finalRulingName : finalRulingName 
as String?,rawiId: freezed == rawiId ? _self.rawiId : rawiId 
as String?,rawiName: freezed == rawiName ? _self.rawiName : rawiName 
as String?,sourceId: freezed == sourceId ? _self.sourceId : sourceId 
as String?,sourceName: freezed == sourceName ? _self.sourceName : sourceName 
as String?,sanad: freezed == sanad ? _self.sanad : sanad 
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt 
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt 
as String,relatedTopics: freezed == relatedTopics ? _self._relatedTopics : relatedTopics 
as List<String>?,
  ));
}


}



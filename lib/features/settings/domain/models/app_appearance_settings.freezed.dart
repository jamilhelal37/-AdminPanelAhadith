// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_appearance_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppAppearanceSettings {

 ThemeMode get themeMode; double get fontScale; bool get showTashkeel; String get fontFamily;
/// Create a copy of AppAppearanceSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppAppearanceSettingsCopyWith<AppAppearanceSettings> get copyWith => _$AppAppearanceSettingsCopyWithImpl<AppAppearanceSettings>(this as AppAppearanceSettings, _$identity);

  /// Serializes this AppAppearanceSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppAppearanceSettings&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.fontScale, fontScale) || other.fontScale == fontScale)&&(identical(other.showTashkeel, showTashkeel) || other.showTashkeel == showTashkeel)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,fontScale,showTashkeel,fontFamily);

@override
String toString() {
  return 'AppAppearanceSettings(themeMode: $themeMode, fontScale: $fontScale, showTashkeel: $showTashkeel, fontFamily: $fontFamily)';
}


}

/// @nodoc
abstract mixin class $AppAppearanceSettingsCopyWith<$Res>  {
  factory $AppAppearanceSettingsCopyWith(AppAppearanceSettings value, $Res Function(AppAppearanceSettings) _then) = _$AppAppearanceSettingsCopyWithImpl;
@useResult
$Res call({
 ThemeMode themeMode, double fontScale, bool showTashkeel, String fontFamily
});




}
/// @nodoc
class _$AppAppearanceSettingsCopyWithImpl<$Res>
    implements $AppAppearanceSettingsCopyWith<$Res> {
  _$AppAppearanceSettingsCopyWithImpl(this._self, this._then);

  final AppAppearanceSettings _self;
  final $Res Function(AppAppearanceSettings) _then;

/// Create a copy of AppAppearanceSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? fontScale = null,Object? showTashkeel = null,Object? fontFamily = null,}) {
  return _then(_self.copyWith(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,fontScale: null == fontScale ? _self.fontScale : fontScale // ignore: cast_nullable_to_non_nullable
as double,showTashkeel: null == showTashkeel ? _self.showTashkeel : showTashkeel // ignore: cast_nullable_to_non_nullable
as bool,fontFamily: null == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppAppearanceSettings].
extension AppAppearanceSettingsPatterns on AppAppearanceSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppAppearanceSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppAppearanceSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppAppearanceSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppAppearanceSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppAppearanceSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppAppearanceSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ThemeMode themeMode,  double fontScale,  bool showTashkeel,  String fontFamily)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppAppearanceSettings() when $default != null:
return $default(_that.themeMode,_that.fontScale,_that.showTashkeel,_that.fontFamily);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ThemeMode themeMode,  double fontScale,  bool showTashkeel,  String fontFamily)  $default,) {final _that = this;
switch (_that) {
case _AppAppearanceSettings():
return $default(_that.themeMode,_that.fontScale,_that.showTashkeel,_that.fontFamily);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ThemeMode themeMode,  double fontScale,  bool showTashkeel,  String fontFamily)?  $default,) {final _that = this;
switch (_that) {
case _AppAppearanceSettings() when $default != null:
return $default(_that.themeMode,_that.fontScale,_that.showTashkeel,_that.fontFamily);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppAppearanceSettings extends AppAppearanceSettings {
  const _AppAppearanceSettings({this.themeMode = ThemeMode.system, this.fontScale = 0.8571428571428571, this.showTashkeel = true, this.fontFamily = 'NotoSans'}): super._();
  factory _AppAppearanceSettings.fromJson(Map<String, dynamic> json) => _$AppAppearanceSettingsFromJson(json);

@override@JsonKey() final  ThemeMode themeMode;
@override@JsonKey() final  double fontScale;
@override@JsonKey() final  bool showTashkeel;
@override@JsonKey() final  String fontFamily;

/// Create a copy of AppAppearanceSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppAppearanceSettingsCopyWith<_AppAppearanceSettings> get copyWith => __$AppAppearanceSettingsCopyWithImpl<_AppAppearanceSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppAppearanceSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppAppearanceSettings&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.fontScale, fontScale) || other.fontScale == fontScale)&&(identical(other.showTashkeel, showTashkeel) || other.showTashkeel == showTashkeel)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,fontScale,showTashkeel,fontFamily);

@override
String toString() {
  return 'AppAppearanceSettings(themeMode: $themeMode, fontScale: $fontScale, showTashkeel: $showTashkeel, fontFamily: $fontFamily)';
}


}

/// @nodoc
abstract mixin class _$AppAppearanceSettingsCopyWith<$Res> implements $AppAppearanceSettingsCopyWith<$Res> {
  factory _$AppAppearanceSettingsCopyWith(_AppAppearanceSettings value, $Res Function(_AppAppearanceSettings) _then) = __$AppAppearanceSettingsCopyWithImpl;
@override @useResult
$Res call({
 ThemeMode themeMode, double fontScale, bool showTashkeel, String fontFamily
});




}
/// @nodoc
class __$AppAppearanceSettingsCopyWithImpl<$Res>
    implements _$AppAppearanceSettingsCopyWith<$Res> {
  __$AppAppearanceSettingsCopyWithImpl(this._self, this._then);

  final _AppAppearanceSettings _self;
  final $Res Function(_AppAppearanceSettings) _then;

/// Create a copy of AppAppearanceSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? fontScale = null,Object? showTashkeel = null,Object? fontFamily = null,}) {
  return _then(_AppAppearanceSettings(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,fontScale: null == fontScale ? _self.fontScale : fontScale // ignore: cast_nullable_to_non_nullable
as double,showTashkeel: null == showTashkeel ? _self.showTashkeel : showTashkeel // ignore: cast_nullable_to_non_nullable
as bool,fontFamily: null == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

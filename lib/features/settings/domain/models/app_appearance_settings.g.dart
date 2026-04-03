// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_appearance_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppAppearanceSettings _$AppAppearanceSettingsFromJson(
  Map<String, dynamic> json,
) => _AppAppearanceSettings(
  themeMode:
      $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
      ThemeMode.system,
  fontScale: (json['fontScale'] as num?)?.toDouble() ?? 0.8571428571428571,
  showTashkeel: json['showTashkeel'] as bool? ?? true,
  fontFamily: json['fontFamily'] as String? ?? 'NotoSans',
);

Map<String, dynamic> _$AppAppearanceSettingsToJson(
  _AppAppearanceSettings instance,
) => <String, dynamic>{
  'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
  'fontScale': instance.fontScale,
  'showTashkeel': instance.showTashkeel,
  'fontFamily': instance.fontFamily,
};

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

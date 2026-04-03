import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_appearance_settings.freezed.dart';
part 'app_appearance_settings.g.dart';

@freezed
abstract class AppAppearanceSettings with _$AppAppearanceSettings {
  const AppAppearanceSettings._();

  const factory AppAppearanceSettings({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(0.8571428571428571) double fontScale,
    @Default(true) bool showTashkeel,
    @Default('NotoSans') String fontFamily,
  }) = _AppAppearanceSettings;

  static const AppAppearanceSettings defaults = AppAppearanceSettings();

  factory AppAppearanceSettings.fromJson(Map<String, dynamic> json) =>
      _$AppAppearanceSettingsFromJson(json);
}

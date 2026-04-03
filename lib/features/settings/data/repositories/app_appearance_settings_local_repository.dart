import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/app_appearance_settings.dart';
import 'app_appearance_settings_repository.dart';

class AppAppearanceSettingsLocalRepository
    implements AppAppearanceSettingsRepository {
  AppAppearanceSettingsLocalRepository({SharedPreferencesAsync? prefs})
    : _prefs = prefs ?? SharedPreferencesAsync();

  static const String _themeModeKey = 'theme_mode';
  static const String _fontScaleKey = 'font_scale';
  static const String _showTashkeelKey = 'show_tashkeel';
  static const String _fontFamilyKey = 'font_family';

  final SharedPreferencesAsync _prefs;

  @override
  Future<AppAppearanceSettings> load() async {
    final themeMode = _themeModeFromString(
      await _prefs.getString(_themeModeKey),
    );
    final fontScale =
        await _prefs.getDouble(_fontScaleKey) ??
        AppAppearanceSettings.defaults.fontScale;
    final showTashkeel =
        await _prefs.getBool(_showTashkeelKey) ??
        AppAppearanceSettings.defaults.showTashkeel;
    final fontFamily =
        await _prefs.getString(_fontFamilyKey) ??
        AppAppearanceSettings.defaults.fontFamily;

    return AppAppearanceSettings(
      themeMode: themeMode,
      fontScale: (fontScale.clamp(12 / 14, 15 / 14) as num).toDouble(),
      showTashkeel: showTashkeel,
      fontFamily: fontFamily,
    );
  }

  @override
  Future<void> save(AppAppearanceSettings settings) async {
    await _prefs.setString(
      _themeModeKey,
      _themeModeToString(settings.themeMode),
    );
    await _prefs.setDouble(_fontScaleKey, settings.fontScale);
    await _prefs.setBool(_showTashkeelKey, settings.showTashkeel);
    await _prefs.setString(_fontFamilyKey, settings.fontFamily);
  }

  ThemeMode _themeModeFromString(String? raw) => switch (raw) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  String _themeModeToString(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
    ThemeMode.system => 'system',
  };
}

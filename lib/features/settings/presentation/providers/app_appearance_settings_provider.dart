import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/app_appearance_settings_repository_provider.dart';
import '../../domain/models/app_appearance_settings.dart';

class AppAppearanceSettingsNotifier
    extends AsyncNotifier<AppAppearanceSettings> {
  @override
  Future<AppAppearanceSettings> build() async {
    return ref.read(appAppearanceSettingsRepositoryProvider).load();
  }

  AppAppearanceSettings get _currentSettings =>
      state.valueOrNull ?? AppAppearanceSettings.defaults;

  Future<void> setThemeMode(ThemeMode mode) async {
    await _persist(_currentSettings.copyWith(themeMode: mode));
  }

  Future<void> setFontScale(double value) async {
    await _persist(
      _currentSettings.copyWith(
        fontScale: (value.clamp(12 / 14, 15 / 14) as num).toDouble(),
      ),
    );
  }

  Future<void> setShowTashkeel(bool value) async {
    await _persist(_currentSettings.copyWith(showTashkeel: value));
  }

  Future<void> setFontFamily(String family) async {
    await _persist(_currentSettings.copyWith(fontFamily: family));
  }

  Future<void> _persist(AppAppearanceSettings next) async {
    state = AsyncValue.data(next);
    try {
      await ref.read(appAppearanceSettingsRepositoryProvider).save(next);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      state = AsyncValue.data(next);
    }
  }
}

final appAppearanceSettingsProvider =
    AsyncNotifierProvider<AppAppearanceSettingsNotifier, AppAppearanceSettings>(
      AppAppearanceSettingsNotifier.new,
    );

final appAppearanceSettingsValueProvider = Provider<AppAppearanceSettings>((
  ref,
) {
  return ref
      .watch(appAppearanceSettingsProvider)
      .maybeWhen(
        data: (settings) => settings,
        orElse: () => AppAppearanceSettings.defaults,
      );
});

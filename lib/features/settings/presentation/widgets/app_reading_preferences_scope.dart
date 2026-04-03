import 'package:flutter/widgets.dart';

import '../../domain/models/app_appearance_settings.dart';

class AppReadingPreferencesScope extends InheritedWidget {
  const AppReadingPreferencesScope({
    super.key,
    required this.settings,
    required super.child,
  });

  final AppAppearanceSettings settings;

  static AppAppearanceSettings of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppReadingPreferencesScope>();
    return scope?.settings ?? AppAppearanceSettings.defaults;
  }

  static String resolveDisplayText(
    BuildContext context, {
    required String text,
    String? normalText,
  }) {
    final settings = of(context);
    if (settings.showTashkeel) {
      return text;
    }

    final fallback = normalText?.trim();
    if (fallback == null || fallback.isEmpty) {
      return text;
    }
    return fallback;
  }

  @override
  bool updateShouldNotify(AppReadingPreferencesScope oldWidget) {
    return settings != oldWidget.settings;
  }
}

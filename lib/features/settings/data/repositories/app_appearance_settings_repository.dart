import '../../domain/models/app_appearance_settings.dart';

abstract class AppAppearanceSettingsRepository {
  Future<AppAppearanceSettings> load();

  Future<void> save(AppAppearanceSettings settings);
}

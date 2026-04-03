import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_appearance_settings_local_repository.dart';
import 'app_appearance_settings_repository.dart';

final appAppearanceSettingsRepositoryProvider =
    Provider<AppAppearanceSettingsRepository>((ref) {
      return AppAppearanceSettingsLocalRepository();
    });

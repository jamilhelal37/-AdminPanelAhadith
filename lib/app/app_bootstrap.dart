import 'package:ahadith/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/ahadith/application/hadith_of_day_notification_service.dart';
import '../features/notifications/application/notification_service.dart';

class AppBootstrapResult {
  const AppBootstrapResult({required this.overrides});

  final List<Override> overrides;
}

Future<AppBootstrapResult> bootstrapApp() async {
  await _configureSystemUi();
  await dotenv.load(fileName: '.env');

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseUrl.trim().isEmpty) {
    throw Exception('SUPABASE_URL is missing from .env');
  }
  if (supabaseAnonKey == null || supabaseAnonKey.trim().isEmpty) {
    throw Exception('SUPABASE_ANON_KEY is missing from .env');
  }

  await Supabase.initialize(
    url: supabaseUrl.trim(),
    anonKey: supabaseAnonKey.trim(),
  );

  final hadithOfDayNotificationService = HadithOfDayNotificationService();
  final pushNotificationService = PushNotificationService(
    localNotifications: hadithOfDayNotificationService,
  );

  if (!kIsWeb) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (error, stackTrace) {
      debugPrint('Firebase init failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  try {
    await hadithOfDayNotificationService.initialize();
  } catch (error, stackTrace) {
    debugPrint('Local notifications init failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  try {
    await pushNotificationService.initialize();
  } catch (error, stackTrace) {
    debugPrint('Push notifications init failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  return AppBootstrapResult(
    overrides: [
      hadithOfDayNotificationServiceProvider.overrideWithValue(
        hadithOfDayNotificationService,
      ),
      pushNotificationServiceProvider.overrideWithValue(
        pushNotificationService,
      ),
    ],
  );
}

Future<void> _configureSystemUi() async {
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  final isDark =
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: isDark
          ? const Color(0xFF15110D)
          : const Color(0xFFF8F1E6),
      systemNavigationBarDividerColor: isDark
          ? const Color(0xFF15110D)
          : const Color(0xFFF8F1E6),
      systemNavigationBarContrastEnforced: false,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarIconBrightness: isDark
          ? Brightness.light
          : Brightness.dark,
    ),
  );
}

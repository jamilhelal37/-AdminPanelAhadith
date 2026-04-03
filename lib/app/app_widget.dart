import 'package:ahadith/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/ahadith/application/hadith_of_day_notification_service.dart';
import '../features/ahadith/presentation/providers/hadith_of_day_notification_provider.dart';
import '../features/favorites/presentation/providers/favorites_provider.dart';
import '../features/notifications/application/notification_route_handler.dart';
import '../features/notifications/application/notification_service.dart';
import '../features/questions/presentation/providers/my_questions_provider.dart';
import '../features/settings/presentation/providers/app_appearance_settings_provider.dart';
import '../features/settings/presentation/widgets/app_reading_preferences_scope.dart';
import '../theme.dart';

class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'فشل تشغيل التطبيق',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AhadithApp extends ConsumerStatefulWidget {
  const AhadithApp({super.key});

  @override
  ConsumerState<AhadithApp> createState() => _AhadithAppState();
}

class _AhadithAppState extends ConsumerState<AhadithApp> {
  NotificationRouteHandler? _notificationRouteHandler;
  bool _didPrepareHadithOfDay = false;
  bool? _lastAppliedDarkSystemUi;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prepareHadithOfDayIfNeeded();
    });
  }

  @override
  void dispose() {
    _notificationRouteHandler?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appAppearanceSettingsValueProvider);
    final router = ref.watch(routerProvider);
    final pushNotificationService = ref.watch(pushNotificationServiceProvider);
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final useDarkSystemUi =
        settings.themeMode == ThemeMode.dark ||
        (settings.themeMode == ThemeMode.system &&
            platformBrightness == Brightness.dark);

    _bindNotificationRouting(router, pushNotificationService);
    ref.listen(userFavoritesStreamProvider, (_, _) {});
    ref.listen(questionsStreamProvider, (_, _) {});
    _applySystemUiForTheme(useDarkSystemUi);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'الموسوعة الحديثية',
      theme: AppTheme.lightWithFont(settings.fontFamily),
      darkTheme: AppTheme.darkWithFont(settings.fontFamily),
      themeMode: settings.themeMode,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return AppReadingPreferencesScope(
          settings: settings,
          child: MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: TextScaler.linear(settings.fontScale),
            ),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar', 'SA')],
      locale: const Locale('ar', 'SA'),
    );
  }

  void _applySystemUiForTheme(bool isDark) {
    if (_lastAppliedDarkSystemUi == isDark) {
      return;
    }
    _lastAppliedDarkSystemUi = isDark;

    if (isDark) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: AppTheme.darkSystemUiBackground,
          systemNavigationBarDividerColor: AppTheme.darkSystemUiBackground,
          systemNavigationBarContrastEnforced: false,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
      return;
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppTheme.lightSystemUiBackground,
        systemNavigationBarDividerColor: AppTheme.lightSystemUiBackground,
        systemNavigationBarContrastEnforced: false,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _bindNotificationRouting(
    GoRouter router,
    PushNotificationService pushNotificationService,
  ) {
    _notificationRouteHandler ??= NotificationRouteHandler(
      ref.read(hadithOfDayNotificationServiceProvider),
      pushService: pushNotificationService,
    );
    _notificationRouteHandler!.bind(router);
  }

  Future<void> _prepareHadithOfDayIfNeeded() async {
    if (_didPrepareHadithOfDay || kIsWeb || !mounted) return;

    _didPrepareHadithOfDay = true;
    try {
      await prepareHadithOfDayOnAppLaunch(ref);
    } catch (error, stackTrace) {
      _didPrepareHadithOfDay = false;
      debugPrint('Hadith of day preparation failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}

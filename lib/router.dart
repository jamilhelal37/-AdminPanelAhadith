import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/presentation/screens/admin_screen.dart';
import 'core/presentation/screens/app_splash_screen.dart';
import 'features/ahadith/domain/models/hadith.dart';
import 'features/ahadith/presentation/models/search_results_args.dart';
import 'features/ahadith/presentation/models/sub_valid_screen_args.dart';
import 'features/ahadith/presentation/screens/advanced_search_screen.dart';
import 'features/ahadith/presentation/screens/general_search_screen.dart';
import 'features/ahadith/presentation/screens/hadith_detail_screen.dart';
import 'features/ahadith/presentation/screens/hadith_of_day_screen.dart';
import 'features/ahadith/presentation/screens/search_results_screen.dart';
import 'features/ahadith/presentation/screens/sub_valid_hadith_screen.dart';
import 'features/ahadith/presentation/screens/user_home_screen.dart';
import 'features/auth/domain/models/app_user.dart';
import 'features/auth/presentation/providers/auth_notifier_provider.dart';
import 'features/auth/presentation/providers/providers.dart';
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/auth/presentation/screens/profile_screen.dart';
import 'features/books/domain/models/book.dart';
import 'features/books/presentation/screens/book_hadiths_screen.dart';
import 'features/books/presentation/screens/books_sources_screen.dart';
import 'features/comment/presentation/screens/hadith_comments_screen.dart';
import 'features/comment/presentation/screens/my_comments_screen.dart';
import 'features/fake_ahadith/presentation/screens/fake_ahadiths_screen.dart';
import 'features/fake_ahadith/presentation/screens/fake_hadith_notification_screen.dart';
import 'features/favorites/presentation/screens/favorites_screen.dart';
import 'features/muhaddiths/presentation/screens/muhaddiths_biographies_screen.dart';
import 'features/notifications/domain/models/notification_details_args.dart';
import 'features/notifications/presentation/screens/notification_details_screen.dart';
import 'features/pro_upgrade/presentation/screens/pro_upgrade_screen.dart';
import 'features/questions/presentation/screens/my_questions_screen.dart';
import 'features/rawis/presentation/screens/rawis_biographies_screen.dart';
import 'features/similar_ahadith/domain/models/similar_ahadith.dart';
import 'features/similar_ahadith/presentation/screens/similar_ahadith_screen.dart';

class AppRouteNames {
  AppRouteNames._();

  static const String home = 'home';
  static const String generalSearch = 'general-search';
  static const String advancedSearch = 'advanced-search';
  static const String searchResults = 'search-results';
  static const String hadithOfDay = 'hadith-of-day';
  static const String hadithDetail = 'hadith-detail';
  static const String subValidHadith = 'sub-valid-hadith';
  static const String bookHadiths = 'book-hadiths';
  static const String similarAhadith = 'similar-ahadith';
  static const String muhaddiths = 'muhaddiths';
  static const String rawis = 'rawis';
  static const String books = 'books';
  static const String favorites = 'favorites';
  static const String myQuestions = 'my-questions';
  static const String myComments = 'my-comments';
  static const String hadithComments = 'hadith-comments';
  static const String notificationDetails = 'notification-details';
  static const String proUpgrade = 'pro-upgrade';
  static const String profile = 'profile';
  static const String fakeAhadith = 'fake-ahadith';
  static const String fakeHadithNotification = 'fake-hadith-notification';
  static const String admin = 'admin';
  static const String auth = 'auth';
  static const String splash = 'splash';
}

final routerProvider = Provider<GoRouter>((ref) {
  if (kIsWeb) {
    return GoRouter(
      initialLocation: '/admin',
      redirect: (_, state) {
        final status = ref.read(authSessionStatusProvider);
        if (status == AuthSessionStatus.booting) {
          return null;
        }

        final isAdmin =
            ref.read(authNotifierProvider).valueOrNull?.type == UserType.admin;
        if (status == AuthSessionStatus.anonymous || !isAdmin) {
          return state.matchedLocation == '/auth' ? null : '/auth';
        }

        if (state.matchedLocation == '/auth' || state.matchedLocation == '/') {
          return '/admin';
        }

        return state.matchedLocation == '/admin' ? null : '/admin';
      },
      routes: [
        GoRoute(path: '/', redirect: (_, _) => '/admin'),
        GoRoute(
          path: '/auth',
          name: AppRouteNames.auth,
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: '/admin',
          name: AppRouteNames.admin,
          builder: (context, state) => AdminScreen(),
        ),
      ],
    );
  }

  return GoRouter(
    initialLocation: '/splash',
    redirect: (_, state) {
      switch (ref.read(authSessionStatusProvider)) {
        case AuthSessionStatus.booting:
          return state.matchedLocation == '/splash' ? null : '/splash';
        case AuthSessionStatus.anonymous:
          return state.matchedLocation == '/auth' ? null : '/auth';
        case AuthSessionStatus.authenticated:
          if (state.matchedLocation == '/auth' ||
              state.matchedLocation == '/splash') {
            return '/';
          }
          return null;
      }
    },
    routes: [
      GoRoute(
        path: '/',
        name: AppRouteNames.home,
        builder: (context, state) => const UserHomeScreen(),
      ),
      GoRoute(
        path: '/splash',
        name: AppRouteNames.splash,
        builder: (context, state) => const AppSplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        name: AppRouteNames.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/general-search',
        name: AppRouteNames.generalSearch,
        builder: (context, state) => const GeneralSearchScreen(),
      ),
      GoRoute(
        path: '/advanced-search',
        name: AppRouteNames.advancedSearch,
        builder: (context, state) => const AdvancedSearchScreen(),
      ),
      GoRoute(
        path: '/search-results',
        name: AppRouteNames.searchResults,
        builder: (context, state) {
          final args = state.extra;
          if (args is! SearchResultsArgs) {
            return _invalidRoute('بيانات نتائج البحث غير صالحة.');
          }
          return SearchResultsScreen(args: args);
        },
      ),
      GoRoute(
        path: '/hadith-of-day',
        name: AppRouteNames.hadithOfDay,
        builder: (context, state) => const HadithOfDayScreen(),
      ),
      GoRoute(
        path: '/hadith-detail',
        name: AppRouteNames.hadithDetail,
        builder: (context, state) {
          final hadith = state.extra;
          if (hadith is! Hadith) {
            return _invalidRoute('بيانات تفاصيل الحديث غير صالحة.');
          }
          return HadithDetailScreen(hadith: hadith);
        },
      ),
      GoRoute(
        path: '/sub-valid-hadith',
        name: AppRouteNames.subValidHadith,
        builder: (context, state) {
          final args = state.extra;
          if (args is! SubValidScreenArgs) {
            return _invalidRoute('بيانات الصحيح البديل غير صالحة.');
          }
          return SubValidHadithScreen(args: args);
        },
      ),
      GoRoute(
        path: '/book-hadiths',
        name: AppRouteNames.bookHadiths,
        builder: (context, state) {
          final book = state.extra;
          if (book is! Book) {
            return _invalidRoute('بيانات أحاديث الكتاب غير صالحة.');
          }
          return BookHadithsScreen(book: book);
        },
      ),
      GoRoute(
        path: '/similar-ahadith',
        name: AppRouteNames.similarAhadith,
        builder: (context, state) {
          final payload = state.extra;
          if (payload is! Map<String, Object?>) {
            return _invalidRoute('بيانات الأحاديث المشابهة غير صالحة.');
          }

          final mainHadith = payload['mainHadith'];
          final similar = payload['similarAhadiths'];
          if (mainHadith is! Hadith || similar is! List<SimilarAhadith>) {
            return _invalidRoute('بيانات الأحاديث المشابهة غير صالحة.');
          }

          return SimilarAhadithScreen(
            mainHadith: mainHadith,
            similarAhadiths: similar,
          );
        },
      ),
      GoRoute(
        path: '/muhaddiths',
        name: AppRouteNames.muhaddiths,
        builder: (context, state) => const MuhaddithsBiographiesScreen(),
      ),
      GoRoute(
        path: '/rawis',
        name: AppRouteNames.rawis,
        builder: (context, state) => const RawisBiographiesScreen(),
      ),
      GoRoute(
        path: '/books',
        name: AppRouteNames.books,
        builder: (context, state) => const BooksSourcesScreen(),
      ),
      GoRoute(
        path: '/favorites',
        name: AppRouteNames.favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/my-questions',
        name: AppRouteNames.myQuestions,
        builder: (context, state) => const MyQuestionsScreen(),
      ),
      GoRoute(
        path: '/my-comments',
        name: AppRouteNames.myComments,
        builder: (context, state) => const MyCommentsScreen(),
      ),
      GoRoute(
        path: '/hadith-comments',
        name: AppRouteNames.hadithComments,
        builder: (context, state) {
          final hadith = state.extra;
          if (hadith is! Hadith) {
            return _invalidRoute('بيانات تعليقات الحديث غير صالحة.');
          }
          return HadithCommentsScreen(hadith: hadith);
        },
      ),
      GoRoute(
        path: '/notification-details',
        name: AppRouteNames.notificationDetails,
        builder: (context, state) {
          final args =
              NotificationDetailsArgs.tryFromUri(state.uri) ??
              (state.extra is NotificationDetailsArgs
                  ? state.extra as NotificationDetailsArgs
                  : null);
          if (args == null) {
            return _invalidRoute('بيانات الإشعار غير صالحة.');
          }

          return NotificationDetailsScreen(args: args);
        },
      ),
      GoRoute(
        path: '/pro-upgrade',
        name: AppRouteNames.proUpgrade,
        builder: (context, state) => const ProUpgradeScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: AppRouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/fake-ahadith',
        name: AppRouteNames.fakeAhadith,
        builder: (context, state) => FakeAhadithScreen(
          notificationFakeHadithId:
              state.uri.queryParameters['notificationFakeHadithId'],
        ),
      ),
      GoRoute(
        path: '/fake-hadith-notification',
        name: AppRouteNames.fakeHadithNotification,
        builder: (context, state) {
          final fakeAhadithId =
              state.uri.queryParameters['id'] ?? state.extra?.toString();
          if (fakeAhadithId == null || fakeAhadithId.isEmpty) {
            return _invalidRoute('بيانات الحديث المنتشر غير صالحة.');
          }

          return FakeHadithNotificationScreen(fakeAhadithId: fakeAhadithId);
        },
      ),
    ],
  );
});

Widget _invalidRoute(String message) {
  return Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    ),
  );
}


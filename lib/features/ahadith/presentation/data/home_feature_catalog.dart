import 'package:flutter/material.dart';

import '../../../../router.dart';
import '../../../auth/domain/models/app_user.dart';
import '../models/home_feature_item.dart';

class HomeFeatureCatalog {
  HomeFeatureCatalog._();

  static const String logoutRouteName = 'logout';

  static const List<HomeFeatureItem> baseFeatures = [
    HomeFeatureItem(
      label: 'البحث العام',
      icon: Icons.search,
      routeName: AppRouteNames.generalSearch,
    ),
    HomeFeatureItem(
      label: 'البحث المتقدم',
      icon: Icons.manage_search_rounded,
      routeName: AppRouteNames.advancedSearch,
    ),
    HomeFeatureItem(
      label: 'الكتب والمصادر',
      icon: Icons.menu_book,
      routeName: AppRouteNames.books,
    ),
    HomeFeatureItem(
      label: 'أحاديث منتشرة لا تصح',
      icon: Icons.gpp_bad_outlined,
      routeName: AppRouteNames.fakeAhadith,
    ),
    HomeFeatureItem(
      label: 'تراجم المحدثين',
      icon: Icons.record_voice_over,
      routeName: AppRouteNames.muhaddiths,
    ),
    HomeFeatureItem(
      label: 'تراجم الرواة',
      icon: Icons.groups_2_outlined,
      routeName: AppRouteNames.rawis,
    ),
    HomeFeatureItem(
      label: 'قائمة المفضلة',
      icon: Icons.bookmark,
      routeName: AppRouteNames.favorites,
    ),
    HomeFeatureItem(
      label: 'أسئلتي',
      icon: Icons.question_answer_outlined,
      routeName: AppRouteNames.myQuestions,
    ),
    HomeFeatureItem(
      label: 'حديث اليوم',
      icon: Icons.auto_stories_rounded,
      routeName: AppRouteNames.hadithOfDay,
    ),
    HomeFeatureItem(
      label: 'طلب الترقية لعالم',
      icon: Icons.workspace_premium_outlined,
      routeName: AppRouteNames.proUpgrade,
    ),
    HomeFeatureItem(
      label: 'ملفي الشخصي',
      icon: Icons.account_circle_outlined,
      routeName: AppRouteNames.profile,
    ),
    HomeFeatureItem(
      label: 'تسجيل الخروج',
      icon: Icons.logout,
      routeName: logoutRouteName,
    ),
  ];

  static const HomeFeatureItem myCommentsFeature = HomeFeatureItem(
    label: 'تعليقاتي',
    icon: Icons.rate_review_outlined,
    routeName: AppRouteNames.myComments,
  );

  static List<HomeFeatureItem> featuresForUser(AppUser? currentUser) {
    final userType = currentUser?.type;
    final features = baseFeatures.where((feature) {
      if (feature.routeName == AppRouteNames.proUpgrade) {
        return userType != null && userType == UserType.member;
      }
      return true;
    }).toList();

    if (userType == UserType.scholar &&
        !features.any(
          (feature) => feature.routeName == AppRouteNames.myComments,
        )) {
      final profileIndex = features.indexWhere(
        (feature) => feature.routeName == AppRouteNames.profile,
      );
      if (profileIndex == -1) {
        features.add(myCommentsFeature);
      } else {
        features.insert(profileIndex, myCommentsFeature);
      }
    }

    return features;
  }
}



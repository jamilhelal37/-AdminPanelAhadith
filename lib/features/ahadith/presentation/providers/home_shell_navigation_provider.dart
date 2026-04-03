import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../router.dart';

final homeNavIndexProvider = StateProvider<int>((ref) => 0);
const String homeShellSettingsRouteName = 'home-shell-settings';

abstract final class HomeShellSectionIndex {
  static const int home = 0;
  static const int favorites = 1;
  static const int myQuestions = 2;
  static const int settings = 3;
  static const int profile = 4;
}

const Map<String, int> _homeShellIndexByRouteName = <String, int>{
  AppRouteNames.home: HomeShellSectionIndex.home,
  AppRouteNames.favorites: HomeShellSectionIndex.favorites,
  AppRouteNames.myQuestions: HomeShellSectionIndex.myQuestions,
  homeShellSettingsRouteName: HomeShellSectionIndex.settings,
  AppRouteNames.profile: HomeShellSectionIndex.profile,
};

int? homeShellIndexForRouteName(String routeName) {
  return _homeShellIndexByRouteName[routeName];
}

void setHomeShellSection(WidgetRef ref, int index) {
  ref.read(homeNavIndexProvider.notifier).state = index;
}

bool selectHomeShellSectionForRouteName(WidgetRef ref, String routeName) {
  final index = homeShellIndexForRouteName(routeName);
  if (index == null) {
    return false;
  }

  setHomeShellSection(ref, index);
  return true;
}


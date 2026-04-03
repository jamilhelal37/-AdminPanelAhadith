import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/golden_drawer.dart';
import '../../../../router.dart';
import '../../../auth/presentation/providers/auth_notifier_provider.dart';
import '../../../auth/presentation/widgets/profile_content_widget.dart';
import '../../../favorites/presentation/widgets/favorites_content_widget.dart';
import '../../../questions/presentation/providers/my_questions_provider.dart';
import '../../../questions/presentation/widgets/ask_question_dialog.dart';
import '../../../questions/presentation/widgets/ask_question_floating_button.dart';
import '../../../questions/presentation/widgets/questions_content_widget.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../data/home_feature_catalog.dart';
import '../models/home_feature_item.dart';
import '../providers/home_shell_navigation_provider.dart';

/// User Home Screen - الشاشة الرئيسية للمستخدم بالتصميم الذهبي
class UserHomeScreen extends ConsumerStatefulWidget {
  const UserHomeScreen({super.key});

  @override
  ConsumerState<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends ConsumerState<UserHomeScreen> {
  int get _selectedIndex => ref.watch(homeNavIndexProvider);

  String get _appBarTitle {
    switch (_selectedIndex) {
      case HomeShellSectionIndex.favorites:
        return 'قائمة المفضلة';
      case HomeShellSectionIndex.myQuestions:
        return 'أسئلتي';
      case HomeShellSectionIndex.settings:
        return 'الإعدادات';
      case HomeShellSectionIndex.profile:
        return 'ملفي الشخصي';
      case HomeShellSectionIndex.home:
      default:
        return 'الرئيسية';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: kIsWeb ? null : const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: false,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _selectedIndex == HomeShellSectionIndex.myQuestions
          ? AskQuestionFloatingButton(
              label: 'اطرح سؤالك',
              onPressed: () async {
                await showDialog<void>(
                  context: context,
                  builder: (_) => const AskQuestionDialog(),
                );
                ref.invalidate(myQuestionsProvider);
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_selectedIndex) {
      case HomeShellSectionIndex.home:
        return _buildHomeContent(context);
      case HomeShellSectionIndex.favorites:
        return _buildFavoritesContent(context);
      case HomeShellSectionIndex.myQuestions:
        return _buildQuestionsContent(context);
      case HomeShellSectionIndex.settings:
        return _buildSettingsContent(context);
      case HomeShellSectionIndex.profile:
        return _buildProfileContent(context);
      default:
        return _buildHomeContent(context);
    }
  }

  Widget _buildHomeContent(BuildContext context) {
    final currentUser = ref.watch(authNotifierProvider).valueOrNull;
    final features = HomeFeatureCatalog.featuresForUser(currentUser);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          return _buildFeatureCard(context, features[index]);
        },
      ),
    );
  }

  Widget _buildFavoritesContent(BuildContext context) {
    return const FavoritesContent();
  }

  Widget _buildQuestionsContent(BuildContext context) {
    return const QuestionsContent();
  }

  Widget _buildProfileContent(BuildContext context) {
    return const ProfileContentWidget();
  }

  Widget _buildSettingsContent(BuildContext context) {
    return const SettingsScreen();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final appBarBg = colorScheme.surface;

    return PreferredSize(
      preferredSize: Size.fromHeight(102 + statusBarHeight),
      child: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Container(
          height: 102,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: appBarBg,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: Image.asset(
                  'assets/images/pic1.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.mosque,
                      size: 50,
                      color: colorScheme.primary,
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _appBarTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'مرحباً بكم في الموسوعة الحديثية',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              if (kIsWeb)
                const SizedBox(width: 50, height: 50)
              else
                Builder(
                  builder: (BuildContext builderContext) {
                    return GestureDetector(
                      onTap: () {
                        Scaffold.of(builderContext).openEndDrawer();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withValues(alpha: 0.12),
                        ),
                        child: Icon(
                          Icons.dashboard_customize_rounded,
                          color: colorScheme.primary,
                          size: 26,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, HomeFeatureItem feature) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentUser = ref.watch(authNotifierProvider).valueOrNull;
    final avatarUrl = currentUser?.avatarUrl?.trim();
    final hasProfileAvatar =
        feature.routeName == AppRouteNames.profile &&
        avatarUrl != null &&
        avatarUrl.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant, width: 1.5),
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _handleHomeFeatureTap(feature),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: feature.routeName == HomeFeatureCatalog.logoutRouteName
                      ? Colors.red.withValues(alpha: 0.12)
                      : colorScheme.primary.withValues(alpha: 0.12),
                ),
                child: hasProfileAvatar
                    ? ClipOval(
                        child: Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              feature.icon,
                              size: 32,
                              color: colorScheme.primary,
                            );
                          },
                        ),
                      )
                    : Icon(
                        feature.icon,
                        size: 32,
                        color:
                            feature.routeName ==
                                HomeFeatureCatalog.logoutRouteName
                            ? Colors.red
                            : colorScheme.primary,
                      ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  feature.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, height: 1.5),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = ref.watch(authNotifierProvider).valueOrNull;
    final profileAvatarUrl = currentUser?.avatarUrl?.trim();
    final navSurface = colorScheme.surface;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: navSurface.withValues(alpha: isDark ? 0.96 : 0.9),
              borderRadius: BorderRadius.circular(34),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(
                  alpha: isDark ? 0.4 : 0.55,
                ),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.35)
                      : colorScheme.primary.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildNavItem(
                    context,
                    activeIcon: Icons.home_rounded,
                    inactiveIcon: Icons.home_outlined,
                    label: 'الرئيسية',
                    index: 0,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    activeIcon: Icons.bookmark_rounded,
                    inactiveIcon: Icons.bookmark_border_rounded,
                    label: 'المفضلة',
                    index: 1,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    activeIcon: Icons.question_answer_rounded,
                    inactiveIcon: Icons.question_answer_outlined,
                    label: 'أسئلتي',
                    index: 2,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    activeIcon: Icons.settings,
                    inactiveIcon: Icons.settings_outlined,
                    label: 'الإعدادات',
                    index: 3,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    activeIcon: Icons.account_circle_rounded,
                    inactiveIcon: Icons.account_circle_outlined,
                    label: 'ملفي',
                    index: 4,
                    avatarUrl:
                        (profileAvatarUrl != null &&
                            profileAvatarUrl.isNotEmpty)
                        ? profileAvatarUrl
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
    required int index,
    String? avatarUrl,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedIndex == index;
    final inactiveColor = colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: () {
        setHomeShellSection(ref, index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        curve: Curves.easeOut,
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.2),
                    colorScheme.primary.withValues(alpha: 0.11),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNavIcon(
              isSelected: isSelected,
              activeIcon: activeIcon,
              inactiveIcon: inactiveIcon,
              activeColor: colorScheme.primary,
              inactiveColor: inactiveColor,
              avatarUrl: avatarUrl,
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: TextStyle(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleHomeFeatureTap(HomeFeatureItem feature) async {
    if (feature.routeName == HomeFeatureCatalog.logoutRouteName) {
      await ref.read(authNotifierProvider.notifier).logout();
      if (!mounted) return;
      context.goNamed(AppRouteNames.auth);
      return;
    }

    final didSelectSection = selectHomeShellSectionForRouteName(
      ref,
      feature.routeName,
    );
    if (didSelectSection || !mounted) {
      return;
    }

    context.pushNamed(feature.routeName);
  }

  Widget _buildNavIcon({
    required bool isSelected,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required Color activeColor,
    required Color inactiveColor,
    String? avatarUrl,
  }) {
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? activeColor : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: ClipOval(
          child: Image.network(
            avatarUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                isSelected ? activeIcon : inactiveIcon,
                size: 21,
                color: isSelected ? activeColor : inactiveColor,
              );
            },
          ),
        ),
      );
    }

    return Icon(
      isSelected ? activeIcon : inactiveIcon,
      size: 21,
      color: isSelected ? activeColor : inactiveColor,
    );
  }
}




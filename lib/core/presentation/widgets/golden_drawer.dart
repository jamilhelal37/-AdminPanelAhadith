import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../router.dart';
import '../../../features/ahadith/presentation/data/home_feature_catalog.dart';
import '../../../features/ahadith/presentation/models/home_feature_item.dart';
import '../../../features/ahadith/presentation/providers/home_shell_navigation_provider.dart';
import '../../../features/auth/presentation/providers/auth_notifier_provider.dart';

const double goldenDrawerWidth = 268;


class GoldenAppDrawer extends ConsumerWidget {
  const GoldenAppDrawer({super.key, this.userName, this.userImage});

  final String? userName;
  final String? userImage;

  void _closeDrawer(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  ImageProvider<Object>? _avatarProvider(String? avatar) {
    if (avatar == null || avatar.trim().isEmpty) return null;
    final normalized = avatar.trim();
    if (normalized.startsWith('assets/')) {
      return AssetImage(normalized);
    }
    return NetworkImage(normalized);
  }

  Future<void> _handleFeatureTap(
    BuildContext context,
    WidgetRef ref,
    HomeFeatureItem feature,
  ) async {
    await _handleRouteTap(context, ref, feature.routeName);
  }

  Future<void> _handleRouteTap(
    BuildContext context,
    WidgetRef ref,
    String routeName,
  ) async {
    final router = GoRouter.of(context);
    _closeDrawer(context);

    if (routeName == HomeFeatureCatalog.logoutRouteName) {
      await ref.read(authNotifierProvider.notifier).logout();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        router.goNamed(AppRouteNames.auth);
      });
      return;
    }

    final didSelectSection = selectHomeShellSectionForRouteName(ref, routeName);
    if (didSelectSection) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        router.goNamed(AppRouteNames.home);
      });
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.pushNamed(routeName);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final appUser = ref.watch(authNotifierProvider).valueOrNull;
    final features = HomeFeatureCatalog.featuresForUser(appUser).map((feature) {
      if (feature.routeName != AppRouteNames.profile) {
        return feature;
      }

      return const HomeFeatureItem(
        label: 'الإعدادات',
        icon: Icons.settings_outlined,
        routeName: homeShellSettingsRouteName,
      );
    }).toList();
    final currentUser = Supabase.instance.client.auth.currentUser;
    final metadata = currentUser?.userMetadata ?? <String, dynamic>{};
    final resolvedName = (userName?.trim().isNotEmpty == true)
        ? userName!.trim()
        : (appUser?.name?.trim().isNotEmpty == true)
        ? appUser!.name!.trim()
        : (metadata['full_name'] as String?)?.trim().isNotEmpty == true
        ? (metadata['full_name'] as String).trim()
        : (currentUser?.email?.split('@').first ??
              'مستخدم');
    final resolvedEmail = appUser?.email ?? (currentUser?.email ?? '');
    final resolvedAvatar = (userImage?.trim().isNotEmpty == true)
        ? userImage!.trim()
        : (appUser?.avatarUrl?.trim().isNotEmpty == true)
        ? appUser!.avatarUrl!.trim()
        : (metadata['avatar_url'] as String?) ??
              (metadata['picture'] as String?);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Drawer(
        elevation: 25.0,
        width: goldenDrawerWidth,
        backgroundColor: cs.surface,
        child: SafeArea(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [cs.surface, cs.primary.withValues(alpha: 0.04)],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: _DrawerHeaderCard(
                    name: resolvedName,
                    email: resolvedEmail,
                    avatarProvider: _avatarProvider(resolvedAvatar),
                    onProfileTap: () =>
                        _handleRouteTap(context, ref, AppRouteNames.profile),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: features
                          .map(
                            (feature) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _DrawerFeatureCard(
                                feature: feature,
                                onTap: () =>
                                    _handleFeatureTap(context, ref, feature),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerHeaderCard extends StatelessWidget {
  const _DrawerHeaderCard({
    required this.name,
    required this.email,
    required this.avatarProvider,
    required this.onProfileTap,
  });

  final String name;
  final String email;
  final ImageProvider<Object>? avatarProvider;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.7)),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [cs.primary.withValues(alpha: 0.14), cs.surface],
        ),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: cs.surface.withValues(alpha: 0.9),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.6),
                ),
              ),
              child: Text(
                'الملف الشخصي',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onProfileTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: cs.surfaceContainerHighest,
                      backgroundImage: avatarProvider,
                      child: avatarProvider == null
                          ? Icon(
                              Icons.person_rounded,
                              size: 24,
                              color: cs.primary,
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, height: 1.5),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerFeatureCard extends StatelessWidget {
  const _DrawerFeatureCard({required this.feature, required this.onTap});

  final HomeFeatureItem feature;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLogout = feature.routeName == HomeFeatureCatalog.logoutRouteName;
    final iconBg = isLogout
        ? Colors.red.withValues(alpha: 0.12)
        : cs.primary.withValues(alpha: 0.12);
    final iconColor = isLogout ? Colors.red : cs.primary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLogout
              ? Colors.red.withValues(alpha: 0.2)
              : cs.outlineVariant.withValues(alpha: 0.8),
          width: 1,
        ),
        color: cs.surface.withValues(alpha: 0.98),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                _DrawerFeatureIcon(
                  backgroundColor: iconBg,
                  iconColor: iconColor,
                  icon: feature.icon,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    feature.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerFeatureIcon extends StatelessWidget {
  const _DrawerFeatureIcon({
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
  });

  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}


class GoldenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GoldenAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = false,
    this.showMenuButton = false,
    this.onMenuPressed,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool showMenuButton;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: cs.surface,
      elevation: 0,
      title: Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
      centerTitle: true,
      leading:
          leading ??
          (showBackButton
              ? IconButton(
                  icon: Icon(Icons.arrow_back, color: cs.primary),
                  onPressed: () => context.pop(),
                )
              : null),
      actions:
          actions ??
          (showMenuButton
              ? [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      icon: Icon(Icons.menu, color: cs.primary),
                      onPressed: onMenuPressed,
                    ),
                  ),
                ]
              : null),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}




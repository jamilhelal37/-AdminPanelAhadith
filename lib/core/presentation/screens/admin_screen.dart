import 'dart:async';

import 'package:ahadith/features/similar_ahadith/presentation/screens/admin_similar_ahadith_screen.dart';
import 'package:ahadith/features/topic_class/presentation/screens/admin_topic_class_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/repositories/admin_metrics_repository.dart';
import '../../../features/ahadith/presentation/providers/admin_hadith_future_provider.dart';
import '../../../features/ahadith/presentation/screens/admin_hadith_screen.dart';
import '../../../features/admin_audit_log/presentation/providers/admin_audit_log_providers.dart';
import '../../../features/admin_audit_log/presentation/screens/admin_audit_log_screen.dart';
import '../../../features/auth/presentation/providers/auth_notifier_provider.dart';
import '../../../features/auth/presentation/providers/admin_users_provider.dart';
import '../../../features/auth/presentation/screens/admin_users_screen.dart';
import '../../../features/books/presentation/screens/admin_book_screen.dart';
import '../../../features/books/presentation/providers/admin_book_future_provider.dart';
import '../../../features/explaining/presentation/screens/admin_explaining_screen.dart';
import '../../../features/explaining/presentation/providers/admin_explaining_future_provider.dart';
import '../../../features/fake_ahadith/presentation/screens/admin_fake_ahadith_screen.dart';
import '../../../features/fake_ahadith/presentation/providers/admin_fakeahadith_future_provider.dart';
import '../../../features/muhaddiths/presentation/screens/admin_muhaddith_screen.dart'
    show AdminMuhaddithScreen;
import '../../../features/muhaddiths/presentation/providers/muhaddith_future_provider.dart';
import '../../../features/notifications/presentation/screens/admin_notifications_screen.dart';
import '../../../features/pro_upgrade/presentation/providers/admin_pro_upgrade_requests_provider.dart';
import '../../../features/pro_upgrade/presentation/screens/admin_pro_upgrade_screen.dart';
import '../../../features/questions/presentation/providers/asker_options_provider.dart';
import '../../../features/questions/presentation/providers/question_future_provider.dart';
import '../../../features/questions/presentation/screens/admin_question_screen.dart';
import '../../../features/rawis/presentation/providers/admin_rawi_future_provider.dart';
import '../../../features/rawis/presentation/screens/admin_rawi_screen.dart';
import '../../../features/ruling/presentation/providers/ruling_future_provider.dart';
import '../../../features/ruling/presentation/screens/admin_ruling_screen.dart';
import '../../../features/similar_ahadith/presentation/providers/admin_similar_ahadith_future_provider.dart';
import '../../../features/topic_class/presentation/providers/admin_topic_class_future_provider.dart';
import '../../../features/topics/presentation/providers/topic_future_provider.dart';
import '../../../features/topics/presentation/screens/admin_topic_screen.dart';
import '../providers/admin_navigation_index_provider.dart';
import '../providers/admin_table_count_provider.dart';
import '../../../features/settings/presentation/widgets/theme_dialog_widget.dart';
import 'admin_home_screen.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  late final ScrollController _railScrollController;
  Timer? _railScrollbarHideTimer;
  bool _showRailScrollbar = false;

  static const _sections = <_AdminSection>[
    _AdminSection(
      label: 'الرئيسية',
      subtitle: 'نظرة عامة وإحصائيات سريعة',
      icon: Icons.dashboard_outlined,
    ),
    _AdminSection(
      label: 'أحكام الحديث',
      subtitle: 'إدارة أحكام الأحاديث ومراجعتها',
      icon: Icons.school_outlined,
    ),
    _AdminSection(
      label: 'الرواة',
      subtitle: 'تحرير بيانات الرواة وتحديثها',
      icon: Icons.groups_2_outlined,
    ),
    _AdminSection(
      label: 'المحدثون',
      subtitle: 'إدارة بيانات المحدثين',
      icon: Icons.record_voice_over,
    ),
    _AdminSection(
      label: 'الكتب',
      subtitle: 'تنظيم الكتب والمصادر',
      icon: Icons.menu_book,
    ),
    _AdminSection(
      label: 'الشروحات',
      subtitle: 'متابعة الشروحات  ',
      icon: Icons.menu_book_outlined,
    ),
    _AdminSection(
      label: 'المواضيع',
      subtitle: 'تعديل المواضيع  ',
      icon: Icons.category_outlined,
    ),
    _AdminSection(
      label: 'الأسئلة',
      subtitle: 'مراجعة الأسئلة وإجاباتها',
      icon: Icons.question_answer_outlined,
    ),
    _AdminSection(
      label: 'الأحاديث',
      subtitle: 'إدارة الأحاديث الأساسية',
      icon: Icons.auto_stories_rounded,
    ),
    _AdminSection(
      label: 'أحاديث منتشرة لا تصح ',
      subtitle: 'توثيق الأحاديث المنتشرة التي لا تصح ومراجعتها',
      icon: Icons.gpp_bad_outlined,
    ),
    _AdminSection(
      label: 'تصنيف المواضيع',
      subtitle: 'تنظيم شجرة التصنيفات',
      icon: Icons.account_tree_outlined,
    ),
    _AdminSection(
      label: 'الأحاديث المتشابهة',
      subtitle: 'ربط الأحاديث المتقاربة في المعنى',
      icon: Icons.compare_arrows_outlined,
    ),
    _AdminSection(
      label: 'الإشعارات',
      subtitle: 'إرسال إشعارات فورية ',
      icon: Icons.notifications_active_outlined,
    ),
    _AdminSection(
      label: 'طلبات الترقية',
      subtitle: 'مراجعة الطلبات والوثائق والقرارات',
      icon: Icons.workspace_premium_outlined,
    ),
    _AdminSection(
      label: 'المستخدمون',
      subtitle: 'متابعة حسابات المستخدمين وصلاحياتهم',
      icon: Icons.group_outlined,
    ),
    _AdminSection(
      label: 'سجل نشاط المشرفين',
      subtitle: 'سجل العمليات على الجداول الإدارية',
      icon: Icons.history_edu_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _railScrollController = ScrollController();
  }

  @override
  void dispose() {
    _railScrollbarHideTimer?.cancel();
    _railScrollController.dispose();
    super.dispose();
  }

  void _setRailScrollbarVisibility(bool visible) {
    if (_showRailScrollbar == visible || !mounted) return;
    setState(() {
      _showRailScrollbar = visible;
    });
  }

  void _activateRailScrollbar() {
    _railScrollbarHideTimer?.cancel();
    _setRailScrollbarVisibility(true);
  }

  void _scheduleRailScrollbarHide() {
    _railScrollbarHideTimer?.cancel();
    _railScrollbarHideTimer = Timer(const Duration(milliseconds: 650), () {
      _setRailScrollbarVisibility(false);
    });
  }

  bool _onRailScrollNotification(ScrollNotification notification) {
    final isUserScrolling =
        notification is UserScrollNotification &&
        notification.direction != ScrollDirection.idle;
    final isActiveScroll =
        notification is ScrollStartNotification ||
        notification is ScrollUpdateNotification ||
        isUserScrolling;

    if (isActiveScroll) {
      _activateRailScrollbar();
      return false;
    }

    final endedByUser =
        notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle;
    final isScrollEnd = notification is ScrollEndNotification || endedByUser;
    if (isScrollEnd) {
      _scheduleRailScrollbarHide();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(adminsNavigationIndexProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final extended = screenWidth >= 1160;
    final cs = Theme.of(context).colorScheme;
    final safeIndex = selectedIndex.clamp(0, _sections.length - 1);
    final selectedSection = _sections[safeIndex];

    final pageBackground = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Color.alphaBlend(cs.primary.withValues(alpha: 0.05), cs.surface),
        Theme.of(context).scaffoldBackgroundColor,
        Color.alphaBlend(
          cs.primaryContainer.withValues(alpha: 0.18),
          cs.surface,
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: pageBackground),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1660),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Container(
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.84),
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(
                      color: cs.outlineVariant.withValues(alpha: 0.28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cs.shadow.withValues(alpha: 0.08),
                        blurRadius: 34,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _buildRail(context, extended, selectedIndex),
                      VerticalDivider(
                        thickness: 1.1,
                        width: 1.1,
                        color: cs.outlineVariant.withValues(alpha: 0.28),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                          child: Column(
                            children: [
                              _AdminTopBar(
                                section: selectedSection,
                                extended: extended,
                                onRefresh: () =>
                                    _refreshCurrentSection(safeIndex),
                              ),
                              const SizedBox(height: 14),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color.alphaBlend(
                                        cs.surface.withValues(alpha: 0.82),
                                        Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor,
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: _getBody(selectedIndex),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _refreshCurrentSection(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        for (final target in AdminCountTarget.values) {
          ref.invalidate(adminTableCountProvider(target));
        }
        break;
      case 1:
        ref.invalidate(adminRulingsFutureProvider);
        break;
      case 2:
        ref.invalidate(adminRawisFutureProvider);
        break;
      case 3:
        ref.invalidate(adminMuhaddithFutureProvider);
        break;
      case 4:
        ref.invalidate(adminBooksFutureProvider);
        ref.invalidate(adminMuhaddithFutureProvider);
        break;
      case 5:
        ref.invalidate(adminExplainingsFutureProvider);
        break;
      case 6:
        ref.invalidate(adminTopicsFutureProvider);
        break;
      case 7:
        ref.invalidate(adminQuestionsFutureProvider);
        ref.invalidate(askerOptionsFutureProvider);
        break;
      case 8:
        ref.invalidate(adminHadithsFutureProvider);
        break;
      case 9:
        ref.invalidate(adminFakeAhadithsFutureProvider);
        break;
      case 10:
        ref.invalidate(adminTopicClassesFutureProvider);
        break;
      case 11:
        ref.invalidate(adminSimilarAhadithsFutureProvider);
        break;
      case 12:
        
        
        ref.invalidate(adminUsersProvider);
        break;
      case 13:
        ref.invalidate(adminProUpgradeRequestsProvider);
        ref.invalidate(
          adminTableCountProvider(AdminCountTarget.proUpgradeRequests),
        );
        ref.invalidate(
          adminTableCountProvider(AdminCountTarget.proUpgradeDecisions),
        );
        
        ref.invalidate(adminUsersProvider);
        ref.invalidate(authNotifierProvider);
        break;
      case 14:
        
        ref.invalidate(adminUsersProvider);
        break;
      case 15:
        ref.invalidate(adminAuditLogFutureProvider);
        break;
      default:
        break;
    }
  }

  Widget _buildRail(BuildContext context, bool extended, int selectedIndex) {
    final cs = Theme.of(context).colorScheme;
    final baseTooltipTheme = TooltipTheme.of(context);
    final railTooltipDecoration = baseTooltipTheme.decoration is BoxDecoration
        ? (baseTooltipTheme.decoration as BoxDecoration).copyWith(
            borderRadius: BorderRadius.circular(14),
          )
        : BoxDecoration(
            color: Color.alphaBlend(
              cs.inverseSurface.withValues(alpha: 0.94),
              cs.surface,
            ),
            borderRadius: BorderRadius.circular(14),
          );

    return TooltipTheme(
      data: baseTooltipTheme.copyWith(decoration: railTooltipDecoration),
      child: Container(
        width: extended ? 236 : 80,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            cs.primaryContainer.withValues(alpha: 0.12),
            cs.surface,
          ),
          borderRadius: const BorderRadius.horizontal(
            right: Radius.circular(34),
          ),
        ),
        child: Column(
          children: [
            _RailHeader(extended: extended),
            const SizedBox(height: 10),
            Expanded(
              child: MouseRegion(
                onEnter: (_) => _activateRailScrollbar(),
                onHover: (_) => _activateRailScrollbar(),
                onExit: (_) => _scheduleRailScrollbarHide(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: _onRailScrollNotification,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0,
                      end: _showRailScrollbar ? 6.5 : 0,
                    ),
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    builder: (context, thickness, child) {
                      final thumbColor = cs.outlineVariant.withValues(
                        alpha: thickness > 0.05 ? 0.72 : 0,
                      );

                      return ScrollbarTheme(
                        data: ScrollbarTheme.of(context).copyWith(
                          thickness: WidgetStatePropertyAll(thickness),
                          radius: const Radius.circular(14),
                          thumbColor: WidgetStatePropertyAll(thumbColor),
                          trackVisibility: const WidgetStatePropertyAll(false),
                        ),
                        child: Scrollbar(
                          controller: _railScrollController,
                          thumbVisibility: _showRailScrollbar,
                          interactive: _showRailScrollbar,
                          child: child!,
                        ),
                      );
                    },
                    child: ListView.builder(
                      controller: _railScrollController,
                      padding: const EdgeInsets.only(top: 2, bottom: 10),
                      itemCount: _sections.length,
                      itemBuilder: (context, index) {
                        final section = _sections[index];
                        return _NavItem(
                          extended: extended,
                          selected: selectedIndex == index,
                          icon: section.icon,
                          label: section.label,
                          onTap: () {
                            ref
                                    .read(
                                      adminsNavigationIndexProvider.notifier,
                                    )
                                    .state =
                                index;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBody(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const AdminHomeScreen();
      case 1:
        return const AdminRulingScreen();
      case 2:
        return const AdminRawiScreen();
      case 3:
        return const AdminMuhaddithScreen();
      case 4:
        return const AdminBookScreen();
      case 5:
        return const AdminExplainingScreen();
      case 6:
        return const AdminTopicScreen();
      case 7:
        return const AdminQuestionScreen();
      case 8:
        return const AdminHadithScreen();
      case 9:
        return const AdminFakeAhadithScreen();
      case 10:
        return const AdminTopicClassScreen();
      case 11:
        return const AdminSimilarAhadithScreen();
      case 12:
        return const AdminNotificationsScreen();
      case 13:
        return const AdminProUpgradeScreen();
      case 14:
        return const AdminUsersScreen();
      case 15:
        return const AdminAuditLogScreen();
      default:
        return const AdminHomeScreen();
    }
  }
}

class _AdminSection {
  const _AdminSection({
    required this.label,
    required this.subtitle,
    required this.icon,
  });

  final String label;
  final String subtitle;
  final IconData icon;
}

class _RailHeader extends StatelessWidget {
  const _RailHeader({required this.extended});

  final bool extended;

  @override
  Widget build(BuildContext context) {
    return _RailIdentityTile(
      extended: extended,
      icon: Icons.admin_panel_settings_outlined,
      label: 'لوحة التحكم',
    );
  }
}

class _RailIdentityTile extends StatelessWidget {
  const _RailIdentityTile({
    required this.extended,
    required this.icon,
    required this.label,
  });

  final bool extended;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: extended ? 10 : 8,
        vertical: extended ? 8 : 8,
      ),
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.26)),
      ),
      child: Row(
        mainAxisAlignment: extended
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          Container(
            width: extended ? 42 : 40,
            height: extended ? 42 : 40,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: cs.primary, size: extended ? 21 : 20),
          ),
          if (extended) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum _TopBarMenuAction { theme, logout }

class _AdminTopBar extends ConsumerWidget {
  const _AdminTopBar({
    required this.section,
    required this.extended,
    required this.onRefresh,
  });

  final _AdminSection section;
  final bool extended;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: extended ? 16 : 12,
        vertical: extended ? 12 : 10,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.surface.withValues(alpha: 0.94),
            Color.alphaBlend(
              cs.primaryContainer.withValues(alpha: 0.24),
              cs.surface,
            ),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.26)),
      ),
      child: IconButtonTheme(
        data: IconButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              cs.surface.withValues(alpha: 0.84),
            ),
            foregroundColor: WidgetStatePropertyAll(cs.primary),
            side: WidgetStatePropertyAll(
              BorderSide(color: cs.outlineVariant.withValues(alpha: 0.3)),
            ),
          ),
        ),
        child: Row(
          children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(section.icon, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize:
                        (Theme.of(context).textTheme.titleLarge?.fontSize ??
                            22) -
                        3,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  section.subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: onRefresh,
            tooltip: 'تحديث البيانات',
            icon: const Icon(Icons.sync_rounded, size: 20),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<_TopBarMenuAction>(
            tooltip: 'خيارات إضافية',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            onSelected: (action) {
              switch (action) {
                case _TopBarMenuAction.theme:
                  showDialog(
                    context: context,
                    builder: (_) => ThemeDialogWidget(),
                  );
                  break;
                case _TopBarMenuAction.logout:
                  ref.read(authNotifierProvider.notifier).logout();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<_TopBarMenuAction>(
                value: _TopBarMenuAction.theme,
                child: Row(
                  children: [
                    Icon(Icons.palette_outlined),
                    SizedBox(width: 8),
                    Text('تخصيص السمة'),
                  ],
                ),
              ),
              PopupMenuItem<_TopBarMenuAction>(
                value: _TopBarMenuAction.logout,
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: cs.error),
                    SizedBox(width: 8),
                    Text(
                      'تسجيل الخروج',
                      style: TextStyle(color: cs.error),
                    ),
                  ],
                ),
              ),
            ],
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.surface.withValues(alpha: 0.84),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.more_horiz_rounded,
                color: cs.primary,
                size: 22,
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}


class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.extended,
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool extended;
  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final itemBg = Colors.transparent;
    final idleIconBg = cs.surface.withValues(alpha: 0.76);
    final selectedTextColor = cs.primary;
    final idleTextColor = cs.onSurface.withValues(alpha: 0.82);
    final selectedIconColor = cs.primary;
    final idleIconColor = cs.onSurfaceVariant;
    final selectedBorder = cs.primary.withValues(alpha: 0.34);
    final idleBorder = cs.outlineVariant.withValues(alpha: 0.12);
    final itemRadius = BorderRadius.circular(16);

    return InkWell(
      onTap: onTap,
      borderRadius: itemRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: EdgeInsets.symmetric(horizontal: extended ? 2 : 3, vertical: 3),
        padding: EdgeInsets.symmetric(
          horizontal: extended ? 8 : 0,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: itemBg,
          borderRadius: itemRadius,
          border: Border.all(color: selected ? selectedBorder : idleBorder),
        ),
        child: extended
            ? Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 40,
                    height: 34,
                    decoration: BoxDecoration(
                      color: idleIconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: selected ? selectedIconColor : idleIconColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.6,
                        color: selected ? selectedTextColor : idleTextColor,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: idleIconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: selected ? selectedIconColor : idleIconColor,
                  ),
                ),
              ),
      ),
    );
  }
}

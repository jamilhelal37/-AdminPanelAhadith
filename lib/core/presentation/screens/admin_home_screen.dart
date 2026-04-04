import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/admin_metrics_repository.dart';
import '../providers/admin_navigation_index_provider.dart';
import '../providers/admin_table_count_provider.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  static const List<_DashboardStat> _stats = [
    _DashboardStat(
      title: 'أحكام الحديث',
      target: AdminCountTarget.rulings,
      icon: Icons.gavel_outlined,
      targetIndex: 1,
    ),
    _DashboardStat(
      title: 'الرواة',
      target: AdminCountTarget.rawis,
      icon: Icons.groups_2_outlined,
      targetIndex: 2,
    ),
    _DashboardStat(
      title: 'المحدثون',
      target: AdminCountTarget.muhaddiths,
      icon: Icons.record_voice_over,
      targetIndex: 3,
    ),
    _DashboardStat(
      title: 'الكتب',
      target: AdminCountTarget.books,
      icon: Icons.menu_book,
      targetIndex: 4,
    ),
    _DashboardStat(
      title: 'الأحاديث',
      target: AdminCountTarget.ahadith,
      icon: Icons.auto_stories_rounded,
      targetIndex: 8,
    ),
    _DashboardStat(
      title: 'المواضيع',
      target: AdminCountTarget.topics,
      icon: Icons.category_outlined,
      targetIndex: 6,
    ),
    _DashboardStat(
      title: 'الأسئلة',
      target: AdminCountTarget.questions,
      icon: Icons.question_answer_outlined,
      targetIndex: 7,
    ),
    _DashboardStat(
      title: 'المستخدمون',
      target: AdminCountTarget.users,
      icon: Icons.group_outlined,
      targetIndex: 14,
    ),
    _DashboardStat(
      title: ' أحاديث منتشرة لا تصح',
      target: AdminCountTarget.fakeAhadith,
      icon: Icons.gpp_bad_outlined,
      targetIndex: 9,
    ),
    _DashboardStat(
      title: 'تصنيف المواضيع',
      target: AdminCountTarget.topicClass,
      icon: Icons.account_tree_outlined,
      targetIndex: 10,
    ),
    _DashboardStat(
      title: 'الأحاديث المتشابهة',
      target: AdminCountTarget.similarAhadith,
      icon: Icons.compare_arrows_outlined,
      targetIndex: 11,
    ),
    _DashboardStat(
      title: 'طلبات الترقية',
      target: AdminCountTarget.proUpgradeRequests,
      icon: Icons.workspace_premium_outlined,
      targetIndex: 13,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 1400
            ? 4
            : width >= 1000
            ? 3
            : width >= 640
            ? 2
            : 1;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.9,
          ),
          itemCount: _stats.length,
          itemBuilder: (context, index) {
            return _CountCard(stat: _stats[index]);
          },
        );
      },
    );
  }
}

class _CountCard extends ConsumerWidget {
  const _CountCard({required this.stat});

  final _DashboardStat stat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(adminTableCountProvider(stat.target));
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          ref.read(adminsNavigationIndexProvider.notifier).state =
              stat.targetIndex;
        },
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: 0.45),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 36,
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(stat.icon, color: cs.primary),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_outward_rounded,
                    size: 18,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.72),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                stat.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const Spacer(),
              countAsync.when(
                data: (count) => Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.primary,
                  ),
                ),
                loading: () => const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (error, stackTrace) => Text(
                  'خطأ',
                  style: TextStyle(
                    color: cs.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardStat {
  const _DashboardStat({
    required this.title,
    required this.target,
    required this.icon,
    required this.targetIndex,
  });

  final String title;
  final AdminCountTarget target;
  final IconData icon;
  final int targetIndex;
}

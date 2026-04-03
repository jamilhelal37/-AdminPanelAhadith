import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/widgets/core_actions_widget.dart';
import '../../../../../core/presentation/widgets/golden_drawer.dart';
import '../../../../../router.dart';
import '../../domain/models/notification_details_args.dart';

class NotificationDetailsScreen extends StatelessWidget {
  const NotificationDetailsScreen({super.key, required this.args});

  final NotificationDetailsArgs args;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      endDrawer: const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: cs.surface,
        foregroundColor: cs.primary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            context.goNamed(AppRouteNames.home);
          },
        ),
        actions: const [CoreActionsWidget()],
        title: const Text('الإشعارات'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withValues(alpha: 0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.notifications_active_rounded,
                          color: cs.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          args.title.trim().isEmpty
                              ? 'إشعار جديد'
                              : args.title,
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: cs.outlineVariant.withValues(alpha: 0.55),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    args.body.trim().isEmpty
                        ? 'لا يوجد محتوى'
                        : args.body,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




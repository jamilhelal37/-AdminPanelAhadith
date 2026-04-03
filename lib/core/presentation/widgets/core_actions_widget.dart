import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/presentation/providers/auth_notifier_provider.dart';
import '../../../features/questions/presentation/widgets/ask_question_dialog.dart';
import '../../../features/settings/presentation/widgets/theme_dialog_widget.dart';
import 'golden_drawer.dart';

class CoreActionsWidget extends ConsumerWidget {
  const CoreActionsWidget({
    super.key,
    this.inAppHome = false,
    this.openDrawer = true,
    this.iconColor,
  });

  final bool? inAppHome;
  final bool openDrawer;
  final Color? iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(authNotifierProvider).valueOrNull != null;

    if (openDrawer && !kIsWeb) {
      return Builder(
        builder: (context) {
          final scaffold = Scaffold.maybeOf(context);
          final iconColor =
              this.iconColor ??
              IconTheme.of(context).color ??
              Theme.of(context).colorScheme.onSurface;

          return IconButton(
            icon: Icon(Icons.more_vert_rounded, color: iconColor),
            onPressed: () {
              if (scaffold?.hasEndDrawer ?? false) {
                scaffold?.openEndDrawer();
                return;
              }
              _showDrawerPanel(context);
            },
          );
        },
      );
    }

    return _buildPopupMenu(context, ref, isAuthenticated);
  }

  Widget _buildPopupMenu(
    BuildContext context,
    WidgetRef ref,
    bool isAuthenticated,
  ) {
    final resolvedIconColor =
        iconColor ??
        IconTheme.of(context).color ??
        Theme.of(context).colorScheme.onSurface;

    return PopupMenuButton(
      iconColor: resolvedIconColor,
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            child: const Text('السمة'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => ThemeDialogWidget(),
              );
            },
          ),
          if (isAuthenticated) ...[
            PopupMenuItem(
              child: const Text('اطرح سؤالاً'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const AskQuestionDialog(),
                );
              },
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              child: Text(
                'تسجيل الخروج',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () {
                ref.read(authNotifierProvider.notifier).logout();
              },
            ),
          ],
        ];
      },
    );
  }

  void _showDrawerPanel(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'drawer',
      barrierColor: Colors.black.withValues(alpha: 0.22),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const Align(
          alignment: Alignment.centerRight,
          child: SizedBox(width: goldenDrawerWidth, child: GoldenAppDrawer()),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
    );
  }
}

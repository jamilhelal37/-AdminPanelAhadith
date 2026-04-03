import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/loading_provider.dart';

const _confirmationDialogLoadingScope = 'confirmation-dialog';

class ConfirmationDialog extends ConsumerWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.confirmText,
    this.cancelText,
    this.icon,
    this.confirmButtonColor,
  });

  final String title;
  final String content;
  final Future<void> Function() onConfirm;
  final String? confirmText;
  final String? cancelText;
  final IconData? icon;
  final Color? confirmButtonColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxDialogWidth = screenWidth >= 1280
        ? 460.0
        : screenWidth >= 960
        ? 440.0
        : 420.0;
    final isLoading = ref.watch(
      scopedLoadingProvider(_confirmationDialogLoadingScope),
    );
    final actionColor = confirmButtonColor ?? colorScheme.primary;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxDialogWidth),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.7),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: actionColor.withValues(alpha: 0.12),
                        border: Border.all(
                          color: actionColor.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Icon(
                        icon ?? Icons.delete_outline_rounded,
                        color: actionColor,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _DialogActionButton(
                          label: (cancelText ?? 'إلغاء'),
                          icon: Icons.close_rounded,
                          onPressed: isLoading
                              ? null
                              : () => Navigator.of(context).pop(),
                          foregroundColor: colorScheme.onSurfaceVariant,
                          backgroundColor: colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.42),
                          borderColor: colorScheme.outlineVariant.withValues(
                            alpha: 0.55,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _DialogActionButton(
                          label: (confirmText ?? 'حذف'),
                          icon: isLoading ? null : Icons.check_rounded,
                          onPressed: isLoading
                              ? null
                              : () async {
                                  try {
                                    ref
                                            .read(
                                              scopedLoadingProvider(
                                                _confirmationDialogLoadingScope,
                                              ).notifier,
                                            )
                                            .state =
                                        true;
                                    await onConfirm();
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  } catch (_) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'حدث خطأ أثناء تنفيذ العملية',
                                          ),
                                        ),
                                      );
                                    }
                                  } finally {
                                    ref
                                            .read(
                                              scopedLoadingProvider(
                                                _confirmationDialogLoadingScope,
                                              ).notifier,
                                            )
                                            .state =
                                        false;
                                  }
                                },
                          foregroundColor: actionColor,
                          backgroundColor: actionColor.withValues(alpha: 0.12),
                          borderColor: actionColor.withValues(alpha: 0.18),
                          trailing: isLoading
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: actionColor,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogActionButton extends StatelessWidget {
  const _DialogActionButton({
    required this.label,
    required this.onPressed,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
    this.icon,
    this.trailing,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: backgroundColor,
            border: Border.all(color: borderColor),
            boxShadow: onPressed == null
                ? null
                : [
                    BoxShadow(
                      color: borderColor.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: foregroundColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(fontSize: 14),
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}



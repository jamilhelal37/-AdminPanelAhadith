import 'package:flutter/material.dart';

class AdminWebDialogShell extends StatelessWidget {
  const AdminWebDialogShell({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.onClose,
    this.badges = const <Widget>[],
    this.footer,
    this.maxWidth = 900,
    this.maxHeightFactor = 0.86,
    this.bodyPadding = const EdgeInsets.fromLTRB(24, 24, 24, 20),
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget body;
  final VoidCallback onClose;
  final List<Widget> badges;
  final Widget? footer;
  final double maxWidth;
  final double maxHeightFactor;
  final EdgeInsetsGeometry bodyPadding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.sizeOf(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: screenSize.height * maxHeightFactor,
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.alphaBlend(
                  cs.primary.withValues(alpha: 0.06),
                  cs.surface,
                ),
                cs.surface.withValues(alpha: 0.98),
                Color.alphaBlend(
                  cs.primaryContainer.withValues(alpha: 0.18),
                  cs.surface,
                ),
              ],
            ),
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: 0.28),
            ),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.1),
                blurRadius: 34,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 22, 20, 22),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        cs.surface.withValues(alpha: 0.94),
                        Color.alphaBlend(
                          cs.primaryContainer.withValues(alpha: 0.28),
                          cs.surface,
                        ),
                      ],
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.24),
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              cs.primary.withValues(alpha: 0.18),
                              cs.primaryContainer.withValues(alpha: 0.66),
                            ],
                          ),
                          border: Border.all(
                            color: cs.primary.withValues(alpha: 0.14),
                          ),
                        ),
                        child: Icon(icon, color: cs.primary, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: cs.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              subtitle,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    height: 1.45,
                                    color: cs.onSurfaceVariant,
                                  ),
                            ),
                            if (badges.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              Wrap(spacing: 8, runSpacing: 8, children: badges),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton.filledTonal(
                        onPressed: onClose,
                        tooltip: 'إغلاق',
                        icon: const Icon(Icons.close_rounded, size: 20),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(padding: bodyPadding, child: body),
                ),
                if (footer != null)
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.84),
                      border: Border(
                        top: BorderSide(
                          color: cs.outlineVariant.withValues(alpha: 0.24),
                        ),
                      ),
                    ),
                    child: footer,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminWebDialogSection extends StatelessWidget {
  const AdminWebDialogSection({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.action,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? action;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          cs.surfaceContainerHighest.withValues(alpha: 0.16),
          cs.surface,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || subtitle != null || action != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: cs.onSurface,
                              ),
                        ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                height: 1.45,
                                color: cs.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (action != null) ...[const SizedBox(width: 12), action!],
              ],
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }
}

class AdminWebDialogBadge extends StatelessWidget {
  const AdminWebDialogBadge({
    super.key,
    required this.label,
    this.icon,
    this.highlighted = false,
  });

  final String label;
  final IconData? icon;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final backgroundColor = highlighted
        ? Color.alphaBlend(
            cs.primary.withValues(alpha: 0.08),
            cs.primaryContainer.withValues(alpha: 0.4),
          )
        : cs.surface.withValues(alpha: 0.78);
    final foregroundColor = highlighted ? cs.primary : cs.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: (highlighted ? cs.primary : cs.outlineVariant).withValues(
            alpha: highlighted ? 0.22 : 0.26,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: foregroundColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

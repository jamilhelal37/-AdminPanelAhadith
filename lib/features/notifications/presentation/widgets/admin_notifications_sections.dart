import 'package:flutter/material.dart';

class AdminNotificationAudienceToggle extends StatelessWidget {
  const AdminNotificationAudienceToggle({
    super.key,
    required this.isToAllUsers,
    required this.onChanged,
  });

  final bool isToAllUsers;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final vertical = constraints.maxWidth < 680;

        return Flex(
          direction: vertical ? Axis.vertical : Axis.horizontal,
          children: [
            Expanded(
              flex: vertical ? 0 : 1,
              child: _AdminNotificationAudienceOption(
                title: 'جميع المستخدمين',
                icon: Icons.groups_rounded,
                selected: isToAllUsers,
                onTap: () => onChanged(true),
              ),
            ),
            SizedBox(width: vertical ? 0 : 12, height: vertical ? 12 : 0),
            Expanded(
              flex: vertical ? 0 : 1,
              child: _AdminNotificationAudienceOption(
                title: 'مستخدم محدد',
                icon: Icons.person_outline_rounded,
                selected: !isToAllUsers,
                onTap: () => onChanged(false),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AdminNotificationAudienceOption extends StatelessWidget {
  const _AdminNotificationAudienceOption({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? Color.alphaBlend(
                    cs.primary.withValues(alpha: 0.08),
                    cs.primaryContainer.withValues(alpha: 0.42),
                  )
                : cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? cs.primary.withValues(alpha: 0.24)
                  : cs.outlineVariant.withValues(alpha: 0.32),
              width: selected ? 1.3 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: selected
                      ? cs.primary.withValues(alpha: 0.12)
                      : cs.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: selected ? cs.primary : cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: selected
                    ? Icon(
                        Icons.check_circle_rounded,
                        key: const ValueKey('selected'),
                        color: cs.primary,
                      )
                    : Container(
                        key: const ValueKey('unselected'),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: cs.outlineVariant.withValues(alpha: 0.8),
                          ),
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

class AdminNotificationInfoBanner extends StatelessWidget {
  const AdminNotificationInfoBanner({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: cs.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

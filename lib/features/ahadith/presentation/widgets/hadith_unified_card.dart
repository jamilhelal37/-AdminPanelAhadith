import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/hadith_card_widget.dart';
import '../../domain/models/hadith.dart';

enum HadithCardSelectionMode { none, single, multi }

class HadithUnifiedCard extends StatelessWidget {
  const HadithUnifiedCard({
    super.key,
    required this.hadith,
    this.muhaddithName,
    this.isSelected = false,
    this.selectionMode = HadithCardSelectionMode.none,
    this.onTap,
    this.onChangePressed,
    this.title,
    this.textMaxLength = 150,
  });

  final Hadith hadith;
  final String? muhaddithName;
  final bool isSelected;
  final HadithCardSelectionMode selectionMode;
  final VoidCallback? onTap;
  final VoidCallback? onChangePressed;
  final String? title;
  final int textMaxLength;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outline.withValues(alpha: 0.2),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: HadithCard(
                hadith: hadith,
                muhaddithName: muhaddithName,
                onTap: onTap,
                showActionButtons: false,
                margin: EdgeInsets.zero,
              ),
            ),
            if (selectionMode != HadithCardSelectionMode.none)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline,
                      width: 2,
                    ),
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.surface,
                  ),
                  child: isSelected
                      ? Icon(
                          selectionMode == HadithCardSelectionMode.multi
                              ? Icons.done_all
                              : Icons.check,
                          size: 14,
                          color: colorScheme.onPrimary,
                        )
                      : null,
                ),
              ),
            if (onChangePressed != null)
              Positioned(
                top: 4,
                right: 4,
                child: Material(
                  color: colorScheme.surface,
                  shape: const CircleBorder(),
                  elevation: 1,
                  child: IconButton(
                    onPressed: onChangePressed,
                    icon: const Icon(Icons.edit),
                    tooltip: 'تغيير الحديث',
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

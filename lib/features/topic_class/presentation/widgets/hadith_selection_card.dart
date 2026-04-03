import 'package:flutter/material.dart';

import '../../../ahadith/domain/models/hadith.dart';

class HadithSelectionCard extends StatelessWidget {
  const HadithSelectionCard({
    super.key,
    required this.selectedHadith,
    required this.onAddHadith,
  });

  final Hadith? selectedHadith;
  final VoidCallback onAddHadith;

  String _short(String? text, {int max = 180}) {
    if (text == null) return 'غير محدد';
    final value = text.trim();
    if (value.isEmpty) return 'غير محدد';
    if (value.length <= max) return value;
    return '${value.substring(0, max)}...';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (selectedHadith == null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onAddHadith,
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                cs.primaryContainer.withValues(alpha: 0.14),
                cs.surface,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.28),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.add_link_rounded,
                    size: 30,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'لم يتم اختيار حديث بعد',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'اضغط هنا لاختيار الحديث الذي تريد ربطه بالموضوعات.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: onAddHadith,
                  icon: const Icon(Icons.auto_stories_rounded),
                  label: const Text('اختيار حديث'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final hadith = selectedHadith!;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'الحديث المحدد',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onAddHadith,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('تغيير الحديث'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.tag_rounded,
                label: 'رقم ${hadith.hadithNumber}',
              ),
              _InfoChip(
                icon: Icons.menu_book_outlined,
                label: hadith.sourceName ?? 'كتاب غير محدد',
              ),
              _InfoChip(
                icon: Icons.person_outline_rounded,
                label: hadith.rawiName ?? 'راوٍ غير محدد',
              ),
              _InfoChip(
                icon: Icons.sell_outlined,
                label: _getTypeName(hadith.type),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              _short(hadith.text),
              style: textTheme.bodyMedium?.copyWith(
                height: 1.7,
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeName(HadithType type) {
    switch (type) {
      case HadithType.marfu:
        return 'مرفوع';
      case HadithType.mawquf:
        return 'موقوف';
      case HadithType.qudsi:
        return 'قدسي';
      case HadithType.atharSahaba:
        return 'آثار الصحابة';
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: cs.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

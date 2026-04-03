import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';


class BiographyCardWidget extends StatelessWidget {
  const BiographyCardWidget({
    super.key,
    required this.serialNumber,
    required this.name,
    required this.biography,
    required this.sectionLabel,
    required this.onCopy,
    required this.onShare,
  });

  final int serialNumber;
  final String name;
  final String biography;
  final String sectionLabel;
  final VoidCallback onCopy;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final about = biography.trim().isEmpty ? '-' : biography;

    return Card(
      color: cs.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.8)),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: cs.primary.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Text(
                      sectionLabel,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cs.primary.withValues(alpha: 0.12),
                        ),
                        child: Text(
                          '$serialNumber',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '$name :',
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ReadMoreText(
                    about,
                    textDirection: TextDirection.rtl,
                    trimMode: TrimMode.Line,
                    trimLines: 5,
                    trimCollapsedText:
                        '\nعرض المزيد ...',
                    trimExpandedText: '\nعرض أقل',
                    moreStyle: TextStyle(fontSize: 14),
                    lessStyle: TextStyle(fontSize: 14),
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: cs.outlineVariant.withValues(alpha: 0.45),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    _BiographyActionChip(
                      label: 'نسخ',
                      icon: Icons.content_copy_rounded,
                      onPressed: onCopy,
                    ),
                    _BiographyActionChip(
                      label: 'مشاركة',
                      icon: Icons.share_rounded,
                      onPressed: onShare,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BiographyActionChip extends StatelessWidget {
  const _BiographyActionChip({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ActionChip(
        onPressed: onPressed,
        avatar: Icon(icon, color: cs.primary, size: 16),
        label: Text(
          label,
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: cs.surface,
        side: BorderSide(color: cs.primary.withValues(alpha: 0.35), width: 0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
    );
  }
}



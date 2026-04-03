import 'package:flutter/material.dart';

@immutable
class ArabicFontOption {
  const ArabicFontOption({
    required this.family,
    required this.label,
    required this.sample,
    required this.icon,
  });

  final String family;
  final String label;
  final String sample;
  final IconData icon;
}

const List<ArabicFontOption> arabicFontOptions = <ArabicFontOption>[
  ArabicFontOption(
    family: 'NotoSans',
    label: 'Noto Sans',
    sample: 'الموسوعة الحديثية',
    icon: Icons.auto_awesome_rounded,
  ),
  ArabicFontOption(
    family: 'Cairo',
    label: 'Cairo',
    sample: 'الموسوعة الحديثية',
    icon: Icons.style_rounded,
  ),
  ArabicFontOption(
    family: 'sans-serif',
    label: 'Sans Serif',
    sample: 'الموسوعة الحديثية',
    icon: Icons.text_fields_rounded,
  ),
  ArabicFontOption(
    family: 'sans-serif-medium',
    label: 'Medium Sans',
    sample: 'الموسوعة الحديثية',
    icon: Icons.short_text_rounded,
  ),
  ArabicFontOption(
    family: 'serif',
    label: 'Serif',
    sample: 'الموسوعة الحديثية',
    icon: Icons.notes_rounded,
  ),
  ArabicFontOption(
    family: 'monospace',
    label: 'Monospace',
    sample: 'الموسوعة الحديثية',
    icon: Icons.grid_view_rounded,
  ),
];

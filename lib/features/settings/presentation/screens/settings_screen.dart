import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/models/arabic_font_option.dart';
import '../providers/app_appearance_settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const double _baseFontSize = 14;
  static const double _minFontSize = 12;
  static const double _maxFontSize = 15;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appAppearanceSettingsValueProvider);
    final notifier = ref.read(appAppearanceSettingsProvider.notifier);
    final currentFontSize = (settings.fontScale * _baseFontSize).clamp(
      _minFontSize,
      _maxFontSize,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
        children: [
          _SettingsSectionCard(
            icon: Icons.palette_outlined,
            title: 'المظهر :',
            subtitle:
                'اختر نمط الواجهة المناسب للقراءة.',
            child: _SegmentedControl<ThemeMode>(
              value: settings.themeMode,
              merged: true,
              options: [
                _SegmentOption<ThemeMode>(
                  value: ThemeMode.system,
                  label: 'النظام',
                  icon: Icons.smartphone_rounded,
                ),
                _SegmentOption<ThemeMode>(
                  value: ThemeMode.light,
                  label: 'فاتح',
                  icon: Icons.light_mode_rounded,
                ),
                _SegmentOption<ThemeMode>(
                  value: ThemeMode.dark,
                  label: 'داكن',
                  icon: Icons.dark_mode_rounded,
                ),
              ],
              onChanged: notifier.setThemeMode,
            ),
          ),
          const SizedBox(height: 14),
          _SettingsSectionCard(
            icon: Icons.format_size_rounded,
            title: 'حجم الخط :',
            subtitle:
                'اضبط حجم القراءة بالقيمة الفعلية.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SizeIndicator(fontSize: currentFontSize),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _ScaleSign(
                      sign: '-',
                      enabled: currentFontSize > _minFontSize,
                      onTap: () {
                        final nextSize = (currentFontSize - 1).clamp(
                          _minFontSize,
                          _maxFontSize,
                        );
                        notifier.setFontScale(nextSize / _baseFontSize);
                      },
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer
                              .withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.16),
                          ),
                        ),
                        child: Text(
                          'الموسوعة الحديثية',
                          textAlign: TextAlign.center,
                          textScaler: TextScaler.linear(
                            currentFontSize / _baseFontSize,
                          ),
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _ScaleSign(
                      sign: '+',
                      enabled: currentFontSize < _maxFontSize,
                      onTap: () {
                        final nextSize = (currentFontSize + 1).clamp(
                          _minFontSize,
                          _maxFontSize,
                        );
                        notifier.setFontScale(nextSize / _baseFontSize);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SettingsSectionCard(
            icon: Icons.auto_fix_high_rounded,
            title: 'عرض النص :',
            subtitle:
                'بدّل بين النص المشكل والنص بلا تشكيل.',
            child: _SegmentedControl<bool>(
              value: settings.showTashkeel,
              merged: true,
              options: const [
                _SegmentOption<bool>(
                  value: true,
                  label: 'مع التشكيل',
                  icon: Icons.auto_awesome_rounded,
                ),
                _SegmentOption<bool>(
                  value: false,
                  label: 'بدون تشكيل',
                  icon: Icons.text_fields_rounded,
                ),
              ],
              onChanged: notifier.setShowTashkeel,
            ),
          ),
          const SizedBox(height: 14),
          _SettingsSectionCard(
            icon: Icons.font_download_outlined,
            title: 'الخط العربي :',
            subtitle:
                'اختر الخط المفضل للقراءة داخل التطبيق.',
            child: Column(
              children: arabicFontOptions
                  .map(
                    (option) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _FontOptionCard(
                        option: option,
                        isSelected: settings.fontFamily == option.family,
                        onTap: () => notifier.setFontFamily(option.family),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSectionCard extends StatelessWidget {
  const _SettingsSectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cs.primary.withValues(alpha: 0.11),
                ),
                child: Icon(icon, color: cs.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _SizeIndicator extends StatelessWidget {
  const _SizeIndicator({required this.fontSize});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: cs.surfaceContainerHighest.withValues(alpha: 0.32),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Icon(Icons.straighten_rounded, color: cs.primary, size: 18),
          const SizedBox(width: 8),
          Text(
            'الحجم الحالي',
            style: TextStyle(fontSize: 14),
          ),
          const Spacer(),
          Text(
            '${fontSize.round()}',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _ScaleSign extends StatelessWidget {
  const _ScaleSign({
    required this.sign,
    required this.enabled,
    required this.onTap,
  });

  final String sign;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: enabled
              ? cs.surfaceContainerHighest.withValues(alpha: 0.4)
              : cs.surfaceContainerHighest.withValues(alpha: 0.2),
          border: Border.all(
            color: enabled
                ? cs.outlineVariant.withValues(alpha: 0.45)
                : cs.outlineVariant.withValues(alpha: 0.25),
          ),
        ),
        child: Text(
          sign,
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}

class _SegmentOption<T> {
  const _SegmentOption({
    required this.value,
    required this.label,
    this.icon,
    this.svgAsset,
  });

  final T value;
  final String label;
  final IconData? icon;
  final String? svgAsset;
}

class _SegmentedControl<T> extends StatelessWidget {
  const _SegmentedControl({
    required this.value,
    required this.options,
    required this.onChanged,
    this.merged = false,
  });

  final T value;
  final List<_SegmentOption<T>> options;
  final ValueChanged<T> onChanged;
  final bool merged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final children = List.generate(options.length, (index) {
      final option = options[index];
      final button = _SegmentButton<T>(
        option: option,
        isSelected: option.value == value,
        onTap: () => onChanged(option.value),
        grouped: merged,
        isFirst: index == 0,
        isLast: index == options.length - 1,
      );

      if (!merged) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: button,
          ),
        );
      }

      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: button,
        ),
      );
    });

    if (!merged) {
      return SizedBox(
        width: double.infinity,
        child: Row(children: children),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.55)),
      ),
      child: Row(children: children),
    );
  }
}

class _SegmentButton<T> extends StatelessWidget {
  const _SegmentButton({
    required this.option,
    required this.isSelected,
    required this.onTap,
    this.grouped = false,
    this.isFirst = false,
    this.isLast = false,
  });

  final _SegmentOption<T> option;
  final bool isSelected;
  final VoidCallback onTap;
  final bool grouped;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(grouped ? 18 : 20);
    final displayLabel = option.value == ThemeMode.system
        ? 'نظام'
        : option.label;

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: isSelected
              ? cs.primary.withValues(alpha: grouped ? 0.14 : 0.12)
              : grouped
              ? Colors.transparent
              : cs.surfaceContainerHighest.withValues(alpha: 0.28),
          border: grouped
              ? null
              : Border.all(
                  color: isSelected
                      ? cs.primary.withValues(alpha: 0.35)
                      : cs.outlineVariant.withValues(alpha: 0.55),
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.07),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? cs.primary.withValues(alpha: 0.16)
                    : cs.surface,
              ),
              child: option.svgAsset != null
                  ? Center(
                      child: SvgPicture.asset(
                        option.svgAsset!,
                        width: 18,
                        height: 18,
                        colorFilter: ColorFilter.mode(
                          isSelected ? cs.primary : cs.onSurfaceVariant,
                          BlendMode.srcIn,
                        ),
                      ),
                    )
                  : Icon(
                      option.icon,
                      size: 16,
                      color: isSelected ? cs.primary : cs.onSurfaceVariant,
                    ),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                displayLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FontOptionCard extends StatelessWidget {
  const _FontOptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final ArabicFontOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? cs.primary.withValues(alpha: 0.12)
              : cs.surfaceContainerHighest.withValues(alpha: 0.28),
          border: Border.all(
            color: isSelected
                ? cs.primary.withValues(alpha: 0.35)
                : cs.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? cs.primary.withValues(alpha: 0.16)
                    : cs.surface,
              ),
              child: Icon(
                option.icon,
                size: 20,
                color: isSelected ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option.sample,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: cs.primary, size: 20),
          ],
        ),
      ),
    );
  }
}



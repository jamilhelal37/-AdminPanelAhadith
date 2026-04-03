import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/admin_web_dialog_shell.dart';
import '../providers/admin_explaining_future_provider.dart';
import '../providers/search_provider.dart';

class ExplainingPickerDialog extends ConsumerStatefulWidget {
  const ExplainingPickerDialog({super.key, this.currentExplainingId});

  final String? currentExplainingId;

  @override
  ConsumerState<ExplainingPickerDialog> createState() =>
      _ExplainingPickerDialogState();
}

class _ExplainingPickerDialogState
    extends ConsumerState<ExplainingPickerDialog> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.currentExplainingId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(searchProvider.notifier).state = '';
      }
    });

    _searchController.addListener(_syncSearchFieldState);
  }

  @override
  void dispose() {
    _searchController.removeListener(_syncSearchFieldState);
    _searchController.dispose();
    super.dispose();
  }

  void _syncSearchFieldState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onSearchChanged(String value) {
    ref.read(searchProvider.notifier).state = value;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.sizeOf(context);
    final maxDialogWidth = screenSize.width >= 1500
        ? 760.0
        : screenSize.width >= 1200
        ? 680.0
        : 600.0;
    final explainingsAsync = ref.watch(adminExplainingsFutureProvider);
    final resultCount = explainingsAsync.maybeWhen(
      data: (explainings) => explainings.length,
      orElse: () => null,
    );

    return AdminWebDialogShell(
      icon: Icons.menu_book_rounded,
      title: 'ربط الشرح',
      subtitle:
          'اختر شرحًا واحدًا لربطه بالحديث الحالي مع واجهة متوافقة مع هوية لوحة الويب.',
      maxWidth: maxDialogWidth,
      maxHeightFactor: 0.86,
      onClose: () => context.pop(),
      badges: [
        const AdminWebDialogBadge(
          label: 'اختيار شرح واحد',
          icon: Icons.checklist_rtl_rounded,
          highlighted: true,
        ),
        if (_selectedId != null)
          const AdminWebDialogBadge(
            label: 'تم تحديد شرح',
            icon: Icons.check_circle_rounded,
          ),
        if (resultCount != null)
          AdminWebDialogBadge(
            label: '$resultCount شرح',
            icon: Icons.notes_rounded,
          ),
      ],
      footer: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.close_rounded, size: 18),
              label: const Text('إلغاء'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 52),
                textStyle: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                side: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: () => context.pop(_selectedId ?? ''),
              icon: const Icon(Icons.check_rounded, size: 18),
              label: Text(_selectedId == null ? 'حفظ بدون شرح' : 'تأكيد الربط'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 52),
                textStyle: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminWebDialogSection(
            title: 'البحث داخل الشروحات',
            subtitle:
                'اكتب أي كلمة مفتاحية ثم اختر البطاقة التي تريد ربطها بالحديث الحالي.',
            action: _selectedId == null
                ? null
                : OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedId = null;
                      });
                    },
                    icon: const Icon(Icons.link_off_rounded, size: 18),
                    label: const Text('إزالة الربط'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      side: BorderSide(
                        color: colorScheme.error.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'ابحث في نص الشرح',
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: colorScheme.primary,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                        icon: const Icon(Icons.close_rounded),
                      )
                    : null,
                filled: true,
                fillColor: colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.34),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.34),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 1.6,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.12),
                  colorScheme.surface,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        'نتائج الشروحات',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _selectedId == null
                            ? 'اختر الشرح المناسب من القائمة'
                            : 'الشرح المختار جاهز للحفظ',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: explainingsAsync.when(
                        data: (explainings) {
                          if (explainings.isEmpty) {
                            return const _ExplainingStateMessage(
                              icon: Icons.search_off_rounded,
                              title: 'لا توجد شروحات مطابقة',
                              description:
                                  'جرّب عبارة بحث أخرى أو امسح البحث لعرض جميع الشروحات.',
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: explainings.length,
                            itemBuilder: (context, index) {
                              final explaining = explainings[index];
                              final isSelected = _selectedId == explaining.id;

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == explainings.length - 1
                                      ? 0
                                      : 10,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedId = explaining.id;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(18),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Color.alphaBlend(
                                                colorScheme.primary.withValues(
                                                  alpha: 0.08,
                                                ),
                                                colorScheme.primaryContainer
                                                    .withValues(alpha: 0.34),
                                              )
                                            : colorScheme.surface,
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: isSelected
                                              ? colorScheme.primary.withValues(
                                                  alpha: 0.3,
                                                )
                                              : colorScheme.outlineVariant
                                                    .withValues(alpha: 0.26),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 34,
                                            height: 34,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isSelected
                                                  ? colorScheme.primary
                                                  : colorScheme.surface,
                                              border: Border.all(
                                                color: isSelected
                                                    ? colorScheme.primary
                                                    : colorScheme.outline,
                                                width: 2,
                                              ),
                                            ),
                                            child: isSelected
                                                ? Icon(
                                                    Icons.check_rounded,
                                                    size: 18,
                                                    color:
                                                        colorScheme.onPrimary,
                                                  )
                                                : Text(
                                                    '${index + 1}',
                                                    style: textTheme.labelLarge
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: colorScheme
                                                              .onSurfaceVariant,
                                                        ),
                                                  ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  explaining.text,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: textTheme.bodyMedium
                                                      ?.copyWith(
                                                        height: 1.55,
                                                        fontWeight: isSelected
                                                            ? FontWeight.w700
                                                            : FontWeight.w500,
                                                        color: isSelected
                                                            ? colorScheme
                                                                  .onPrimaryContainer
                                                            : colorScheme
                                                                  .onSurface,
                                                      ),
                                                ),
                                                const SizedBox(height: 10),
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: [
                                                    _ExplainingMetaChip(
                                                      icon: Icons
                                                          .short_text_rounded,
                                                      label:
                                                          '${explaining.text.length} حرف',
                                                      selected: isSelected,
                                                    ),
                                                    _ExplainingMetaChip(
                                                      icon: Icons
                                                          .touch_app_rounded,
                                                      label: isSelected
                                                          ? 'تم اختياره'
                                                          : 'اضغط للاختيار',
                                                      selected: isSelected,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        error: (error, stack) => _ExplainingStateMessage(
                          icon: Icons.error_outline_rounded,
                          iconColor: colorScheme.error,
                          title: 'تعذر تحميل الشروحات',
                          description: error.toString(),
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExplainingStateMessage extends StatelessWidget {
  const _ExplainingStateMessage({
    required this.icon,
    required this.title,
    required this.description,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 52,
              color: iconColor ?? cs.primary.withValues(alpha: 0.72),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExplainingMetaChip extends StatelessWidget {
  const _ExplainingMetaChip({
    required this.icon,
    required this.label,
    required this.selected,
  });

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: selected
            ? cs.primary.withValues(alpha: 0.1)
            : cs.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: selected ? cs.primary : cs.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: selected ? cs.primary : cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

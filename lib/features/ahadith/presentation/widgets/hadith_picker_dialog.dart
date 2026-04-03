import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../books/domain/models/book.dart';
import '../../../books/presentation/providers/admin_book_future_provider.dart';
import '../../domain/models/hadith.dart';
import '../providers/admin_hadith_future_provider.dart';
import 'hadith_unified_card.dart';

class HadithPickerDialog extends ConsumerStatefulWidget {
  const HadithPickerDialog({
    super.key,
    this.currentHadithId,
    this.title,
    this.allowEmptySelection = true,
  });

  final String? currentHadithId;
  final String? title;
  final bool allowEmptySelection;

  @override
  ConsumerState<HadithPickerDialog> createState() => _HadithPickerDialogState();
}

class _HadithPickerDialogState extends ConsumerState<HadithPickerDialog> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.currentHadithId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(hadithPickerSearchProvider.notifier).state = '';
      }
    });

    _searchController.addListener(_handleSearchFieldState);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.removeListener(_handleSearchFieldState);
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchFieldState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    final trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      ref.read(hadithPickerSearchProvider.notifier).state = '';
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 280), () {
      if (!mounted) return;
      ref.read(hadithPickerSearchProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.sizeOf(context);
    final hasSearchQuery = _searchController.text.trim().isNotEmpty;
    final horizontalMargin = kIsWeb ? 24.0 : 36.0;
    final maxDialogWidth = (screenSize.width - horizontalMargin)
        .clamp(820.0, 1800.0)
        .toDouble();
    final ahadithAsync = ref.watch(adminHadithPickerFutureProvider);
    final booksById = <String, Book>{
      for (final book
          in ref.watch(allBooksFutureProvider).value ?? const <Book>[])
        if (book.id != null) book.id!: book,
    };
    final title = widget.title ?? 'ربط الحديث الصحيح';
    final resultCount = ahadithAsync.maybeWhen(
      data: (ahadith) => ahadith.length,
      orElse: () => null,
    );

    if (!kIsWeb) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxDialogWidth,
            maxHeight: screenSize.height * 0.84,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.42),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.12),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.auto_stories_rounded,
                        color: colorScheme.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Material(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.46,
                      ),
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.close_rounded),
                        color: colorScheme.onSurfaceVariant,
                        iconSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'ابحث',
                    prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    filled: true,
                    fillColor: colorScheme.surfaceContainerLowest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.45,
                        ),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.45,
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 1.6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (_selectedId != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedId = null;
                        });
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('إلغاء التحديد'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        side: BorderSide(color: colorScheme.error),
                      ),
                    ),
                  ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLowest.withValues(
                        alpha: 0.4,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: ahadithAsync.when(
                      data: (ahadith) {
                        if (ahadith.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'لا توجد نتائج',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: ahadith.length,
                          itemBuilder: (context, index) {
                            final hadith = ahadith[index];
                            final isSelected = _selectedId == hadith.id;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: HadithUnifiedCard(
                                hadith: hadith,
                                muhaddithName:
                                    booksById[hadith.sourceId]?.muhaddithName,
                                isSelected: isSelected,
                                selectionMode: HadithCardSelectionMode.single,
                                onTap: () {
                                  setState(() {
                                    _selectedId = hadith.id;
                                  });
                                },
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: colorScheme.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'خطأ في تحميل الأحاديث',
                              style: TextStyle(
                                color: colorScheme.error,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              error.toString(),
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.42,
                        ),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.close_rounded, size: 18),
                          label: const Text('إلغاء'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 48),
                            textStyle: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                            side: BorderSide(
                              color: colorScheme.outline.withValues(
                                alpha: 0.64,
                              ),
                              width: 1.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed:
                              widget.allowEmptySelection || _selectedId != null
                              ? () => context.pop(_selectedId ?? '')
                              : null,
                          icon: const Icon(Icons.check_rounded, size: 18),
                          label: Text(
                            widget.allowEmptySelection
                                ? 'تأكيد الاختيار'
                                : 'اختر حديثًا أولًا',
                          ),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 48),
                            textStyle: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxDialogWidth,
          maxHeight: screenSize.height * 0.95,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.28),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _WebHeader(
                title: title,
                resultCount: resultCount,
                onClose: () => context.pop(),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.22),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          'البحث والاختيار',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        if (_selectedId != null)
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _selectedId = null;
                              });
                            },
                            icon: const Icon(Icons.link_off_rounded, size: 16),
                            label: const Text('إزالة الربط'),
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              foregroundColor: colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'ابحث في رقم الحديث أو أي جزء من النص',
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                                icon: const Icon(Icons.close_rounded, size: 18),
                                visualDensity: VisualDensity.compact,
                              )
                            : null,
                        isDense: true,
                        filled: true,
                        fillColor: colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest.withValues(
                      alpha: 0.78,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            'نتائج المطابقة',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            resultCount == null ? '' : '$resultCount نتيجة',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: !hasSearchQuery
                            ? const _PickerStateMessage(
                                icon: Icons.manage_search_rounded,
                                title: 'ابدأ بكتابة رقم الحديث أو جزء من النص',
                                description:
                                    'نحمّل نتائج البحث فقط حتى تظهر الأحاديث بسرعة أكبر.',
                              )
                            : ahadithAsync.when(
                          data: (ahadith) {
                            if (ahadith.isEmpty) {
                              return const _PickerStateMessage(
                                icon: Icons.search_off_rounded,
                                title: 'لا توجد نتائج مطابقة',
                                description:
                                    'جرّب كلمات بحث مختلفة أو امسح البحث لإظهار جميع الأحاديث المتاحة.',
                              );
                            }

                            return GridView.builder(
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    mainAxisExtent: 188,
                                  ),
                              itemCount: ahadith.length,
                              itemBuilder: (context, index) {
                                final hadith = ahadith[index];
                                final isSelected = _selectedId == hadith.id;

                                return _CompactHadithPickerCard(
                                  hadith: hadith,
                                  muhaddithName:
                                      booksById[hadith.sourceId]?.muhaddithName,
                                  isSelected: isSelected,
                                  onTap: () {
                                    setState(() {
                                      _selectedId = hadith.id;
                                    });
                                  },
                                );
                              },
                            );
                          },
                          error: (error, stack) => _PickerStateMessage(
                            icon: Icons.error_outline_rounded,
                            iconColor: colorScheme.error,
                            title: 'تعذر تحميل الأحاديث',
                            description: error.toString(),
                          ),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close_rounded, size: 16),
                      label: const Text('إلغاء'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(96, 40),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        visualDensity: VisualDensity.compact,
                        textStyle: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        side: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.46),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed:
                          widget.allowEmptySelection || _selectedId != null
                          ? () => context.pop(_selectedId ?? '')
                          : null,
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: Text(
                        _selectedId == null
                            ? widget.allowEmptySelection
                                  ? 'حفظ بدون ربط'
                                  : 'اختر حديثًا أولًا'
                            : 'تأكيد الربط',
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(132, 40),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        visualDensity: VisualDensity.compact,
                        textStyle: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebHeader extends StatelessWidget {
  const _WebHeader({
    required this.title,
    required this.resultCount,
    required this.onClose,
  });

  final String title;
  final int? resultCount;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.auto_stories_rounded,
            color: colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                textAlign: TextAlign.right,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'اختر أحد الأحاديث',
                textAlign: TextAlign.right,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (resultCount != null) ...[
              _HeaderCountChip(count: resultCount!),
              const SizedBox(width: 8),
            ],
            Material(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.46,
              ),
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded),
                iconSize: 18,
                visualDensity: VisualDensity.compact,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeaderCountChip extends StatelessWidget {
  const _HeaderCountChip({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.format_list_bulleted_rounded,
            size: 16,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            '$count نتيجة',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactHadithPickerCard extends StatelessWidget {
  const _CompactHadithPickerCard({
    required this.hadith,
    required this.isSelected,
    required this.onTap,
    this.muhaddithName,
  });

  final Hadith hadith;
  final String? muhaddithName;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final metaStyle = textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w600,
      height: 1.2,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.08)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant.withValues(alpha: 0.28),
              width: isSelected ? 1.6 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.surface,
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outline,
                          width: 1.5,
                        ),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              size: 14,
                              color: colorScheme.onPrimary,
                            )
                          : null,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'رقم ${hadith.hadithNumber}',
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _CompactMetaLine(
                  label: 'المصدر',
                  value: hadith.sourceName ?? '-',
                ),
                const SizedBox(height: 4),
                _CompactMetaLine(
                  label: 'الراوي',
                  value: hadith.rawiName ?? '-',
                ),
                const SizedBox(height: 4),
                _CompactMetaLine(label: 'المحدث', value: muhaddithName ?? '-'),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      hadith.text,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isSelected ? 'تم اختيار هذا الحديث' : 'انقر لاختيار الحديث',
                  textAlign: TextAlign.right,
                  style: metaStyle?.copyWith(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactMetaLine extends StatelessWidget {
  const _CompactMetaLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return RichText(
      textAlign: TextAlign.right,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontFamily: textTheme.bodySmall?.fontFamily,
          height: 1.15,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerStateMessage extends StatelessWidget {
  const _PickerStateMessage({
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
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 42,
              color: iconColor ?? cs.primary.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                height: 1.4,
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

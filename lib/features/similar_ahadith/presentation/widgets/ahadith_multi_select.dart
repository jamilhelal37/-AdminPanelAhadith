import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ahadith/presentation/widgets/hadith_unified_card.dart';
import '../../../books/domain/models/book.dart';
import '../../../books/presentation/providers/admin_book_future_provider.dart';
import '../providers/selectable_hadiths_provider.dart';

class AhadithMultiSelect extends ConsumerStatefulWidget {
  const AhadithMultiSelect({
    super.key,
    required this.selectedHadithIds,
    required this.onSelectionChanged,
    this.excludeHadithId,
  });

  final List<String> selectedHadithIds;
  final ValueChanged<List<String>> onSelectionChanged;
  final String? excludeHadithId;

  @override
  ConsumerState<AhadithMultiSelect> createState() => _AhadithMultiSelectState();
}

class _AhadithMultiSelectState extends ConsumerState<AhadithMultiSelect> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ahadithAsync = ref.watch(
      selectableHadithsFutureProvider(_searchQuery),
    );
    final booksById = <String, Book>{
      for (final book
          in ref.watch(allBooksFutureProvider).value ?? const <Book>[])
        if (book.id != null) book.id!: book,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'ابحث داخل الأحاديث المتاحة وحدد كل الأحاديث المتشابهة.',
                style: textTheme.bodySmall?.copyWith(
                  height: 1.45,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (widget.selectedHadithIds.isNotEmpty) ...[
              const SizedBox(width: 12),
              _SelectionBadge(count: widget.selectedHadithIds.length),
            ],
          ],
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'ابحث عن الأحاديث المشابهة',
            prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
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
              borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 430,
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
          child: ahadithAsync.when(
            data: (allAhadiths) {
              final filteredAhadiths = allAhadiths.where((hadith) {
                if (widget.excludeHadithId != null &&
                    hadith.id == widget.excludeHadithId) {
                  return false;
                }

                return true;
              }).toList();

              if (filteredAhadiths.isEmpty) {
                return _SelectionStateMessage(
                  icon: _searchQuery.isEmpty
                      ? Icons.inbox_outlined
                      : Icons.search_off_rounded,
                  title: _searchQuery.isEmpty
                      ? 'لا توجد أحاديث متاحة'
                      : 'لا توجد أحاديث مطابقة',
                  description: _searchQuery.isEmpty
                      ? 'لم يتم العثور على أحاديث قابلة للاختيار في هذه اللحظة.'
                      : 'جرّب كلمات بحث أخرى أو امسح البحث لإظهار جميع الأحاديث المتاحة.',
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        'نتائج المطابقة',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${filteredAhadiths.length} نتيجة',
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
                      child: ListView.builder(
                        itemCount: filteredAhadiths.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final hadith = filteredAhadiths[index];
                          final isSelected = widget.selectedHadithIds.contains(
                            hadith.id,
                          );

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == filteredAhadiths.length - 1
                                  ? 0
                                  : 12,
                            ),
                            child: HadithUnifiedCard(
                              hadith: hadith,
                              muhaddithName:
                                  booksById[hadith.sourceId]?.muhaddithName,
                              isSelected: isSelected,
                              selectionMode: HadithCardSelectionMode.multi,
                              textMaxLength: 140,
                              onTap: () {
                                if (hadith.id == null) return;

                                final newSelection = List<String>.from(
                                  widget.selectedHadithIds,
                                );

                                if (isSelected) {
                                  newSelection.remove(hadith.id);
                                } else {
                                  newSelection.add(hadith.id!);
                                }

                                widget.onSelectionChanged(newSelection);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _SelectionStateMessage(
              icon: Icons.error_outline_rounded,
              iconColor: colorScheme.error,
              title: 'تعذر تحميل الأحاديث',
              description: error.toString(),
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectionBadge extends StatelessWidget {
  const _SelectionBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          cs.primary.withValues(alpha: 0.08),
          cs.primaryContainer.withValues(alpha: 0.4),
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.primary.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.done_all_rounded, size: 16, color: cs.primary),
          const SizedBox(width: 6),
          Text(
            '$count محدد',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionStateMessage extends StatelessWidget {
  const _SelectionStateMessage({
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
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 52,
              color: iconColor ?? cs.primary.withValues(alpha: 0.7),
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

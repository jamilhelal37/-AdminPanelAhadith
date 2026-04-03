import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/confirmation_dialog.dart';

class SearchHistorySuggestions extends StatelessWidget {
  const SearchHistorySuggestions({
    super.key,
    required this.items,
    required this.onSelect,
    required this.showRecentTitle,
    required this.onDelete,
    required this.onClearAll,
  });

  final List<String> items;
  final ValueChanged<String> onSelect;
  final bool showRecentTitle;
  final ValueChanged<String> onDelete;
  final Future<void> Function() onClearAll;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final maxListHeight = MediaQuery.sizeOf(context).height * 0.28;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.65),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    showRecentTitle
                        ? Icons.history_rounded
                        : Icons.search_rounded,
                    size: 17,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    showRecentTitle
                        ? 'آخر عمليات البحث'
                        : 'اقتراحات من سجل البحث',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
                TextButton(
                  onPressed: () => _confirmClearAll(context),
                  child: Text(
                    'مسح الكل',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxListHeight),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isLast = index == items.length - 1;

                  return InkWell(
                    onTap: () => onSelect(item),
                    borderRadius: BorderRadius.vertical(
                      bottom: isLast ? const Radius.circular(20) : Radius.zero,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: isLast
                            ? null
                            : Border(
                                bottom: BorderSide(
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.24,
                                  ),
                                ),
                              ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            showRecentTitle
                                ? Icons.schedule_rounded
                                : Icons.north_west_rounded,
                            size: 18,
                            color: colorScheme.primary.withValues(alpha: 0.85),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => onDelete(item),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClearAll(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        return ConfirmationDialog(
          title: 'مسح سجل البحث',
          content:
              'سيتم حذف جميع اقتراحات البحث المحفوظة. هل تريد المتابعة؟',
          confirmText: 'مسح الكل',
          cancelText: 'إلغاء',
          icon: Icons.delete_sweep_rounded,
          onConfirm: onClearAll,
        );
      },
    );
  }
}



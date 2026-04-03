import 'dart:math' as math;

import 'package:flutter/material.dart';

typedef AdminPagedItemsBuilder<T> =
    Widget Function(BuildContext context, List<T> pageItems);

class AdminPaginatedDataView<T> extends StatefulWidget {
  const AdminPaginatedDataView({
    super.key,
    required this.items,
    required this.stateKey,
    required this.itemBuilder,
    this.initialPageSize = 25,
    this.pageSizeOptions = const [10, 25, 50, 100],
    this.expandBody = true,
    this.horizontalInset = 10,
  });

  final List<T> items;
  final String stateKey;
  final AdminPagedItemsBuilder<T> itemBuilder;
  final int initialPageSize;
  final List<int> pageSizeOptions;
  final bool expandBody;
  final double horizontalInset;

  @override
  State<AdminPaginatedDataView<T>> createState() =>
      _AdminPaginatedDataViewState<T>();
}

class _AdminPaginatedDataViewState<T> extends State<AdminPaginatedDataView<T>> {
  late int _pageSize;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _pageSize = widget.initialPageSize;
  }

  @override
  void didUpdateWidget(covariant AdminPaginatedDataView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stateKey != oldWidget.stateKey && _page != 1) {
      setState(() {
        _page = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = widget.items.length;
    final totalPages = math.max(1, (totalCount / _pageSize).ceil());
    final safePage = _page.clamp(1, totalPages);

    if (safePage != _page) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _page = safePage;
        });
      });
    }

    final startIndex = (safePage - 1) * _pageSize;
    final endIndex = math.min(startIndex + _pageSize, totalCount);
    final pageItems = totalCount == 0
        ? List<T>.empty(growable: false)
        : widget.items.sublist(startIndex, endIndex);
    final visibleStart = totalCount == 0 ? 0 : startIndex + 1;
    final body = widget.itemBuilder(context, pageItems);

    return Column(
      children: [
        if (widget.expandBody)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.horizontalInset),
              child: body,
            ),
          )
        else
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalInset),
            child: body,
          ),
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.fromLTRB(
            widget.horizontalInset,
            0,
            widget.horizontalInset,
            10,
          ),
          child: _AdminPaginationFooter(
            totalCount: totalCount,
            visibleStart: visibleStart,
            visibleEnd: endIndex,
            currentPage: safePage,
            totalPages: totalPages,
            pageSize: _pageSize,
            pageSizeOptions: widget.pageSizeOptions,
            onPageSizeChanged: (value) {
              if (value == _pageSize) return;
              setState(() {
                _pageSize = value;
                _page = 1;
              });
            },
            onPageChanged: (page) {
              setState(() {
                _page = page;
              });
            },
          ),
        ),
      ],
    );
  }
}

class _AdminPaginationFooter extends StatelessWidget {
  const _AdminPaginationFooter({
    required this.totalCount,
    required this.visibleStart,
    required this.visibleEnd,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.pageSizeOptions,
    required this.onPageSizeChanged,
    required this.onPageChanged,
  });

  final int totalCount;
  final int visibleStart;
  final int visibleEnd;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final List<int> pageSizeOptions;
  final ValueChanged<int> onPageSizeChanged;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.24)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTight = constraints.maxWidth < 860;

          if (isTight) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: _ResultsSummary(
                    totalCount: totalCount,
                    visibleStart: visibleStart,
                    visibleEnd: visibleEnd,
                    currentPage: currentPage,
                    totalPages: totalPages,
                  ),
                ),
                const SizedBox(height: 8),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: _PageSizeControl(
                            value: pageSize,
                            options: pageSizeOptions,
                            onChanged: onPageSizeChanged,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.center,
                          child: totalPages > 1
                              ? _AdminPaginationBar(
                                  currentPage: currentPage,
                                  totalPages: totalPages,
                                  onPageChanged: onPageChanged,
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _ResultsSummary(
                      totalCount: totalCount,
                      visibleStart: visibleStart,
                      visibleEnd: visibleEnd,
                      currentPage: currentPage,
                      totalPages: totalPages,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: totalPages > 1
                        ? _AdminPaginationBar(
                            currentPage: currentPage,
                            totalPages: totalPages,
                            onPageChanged: onPageChanged,
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                SizedBox(
                  width: 190,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _PageSizeControl(
                      value: pageSize,
                      options: pageSizeOptions,
                      onChanged: onPageSizeChanged,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PageSizeControl extends StatelessWidget {
  const _PageSizeControl({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final int value;
  final List<int> options;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'لكل صفحة',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              dropdownColor: cs.surface,
              isDense: true,
              borderRadius: BorderRadius.circular(12),
              iconSize: 16,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w700,
              ),
              items: options
                  .map(
                    (size) => DropdownMenuItem<int>(
                      value: size,
                      child: Text('$size'),
                    ),
                  )
                  .toList(),
              onChanged: (next) {
                if (next == null) return;
                onChanged(next);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsSummary extends StatelessWidget {
  const _ResultsSummary({
    required this.totalCount,
    required this.visibleStart,
    required this.visibleEnd,
    required this.currentPage,
    required this.totalPages,
  });

  final int totalCount;
  final int visibleStart;
  final int visibleEnd;
  final int currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final baseStyle =
        Theme.of(context).textTheme.bodySmall ?? const TextStyle(fontSize: 12);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Text(
        'إجمالي النتائج: $totalCount • عرض $visibleStart - $visibleEnd • الصفحة $currentPage/$totalPages',
        maxLines: 1,
        style: baseStyle.copyWith(
          color: cs.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AdminPaginationBar extends StatelessWidget {
  const _AdminPaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  List<int> _visiblePages() {
    if (totalPages <= 7) {
      return List<int>.generate(totalPages, (index) => index + 1);
    }

    final start = (currentPage - 2).clamp(1, totalPages - 4);
    final end = (start + 4).clamp(1, totalPages);
    return List<int>.generate(end - start + 1, (index) => start + index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = _visiblePages();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 5,
        runSpacing: 5,
        children: [
          _PagerNavButton(
            icon: Icons.keyboard_double_arrow_right_rounded,
            tooltip: 'أول صفحة',
            enabled: currentPage > 1,
            onPressed: () => onPageChanged(1),
          ),
          _PagerNavButton(
            icon: Icons.chevron_left_rounded,
            tooltip: 'الصفحة السابقة',
            enabled: currentPage > 1,
            onPressed: () => onPageChanged(currentPage - 1),
          ),
          ...pages.map(
            (page) => _PageChip(
              label: '$page',
              active: page == currentPage,
              onTap: () => onPageChanged(page),
            ),
          ),
          _PagerNavButton(
            icon: Icons.chevron_right_rounded,
            tooltip: 'الصفحة التالية',
            enabled: currentPage < totalPages,
            onPressed: () => onPageChanged(currentPage + 1),
          ),
          _PagerNavButton(
            icon: Icons.keyboard_double_arrow_left_rounded,
            tooltip: 'آخر صفحة',
            enabled: currentPage < totalPages,
            onPressed: () => onPageChanged(totalPages),
          ),
        ],
      ),
    );
  }
}

class _PagerNavButton extends StatelessWidget {
  const _PagerNavButton({
    required this.icon,
    required this.tooltip,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(8),
        child: Opacity(
          opacity: enabled ? 1 : 0.36,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: enabled
                  ? cs.surfaceContainerLowest
                  : cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.22),
              ),
            ),
            child: Icon(
              icon,
              size: 16,
              color: enabled ? cs.primary : cs.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _PageChip extends StatelessWidget {
  const _PageChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? Color.alphaBlend(
                  cs.primary.withValues(alpha: 0.08),
                  cs.primaryContainer.withValues(alpha: 0.34),
                )
              : cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active
                ? cs.primary.withValues(alpha: 0.2)
                : cs.outlineVariant.withValues(alpha: 0.22),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: active ? FontWeight.w800 : FontWeight.w700,
            color: active ? cs.primary : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

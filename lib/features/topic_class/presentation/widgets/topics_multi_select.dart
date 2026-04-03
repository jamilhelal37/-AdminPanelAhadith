import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../topics/domain/models/topic.dart';
import '../../../topics/presentation/providers/topic_future_provider.dart';

class TopicsMultiSelect extends ConsumerStatefulWidget {
  const TopicsMultiSelect({
    super.key,
    required this.selectedTopicIds,
    required this.onSelectionChanged,
  });

  final List<String> selectedTopicIds;
  final Function(List<String>) onSelectionChanged;

  @override
  ConsumerState<TopicsMultiSelect> createState() => _TopicsMultiSelectState();
}

class _TopicsMultiSelectState extends ConsumerState<TopicsMultiSelect> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_syncSearchState);
  }

  @override
  void dispose() {
    _searchController.removeListener(_syncSearchState);
    _searchController.dispose();
    super.dispose();
  }

  void _syncSearchState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleTopic(Topic topic, bool isSelected) {
    if (topic.id == null) return;
    final current = List<String>.from(widget.selectedTopicIds);

    if (isSelected) {
      current.removeWhere((id) => id == topic.id);
    } else if (!current.contains(topic.id)) {
      current.add(topic.id!);
    }

    widget.onSelectionChanged(current);
  }

  @override
  Widget build(BuildContext context) {
    final topicsAsync = ref.watch(adminTopicsFutureProvider);
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final query = _searchController.text.trim().toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'ابحث عن موضوع',
            prefixIcon: Icon(Icons.search_rounded, color: cs.primary),
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    onPressed: _searchController.clear,
                    icon: const Icon(Icons.close_rounded),
                  )
                : null,
            filled: true,
            fillColor: cs.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: cs.primary, width: 1.6),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _TopicCountChip(
              icon: Icons.category_outlined,
              label: '${widget.selectedTopicIds.length} محدد',
              highlighted: widget.selectedTopicIds.isNotEmpty,
            ),
            if (query.isNotEmpty)
              _TopicCountChip(
                icon: Icons.filter_alt_outlined,
                label: 'تصفية: $query',
              ),
          ],
        ),
        const SizedBox(height: 14),
        topicsAsync.when(
          data: (topics) {
            final visibleTopics = query.isEmpty
                ? topics
                : topics
                      .where((t) => t.name.toLowerCase().contains(query))
                      .toList();

            if (visibleTopics.isEmpty) {
              return Container(
                height: 280,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: cs.outlineVariant.withValues(alpha: 0.24),
                  ),
                ),
                child: Text(
                  'لا توجد موضوعات مطابقة',
                  style: textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              );
            }

            return Container(
              height: 320,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.24),
                ),
              ),
              child: ListView.builder(
                itemCount: visibleTopics.length,
                itemBuilder: (context, index) {
                  final topic = visibleTopics[index];
                  final isSelected = widget.selectedTopicIds.contains(topic.id);

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == visibleTopics.length - 1 ? 0 : 8,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _toggleTopic(topic, isSelected),
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color.alphaBlend(
                                    cs.primary.withValues(alpha: 0.08),
                                    cs.primaryContainer.withValues(alpha: 0.34),
                                  )
                                : cs.surfaceContainerHighest.withValues(
                                    alpha: 0.2,
                                  ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? cs.primary.withValues(alpha: 0.26)
                                  : cs.outlineVariant.withValues(alpha: 0.22),
                            ),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: isSelected,
                                onChanged: (_) =>
                                    _toggleTopic(topic, isSelected),
                                activeColor: cs.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  topic.name,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? cs.onPrimaryContainer
                                        : cs.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const SizedBox(
            height: 280,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Container(
            height: 280,
            alignment: Alignment.center,
            child: Text(
              'تعذر تحميل الموضوعات',
              style: textTheme.bodyMedium?.copyWith(color: cs.error),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopicCountChip extends StatelessWidget {
  const _TopicCountChip({
    required this.icon,
    required this.label,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: highlighted
            ? cs.primary.withValues(alpha: 0.1)
            : cs.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: highlighted ? cs.primary : cs.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: highlighted ? cs.primary : cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

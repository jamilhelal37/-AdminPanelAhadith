import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widgets/search_field_widget.dart';
import '../providers/search_provider.dart';

class HadithSearchHeader extends ConsumerStatefulWidget {
  const HadithSearchHeader({super.key, required this.totalResults});

  final int totalResults;

  @override
  ConsumerState<HadithSearchHeader> createState() => _HadithSearchHeaderState();
}

class _HadithSearchHeaderState extends ConsumerState<HadithSearchHeader> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSearch = ref.watch(searchProvider);
    if (_controller.text != currentSearch) {
      _controller.value = _controller.value.copyWith(
        text: currentSearch,
        selection: TextSelection.collapsed(offset: currentSearch.length),
      );
    }

    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'البحث عن الحديث',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'ابحث عن الأحاديث بالنص أو الرقم أو الكلمات المفتاحية',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: SearchFieldWidget(
                controller: _controller,
                hintText: 'ابحث',
                onChanged: (value) {
                  ref.read(searchProvider.notifier).state = value;
                },
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.list_alt, size: 18, color: cs.primary),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.totalResults} ${'نتائج'}',
                    style: TextStyle(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

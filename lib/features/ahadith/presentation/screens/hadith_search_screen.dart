import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widgets/empty_state_widget.dart';
import '../providers/admin_hadith_future_provider.dart';
import '../widgets/hadith_search_header.dart';
import '../widgets/hadith_search_results_table.dart';

class HadithSearchScreen extends ConsumerWidget {
  const HadithSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ahadithAsync = ref.watch(adminHadithsFutureProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('البحث عن الحديث'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ahadithAsync.when(
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
          data: (data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HadithSearchHeader(totalResults: data.length),
                const SizedBox(height: 20),
                Expanded(
                  child: data.isEmpty
                      ? EmptyStateWidget(message: 'لا توجد نتائج')
                      : HadithSearchResultsTable(ahadith: data),
                ),
              ],
            );
          },
          error: (e, _) => EmptyStateWidget(message: 'خطأ في تحميل الأحاديث'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

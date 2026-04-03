import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/mobile_hadith_search_repository_provider.dart';
import '../../../../core/presentation/widgets/core_actions_widget.dart';
import '../../../../core/presentation/widgets/golden_drawer.dart';
import '../../../../core/presentation/widgets/golden_buttons.dart';
import '../../../../core/presentation/widgets/hadith_card_widget.dart';
import '../../../books/domain/models/book.dart';
import '../../../books/presentation/providers/admin_book_future_provider.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../../similar_ahadith/domain/models/similar_ahadith.dart';
import '../../../similar_ahadith/presentation/providers/admin_similar_ahadith_future_provider.dart';
import '../../data/repositories/hadith_repository_provider.dart';
import '../../domain/models/hadith.dart';
import '../models/search_results_args.dart';
import '../widgets/search_empty_state.dart';

final searchResultsProvider = FutureProvider.autoDispose
    .family<List<Hadith>, SearchResultsArgs>((ref, args) async {
      if (kIsWeb) {
        final repo = ref.read(hadithRepositoryProvider);
        return repo.getHadiths(
          searchQuery: args.searchQuery,
          rawiIds: args.rawiIds,
          muhaddithIds: args.muhaddithIds,
          topicIds: args.topicIds,
          bookIds: args.bookIds,
          rulingIds: args.rulingIds,
          types: args.types,
          searchMode: args.searchMode,
        );
      }

      final repo = ref.read(mobileHadithSearchRepositoryProvider);
      return repo.searchHadiths(
        searchQuery: args.searchQuery,
        rawiIds: args.rawiIds,
        muhaddithIds: args.muhaddithIds,
        topicIds: args.topicIds,
        bookIds: args.bookIds,
        rulingIds: args.rulingIds,
        types: args.types,
        searchMode: args.searchMode,
      );
    });

class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({super.key, required this.args});

  final SearchResultsArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchResultsProvider(args));

    return Scaffold(
      endDrawer: const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(args.title),
        centerTitle: true,
        actions: const [CoreActionsWidget()],
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: resultsAsync.when(
            data: (ahadith) {
              if (ahadith.isEmpty) {
                return const SearchEmptyState(
                  title: 'لم يتم العثور على نتائج',
                  subtitle: 'جرّب البحث بكلمات أخرى .',
                );
              }
              return _SearchResultsList(ahadith: ahadith);
            },
            loading: () =>
                const GoldenLoadingIndicator(message: 'جاري تحميل النتائج...'),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'حدث خطأ أثناء تحميل النتائج\n$error',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchResultsList extends ConsumerWidget {
  const _SearchResultsList({required this.ahadith});

  final List<Hadith> ahadith;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final booksAsync = ref.watch(allBooksFutureProvider);
    final similarAsync = ref.watch(adminSimilarAhadithsFutureProvider);
    final favoritesAsync = ref.watch(userFavoritesStreamProvider);

    final favoriteHadithIds = <String>{
      for (final fav in favoritesAsync.value ?? const [])
        if (fav.hadithId != null) fav.hadithId!,
    };
    final booksById = <String, Book>{
      for (final b in booksAsync.value ?? const <Book>[])
        if (b.id != null) b.id!: b,
    };
    final similarByMainId = <String, List<SimilarAhadith>>{};
    for (final item in similarAsync.value ?? const <SimilarAhadith>[]) {
      final mainHadithId = item.mainHadithId;
      if (mainHadithId == null || mainHadithId.isEmpty) continue;
      similarByMainId
          .putIfAbsent(mainHadithId, () => <SimilarAhadith>[])
          .add(item);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.14),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.format_list_numbered_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'عدد النتائج',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${ahadith.length}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.25),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(16, 12, 16, bottomInset + 16),
              itemCount: ahadith.length,
              itemBuilder: (context, index) {
                final hadith = ahadith[index];
                final muhaddithName = booksById[hadith.sourceId]?.muhaddithName;
                final similarAhadiths = hadith.id == null
                    ? const <SimilarAhadith>[]
                    : (similarByMainId[hadith.id!] ?? const <SimilarAhadith>[]);

                return HadithCard(
                  hadith: hadith,
                  serialNumber: index + 1,
                  muhaddithName: muhaddithName,
                  similarAhadiths: similarAhadiths,
                  isFavorite:
                      hadith.id != null &&
                      favoriteHadithIds.contains(hadith.id),
                  onInfo: () {
                    context.pushNamed('hadith-detail', extra: hadith);
                  },
                  onTap: () {
                    context.pushNamed('hadith-detail', extra: hadith);
                  },
                  onFavorite: () async {
                    final hadithId = hadith.id;
                    if (hadithId == null) return;

                    final isFav = favoriteHadithIds.contains(hadithId);
                    try {
                      await ref
                          .read(toggleFavoriteProvider.notifier)
                          .toggleFavorite(hadithId, isFav);

                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFav
                                ? 'تمت إزالة الحديث من المفضلة'
                                : 'تمت إضافة الحديث إلى المفضلة',
                          ),
                        ),
                      );
                    } catch (_) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تعذر تحديث المفضلة، حاول مرة أخرى'),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

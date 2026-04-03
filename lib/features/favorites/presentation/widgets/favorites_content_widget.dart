import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/hadith_card_widget.dart';
import '../../../../core/presentation/widgets/unified_state_widgets.dart';
import '../../../../router.dart';
import '../../../ahadith/domain/models/hadith.dart';
import '../../../books/domain/models/book.dart';
import '../../../similar_ahadith/domain/models/similar_ahadith.dart';
import '../providers/favorites_provider.dart';
import 'favorites_empty_state.dart';

class FavoritesContent extends ConsumerWidget {
  const FavoritesContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(userFavoritesStreamProvider);
    final hadithCatalogAsync = ref.watch(favoritesHadithCatalogProvider);
    final booksCatalogAsync = ref.watch(favoritesBooksCatalogProvider);
    final similarCatalogAsync = ref.watch(favoritesSimilarCatalogProvider);

    final favorites = favoritesAsync.valueOrNull;
    if (favorites == null) {
      return favoritesAsync.when(
        loading: () =>
            const UnifiedLoadingState(message: "جارٍ تحميل المفضلة..."),
        error: (error, _) => UnifiedErrorState(
          title: "تعذر تحميل المفضلة",
          message: error.toString(),
        ),
        data: (_) => const SizedBox.shrink(),
      );
    }

    if (favorites.isEmpty) {
      return const FavoritesEmptyState(
        title: "لا توجد أحاديث في المفضلة",
        subtitle:
            "أضف الأحاديث التي تريد الرجوع إليها لاحقًا لتجدها هنا بسرعة.",
      );
    }

    final hadithCatalog = hadithCatalogAsync.valueOrNull ?? const <Hadith>[];
    if (hadithCatalog.isEmpty) {
      if (hadithCatalogAsync.isLoading) {
        return const UnifiedLoadingState(
          message: "جارٍ تحميل أحاديث المفضلة...",
        );
      }

      if (hadithCatalogAsync.hasError) {
        return UnifiedErrorState(
          title: "تعذر تحميل المفضلة",
          message: hadithCatalogAsync.error.toString(),
        );
      }
    }

    final booksCatalog = booksCatalogAsync.valueOrNull ?? const <Book>[];
    final similarCatalog =
        similarCatalogAsync.valueOrNull ?? const <SimilarAhadith>[];

    final booksById = <String, Book>{
      for (final book in booksCatalog)
        if (book.id != null) book.id!: book,
    };
    final ahadithById = <String, Hadith>{
      for (final hadith in hadithCatalog)
        if (hadith.id != null) hadith.id!: hadith,
    };
    final similarByMainId = <String, List<SimilarAhadith>>{};
    for (final similar in similarCatalog) {
      final mainId = similar.mainHadithId;
      if (mainId == null || mainId.isEmpty) continue;
      similarByMainId
          .putIfAbsent(mainId, () => <SimilarAhadith>[])
          .add(similar);
    }

    final visibleHadiths = favorites
        .map((favorite) => favorite.hadithId)
        .whereType<String>()
        .where((id) => id.trim().isNotEmpty)
        .map((id) => ahadithById[id])
        .whereType<Hadith>()
        .toList();

    if (visibleHadiths.isEmpty) {
      if (hadithCatalogAsync.isLoading) {
        return const UnifiedLoadingState(
          message: "جارٍ تحديث أحاديث المفضلة...",
        );
      }

      return const FavoritesEmptyState(
        title: "لا توجد أحاديث متاحة للعرض",
        subtitle:
            "يبدو أن العناصر المحفوظة لم تعد موجودة أو لم يتم تحميلها بعد.",
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: visibleHadiths.length,
        itemBuilder: (context, index) {
          final hadith = visibleHadiths[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: HadithCard(
              hadith: hadith,
              serialNumber: index + 1,
              muhaddithName: booksById[hadith.sourceId]?.muhaddithName,
              similarAhadiths:
                  similarByMainId[hadith.id] ?? const <SimilarAhadith>[],
              isFavorite: true,
              onTap: () {
                context.pushNamed(AppRouteNames.hadithDetail, extra: hadith);
              },
              onInfo: () {
                context.pushNamed(AppRouteNames.hadithDetail, extra: hadith);
              },
              onFavorite: () async {
                final hadithId = hadith.id;
                if (hadithId == null) return;

                try {
                  await ref
                      .read(toggleFavoriteProvider.notifier)
                      .toggleFavorite(hadithId, true);

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تمت إزالة الحديث من المفضلة"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تعذر تحديث المفضلة، حاول مرة أخرى"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}



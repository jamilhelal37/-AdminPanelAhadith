import 'package:ahadith/core/presentation/widgets/core_actions_widget.dart';
import 'package:ahadith/core/presentation/widgets/golden_drawer.dart';
import 'package:ahadith/core/presentation/widgets/hadith_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../ahadith/domain/models/hadith.dart';
import '../../../ahadith/presentation/providers/hadith_by_id_provider.dart';
import '../../../books/domain/models/book.dart';
import '../../../books/presentation/providers/admin_book_future_provider.dart';
import '../../../favorites/domain/models/favorite.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../domain/models/similar_ahadith.dart';

class SimilarAhadithScreen extends ConsumerWidget {
  final Hadith mainHadith;
  final List<SimilarAhadith> similarAhadiths;

  const SimilarAhadithScreen({
    super.key,
    required this.mainHadith,
    required this.similarAhadiths,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(userFavoritesStreamProvider);
    final booksById = _booksById(ref.watch(allBooksFutureProvider).valueOrNull);
    final favoriteHadithIds = _favoriteHadithIds(favoritesAsync.valueOrNull);

    return Scaffold(
      endDrawer: const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: const [CoreActionsWidget()],
        title: const Text(
          'الأحاديث المشابهة',
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader(
              context,
              'الحديث الأساسي',
            ),
            const SizedBox(height: 12),
            HadithCard(
              hadith: mainHadith,
              muhaddithName: booksById[mainHadith.sourceId]?.muhaddithName,
              similarAhadiths: const <SimilarAhadith>[],
              isFavorite:
                  mainHadith.id != null &&
                  favoriteHadithIds.contains(mainHadith.id),
              onTap: () =>
                  context.pushNamed('hadith-detail', extra: mainHadith),
              onInfo: () =>
                  context.pushNamed('hadith-detail', extra: mainHadith),
              onFavorite: mainHadith.id == null
                  ? null
                  : () {
                      _toggleFavorite(
                        context,
                        ref,
                        hadithId: mainHadith.id!,
                        isFavorite: favoriteHadithIds.contains(mainHadith.id),
                      );
                    },
            ),
            const SizedBox(height: 20),
            _buildSectionHeader(
              context,
              'أحاديث مشابهة',
            ),
            const SizedBox(height: 12),
            if (similarAhadiths.isEmpty)
              _buildEmptyState(context)
            else
              ...similarAhadiths.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildSimilarHadithCard(
                    context,
                    ref,
                    item: entry.value,
                    index: entry.key,
                    booksById: booksById,
                    favoriteHadithIds: favoriteHadithIds,
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.8),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Theme.of(context).colorScheme.surface, border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            size: 40,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد أحاديث مشابهة لهذا الحديث',
            style: TextStyle(fontSize: 16, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Set<String> _favoriteHadithIds(List<Favorite>? favorites) {
    if (favorites == null) return <String>{};
    return favorites
        .map((favorite) => favorite.hadithId)
        .whereType<String>()
        .toSet();
  }

  Map<String, Book> _booksById(List<Book>? books) {
    if (books == null) return <String, Book>{};
    return {
      for (final book in books)
        if (book.id != null) book.id!: book,
    };
  }

  Widget _buildSimilarHadithCard(
    BuildContext context,
    WidgetRef ref, {
    required SimilarAhadith item,
    required int index,
    required Map<String, Book> booksById,
    required Set<String> favoriteHadithIds,
  }) {
    final simHadithId = item.simHadithId;
    if (simHadithId == null || simHadithId.isEmpty) {
      final fallbackHadith = _mapSimilarToHadith(item);
      return _buildHadithCard(
        context,
        ref,
        hadith: fallbackHadith,
        serialNumber: index + 1,
        booksById: booksById,
        favoriteHadithIds: favoriteHadithIds,
      );
    }

    final hadithAsync = ref.watch(hadithByIdProvider(simHadithId));
    return hadithAsync.when(
      data: (hadith) {
        return _buildHadithCard(
          context,
          ref,
          hadith: hadith,
          serialNumber: index + 1,
          booksById: booksById,
          favoriteHadithIds: favoriteHadithIds,
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Theme.of(context).colorScheme.surface, border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) {
        final fallbackHadith = _mapSimilarToHadith(item);
        return _buildHadithCard(
          context,
          ref,
          hadith: fallbackHadith,
          serialNumber: index + 1,
          booksById: booksById,
          favoriteHadithIds: favoriteHadithIds,
        );
      },
    );
  }

  Widget _buildHadithCard(
    BuildContext context,
    WidgetRef ref, {
    required Hadith hadith,
    required int? serialNumber,
    required Map<String, Book> booksById,
    required Set<String> favoriteHadithIds,
  }) {
    final isFavorite =
        hadith.id != null && favoriteHadithIds.contains(hadith.id);

    return HadithCard(
      hadith: hadith,
      serialNumber: serialNumber,
      muhaddithName: booksById[hadith.sourceId]?.muhaddithName,
      similarAhadiths: const <SimilarAhadith>[],
      isFavorite: isFavorite,
      onTap: () => context.pushNamed('hadith-detail', extra: hadith),
      onInfo: () => context.pushNamed('hadith-detail', extra: hadith),
      onFavorite: hadith.id == null
          ? null
          : () {
              _toggleFavorite(
                context,
                ref,
                hadithId: hadith.id!,
                isFavorite: isFavorite,
              );
            },
    );
  }

  Hadith _mapSimilarToHadith(SimilarAhadith item) {
    return Hadith(
      id: item.simHadithId,
      subValid: null,
      subValidText: null,
      explainingId: null,
      explainingText: null,
      type: mainHadith.type,
      text: item.simHadithText?.trim().isNotEmpty == true
          ? item.simHadithText!.trim()
          : '-',
      normalText: null,
      searchText: null,
      hadithNumber: item.simHadithNumber ?? 0,
      muhaddithRulingId: null,
      muhaddithRulingName: null,
      finalRulingId: null,
      finalRulingName: null,
      rawiId: null,
      rawiName: null,
      sourceId: null,
      sourceName: item.simBookName,
      sanad: null,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
      relatedTopics: null,
    );
  }

  Future<void> _toggleFavorite(
    BuildContext context,
    WidgetRef ref, {
    required String hadithId,
    required bool isFavorite,
  }) async {
    await ref
        .read(toggleFavoriteProvider.notifier)
        .toggleFavorite(hadithId, isFavorite);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? 'تمت إزالة الحديث من المفضلة'
              : 'تمت إضافة الحديث إلى المفضلة',
        ),
      ),
    );
  }
}




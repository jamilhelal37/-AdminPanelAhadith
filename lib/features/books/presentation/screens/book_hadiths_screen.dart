import 'package:flutter/material.dart';
import 'package:ahadith/core/presentation/widgets/core_actions_widget.dart';
import 'package:ahadith/core/presentation/widgets/golden_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/hadith_card_widget.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../providers/book_hadiths_provider.dart';
import '../../domain/models/book.dart';

/// Book Hadiths Screen - ??? ???? ?????? ???? ????
class BookHadithsScreen extends ConsumerWidget {
  final Book book;

  const BookHadithsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookId = book.id;
    if (bookId == null || bookId.isEmpty) {
      return Scaffold(
        endDrawer: const GoldenAppDrawer(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          actions: const [CoreActionsWidget()],
          title: Text(book.name),
          centerTitle: true,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Text(
              'بيانات الكتاب غير صالحة',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ),
      );
    }

    final hadithsAsync = ref.watch(bookHadithsProvider(bookId));
    final favoritesAsync = ref.watch(userFavoritesStreamProvider);
    final favoriteIds = <String>{
      for (final fav in favoritesAsync.value ?? const []) fav.hadithId,
    };

    return Scaffold(
      endDrawer: const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: const [CoreActionsWidget()],
        title: Text(book.name),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: hadithsAsync.when(
          data: (bookHadiths) {
            if (bookHadiths.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد نتائج',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookHadiths.length,
              itemBuilder: (context, index) {
                final hadith = bookHadiths[index];
                final hadithId = hadith.id;

                return HadithCard(
                  hadith: hadith,
                  serialNumber: hadith.hadithNumber,
                  muhaddithName: book.muhaddithName,
                  isFavorite:
                      hadithId != null && favoriteIds.contains(hadithId),
                  onTap: () {
                    context.pushNamed('hadith-detail', extra: hadith);
                  },
                  onInfo: () {
                    context.pushNamed('hadith-detail', extra: hadith);
                  },
                  onFavorite: () async {
                    if (hadithId == null) return;
                    final isFav = favoriteIds.contains(hadithId);

                    await ref
                        .read(toggleFavoriteProvider.notifier)
                        .toggleFavorite(hadithId, isFav);

                    if (!context.mounted) return;
                    final toggleState = ref.read(toggleFavoriteProvider);
                    if (toggleState.hasError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'تعذر تحديث المفضلة',
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFav
                              ? 'تمت إزالة الحديث من المفضلة'
                              : 'تمت إضافة الحديث إلى المفضلة',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          error: (error, stack) => Center(
            child: Text(
              'خطأ في تحميل أحاديث الكتاب',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}



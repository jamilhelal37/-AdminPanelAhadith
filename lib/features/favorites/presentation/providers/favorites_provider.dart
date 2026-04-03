import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ahadith/data/repositories/hadith_repository_provider.dart';
import '../../../ahadith/domain/models/hadith.dart';
import '../../../auth/presentation/providers/auth_notifier_provider.dart';
import '../../../books/data/repositories/book_repository_provider.dart';
import '../../../books/domain/models/book.dart';
import '../../../similar_ahadith/data/repositories/similar_ahadith_repositories_provider.dart';
import '../../../similar_ahadith/domain/models/similar_ahadith.dart';
import '../../data/repositories/favorites_repository_provider.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../domain/models/favorite.dart';

/// مزود التدفق للمفضلة: المصدر المباشر للحالة في الواجهة.
final userFavoritesStreamProvider = StreamProvider<List<Favorite>>((ref) {
  final userId = ref.watch(authNotifierProvider).valueOrNull?.id;
  if (userId == null || userId.isEmpty) {
    return Stream.value(const <Favorite>[]);
  }

  final repository = ref.read(favoritesRepositoryProvider);
  return repository.getUserFavoritesStream();
});

/// مزود بيانات الأحاديث الخاصة بالمفضلة (يحافظ على الحالة بين التنقلات).
final favoritesHadithCatalogProvider = FutureProvider<List<Hadith>>((
  ref,
) async {
  final repository = ref.read(hadithRepositoryProvider);
  return repository.getHadiths();
});

/// مزود بيانات الكتب الخاصة بالمفضلة.
final favoritesBooksCatalogProvider = FutureProvider<List<Book>>((ref) async {
  final repository = ref.read(bookRepositoryProvider);
  return repository.getBooks(null);
});

/// مزود بيانات الأحاديث المشابهة الخاصة بالمفضلة.
final favoritesSimilarCatalogProvider = FutureProvider<List<SimilarAhadith>>((
  ref,
) async {
  final repository = ref.read(similarAhadithRepositoryProvider);
  return repository.getSimilarAhadiths(null);
});

/// مزود التحقق من كون الحديث في المفضلة من التدفق المباشر.
final isFavoriteProvider = Provider.family<AsyncValue<bool>, String>((
  ref,
  hadithId,
) {
  final favoritesAsync = ref.watch(userFavoritesStreamProvider);
  return favoritesAsync.whenData((favorites) {
    return favorites.any((favorite) => favorite.hadithId == hadithId);
  });
});

/// مزود إضافة أو حذف الحديث من المفضلة
final toggleFavoriteProvider =
    StateNotifierProvider<ToggleFavoriteNotifier, AsyncValue<void>>((ref) {
      final repository = ref.read(favoritesRepositoryProvider);
      return ToggleFavoriteNotifier(ref, repository);
    });

/// Notifier لإدارة عملية الإضافة والحذف من المفضلة
class ToggleFavoriteNotifier extends StateNotifier<AsyncValue<void>> {
  ToggleFavoriteNotifier(this._ref, this._repository)
    : super(const AsyncValue.data(null));

  final Ref _ref;
  final FavoritesRepository _repository;

  /// أضف أو احذف حديثاً من المفضلة
  Future<void> toggleFavorite(String hadithId, bool isFavorite) async {
    state = const AsyncValue.loading();

    Future<void> refreshLocalState() async {
      _ref.invalidate(userFavoritesStreamProvider);
      _ref.invalidate(isFavoriteProvider(hadithId));
    }

    try {
      if (isFavorite) {
        await _repository.removeFavorite(hadithId);
      } else {
        await _repository.addFavorite(hadithId);
      }

      await refreshLocalState();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

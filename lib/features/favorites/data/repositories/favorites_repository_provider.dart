import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'favorites_repository.dart';

/// مزود مستودع المفضلة
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesSupabaseRepository();
});

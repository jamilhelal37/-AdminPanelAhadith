import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'favorites_repository.dart';


final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesSupabaseRepository();
});

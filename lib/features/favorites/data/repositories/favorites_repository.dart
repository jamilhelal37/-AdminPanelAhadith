import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../application/favorites_cache.dart';
import '../../domain/models/favorite.dart' show Favorite;

abstract class FavoritesRepository {
  Future<List<Favorite>> getUserFavorites();
  Future<List<Favorite>> getCachedUserFavorites();
  Future<bool> isFavorite(String hadithId);
  Future<void> addFavorite(String hadithId);
  Future<void> removeFavorite(String hadithId);
  Future<void> syncPendingFavorites();
  Stream<List<Favorite>> getUserFavoritesStream();
}

class FavoritesSupabaseRepository implements FavoritesRepository {
  final _client = Supabase.instance.client;

  Favorite _favoriteFromMap(Map<String, dynamic> item) {
    return Favorite.fromJson({
      ...item,
      'created_at': item['created_at']?.toString() ?? '',
      'updated_at': item['updated_at']?.toString() ?? '',
    });
  }

  String? get _currentUserIdOrNull => _client.auth.currentUser?.id;

  String _requiredUserId({required String operation}) {
    final userId = _currentUserIdOrNull;
    if (userId == null || userId.isEmpty) {
      throw AppFailure.unauthorized(
        'يجب تسجيل الدخول أولاً لإدارة المفضلة.',
        operation: operation,
      );
    }
    return userId;
  }

  String _nowIso() => DateTime.now().toIso8601String();

  Future<List<Favorite>> _fetchRemoteFavorites(String userId) async {
    final response = await _client
        .from('favorite')
        .select()
        .eq('user', userId)
        .order('created_at', ascending: false);

    return (response as List<dynamic>)
        .map((item) => _favoriteFromMap(item as Map<String, dynamic>))
        .toList();
  }

  Stream<List<Favorite>> _remoteFavoritesStream(String userId) {
    return _client
        .from('favorite')
        .stream(primaryKey: ['id'])
        .eq('user', userId)
        .order('created_at', ascending: false)
        .map(
          (rows) => rows
              .map((row) => _favoriteFromMap(Map<String, dynamic>.from(row)))
              .toList(),
        );
  }

  bool _shouldQueueForRetry(Object error) {
    if (error is AppFailure) {
      if (error.type == FailureType.unauthorized ||
          error.type == FailureType.validation) {
        return false;
      }
      return true;
    }

    
    if (error is PostgrestException) {
      return true;
    }

    return true;
  }

  Future<void> _addFavoriteRemotely(String userId, String hadithId) async {
    try {
      final exists = await _client
          .from('favorite')
          .select('id')
          .eq('user', userId)
          .eq('hadith', hadithId)
          .limit(1);

      if ((exists as List).isNotEmpty) {
        return;
      }

      await _client.from('favorite').insert({
        'user': userId,
        'hadith': hadithId,
      });
    } catch (error) {
      if (error is AppFailure) rethrow;
      throw AppFailure.storage(
        'تعذر إضافة الحديث إلى المفضلة الآن.',
        operation: 'favorites.add.remote',
        cause: error,
      );
    }
  }

  Future<void> _removeFavoriteRemotely(String userId, String hadithId) async {
    try {
      await _client
          .from('favorite')
          .delete()
          .eq('user', userId)
          .eq('hadith', hadithId);
    } catch (error) {
      if (error is AppFailure) rethrow;
      throw AppFailure.storage(
        'تعذر حذف الحديث من المفضلة الآن.',
        operation: 'favorites.remove.remote',
        cause: error,
      );
    }
  }

  Future<void> _syncSingleOperation(
    String userId,
    FavoriteSyncOperation operation,
  ) async {
    try {
      if (operation.action == FavoriteSyncAction.add) {
        await _addFavoriteRemotely(userId, operation.hadithId);
      } else {
        await _removeFavoriteRemotely(userId, operation.hadithId);
      }
    } catch (error) {
      if (_shouldQueueForRetry(error)) {
        await FavoritesCache.enqueuePendingOperation(userId, operation);
        return;
      }
      rethrow;
    }
  }

  void _scheduleSync(String userId, FavoriteSyncOperation operation) {
    unawaited(
      _syncSingleOperation(userId, operation).catchError((_) {
        
      }),
    );
  }

  @override
  Future<void> syncPendingFavorites() async {
    final userId = _currentUserIdOrNull;
    if (userId == null || userId.isEmpty) return;

    final pending = await FavoritesCache.loadPendingOperations(userId);
    if (pending.isEmpty) return;

    final remaining = <FavoriteSyncOperation>[];
    for (final operation in pending) {
      try {
        if (operation.action == FavoriteSyncAction.add) {
          await _addFavoriteRemotely(userId, operation.hadithId);
        } else {
          await _removeFavoriteRemotely(userId, operation.hadithId);
        }
      } catch (error) {
        if (_shouldQueueForRetry(error)) {
          remaining.add(operation);
        } else {
          rethrow;
        }
      }
    }

    if (remaining.isEmpty) {
      await FavoritesCache.clearPendingOperations(userId);
      return;
    }

    await FavoritesCache.savePendingOperations(userId, remaining);
  }

  @override
  Future<List<Favorite>> getUserFavorites() async {
    final userId = _currentUserIdOrNull;
    if (userId == null || userId.isEmpty) return const <Favorite>[];

    final cached = await FavoritesCache.loadFavorites(userId);
    if (cached.isNotEmpty) {
      return cached;
    }

    try {
      final remote = await _fetchRemoteFavorites(userId);
      await FavoritesCache.saveFavorites(userId, remote);
      return remote;
    } catch (_) {
      return cached;
    }
  }

  @override
  Future<List<Favorite>> getCachedUserFavorites() async {
    final userId = _currentUserIdOrNull;
    if (userId == null || userId.isEmpty) return const <Favorite>[];
    return FavoritesCache.loadFavorites(userId);
  }

  @override
  Future<bool> isFavorite(String hadithId) async {
    final userId = _currentUserIdOrNull;
    if (userId == null || userId.isEmpty) return false;

    final favorites = await FavoritesCache.loadFavorites(userId);
    return favorites.any((favorite) => favorite.hadithId == hadithId);
  }

  @override
  Future<void> addFavorite(String hadithId) async {
    final userId = _requiredUserId(operation: 'favorites.add');
    await FavoritesCache.addFavorite(userId, hadithId);

    _scheduleSync(
      userId,
      FavoriteSyncOperation(
        hadithId: hadithId,
        action: FavoriteSyncAction.add,
        createdAt: _nowIso(),
      ),
    );
  }

  @override
  Future<void> removeFavorite(String hadithId) async {
    final userId = _requiredUserId(operation: 'favorites.remove');
    await FavoritesCache.removeFavorite(userId, hadithId);

    _scheduleSync(
      userId,
      FavoriteSyncOperation(
        hadithId: hadithId,
        action: FavoriteSyncAction.remove,
        createdAt: _nowIso(),
      ),
    );
  }

  @override
  Stream<List<Favorite>> getUserFavoritesStream() async* {
    final userId = _currentUserIdOrNull;
    if (userId == null || userId.isEmpty) {
      yield const <Favorite>[];
      return;
    }

    yield await FavoritesCache.loadFavorites(userId);

    while (true) {
      try {
        await syncPendingFavorites();

        await for (final favorites in _remoteFavoritesStream(userId)) {
          await FavoritesCache.saveFavorites(userId, favorites);
          yield favorites;
        }
      } catch (_) {
        yield await FavoritesCache.loadFavorites(userId);
        await Future<void>.delayed(const Duration(seconds: 3));
      }
    }
  }
}

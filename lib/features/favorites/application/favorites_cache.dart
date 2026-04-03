import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/favorite.dart';

enum FavoriteSyncAction { add, remove }

class FavoriteSyncOperation {
  const FavoriteSyncOperation({
    required this.hadithId,
    required this.action,
    required this.createdAt,
  });

  final String hadithId;
  final FavoriteSyncAction action;
  final String createdAt;

  factory FavoriteSyncOperation.fromJson(Map<String, dynamic> json) {
    final actionRaw = json['action']?.toString();
    final action = actionRaw == 'remove'
        ? FavoriteSyncAction.remove
        : FavoriteSyncAction.add;

    return FavoriteSyncOperation(
      hadithId: json['hadith_id']?.toString() ?? '',
      action: action,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hadith_id': hadithId,
      'action': action.name,
      'created_at': createdAt,
    };
  }
}

class FavoritesCache {
  FavoritesCache._();

  static const String _favoritesPrefix = 'user_favorites_cache_';
  static const String _pendingPrefix = 'user_favorites_pending_sync_';
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static Future<List<Favorite>> loadFavorites(String userId) async {
    final raw = await _prefs.getString(_key(userId));
    if (raw == null || raw.trim().isEmpty) {
      return const <Favorite>[];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const <Favorite>[];
      }

      return decoded
          .whereType<Map>()
          .map((item) => Favorite.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      return const <Favorite>[];
    }
  }

  static Future<void> saveFavorites(
    String userId,
    List<Favorite> favorites,
  ) async {
    await _prefs.setString(
      _key(userId),
      jsonEncode(favorites.map((favorite) => favorite.toJson()).toList()),
    );
  }

  static Future<bool> hasFavorites(String userId) async {
    return await _prefs.getString(_key(userId)) != null;
  }

  static Future<void> clearFavorites(String userId) async {
    await _prefs.remove(_key(userId));
  }

  static Future<void> addFavorite(String userId, String hadithId) async {
    final current = await loadFavorites(userId);
    final exists = current.any((favorite) => favorite.hadithId == hadithId);
    if (exists) return;

    final now = DateTime.now().toIso8601String();
    final updated = <Favorite>[
      Favorite(
        userId: userId,
        hadithId: hadithId,
        createdAt: now,
        updatedAt: now,
      ),
      ...current,
    ];
    await saveFavorites(userId, updated);
  }

  static Future<void> removeFavorite(String userId, String hadithId) async {
    final current = await loadFavorites(userId);
    final updated = current
        .where((favorite) => favorite.hadithId != hadithId)
        .toList();
    await saveFavorites(userId, updated);
  }

  static Future<List<FavoriteSyncOperation>> loadPendingOperations(
    String userId,
  ) async {
    final raw = await _prefs.getString(_pendingKey(userId));
    if (raw == null || raw.trim().isEmpty) {
      return const <FavoriteSyncOperation>[];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const <FavoriteSyncOperation>[];
      }

      return decoded
          .whereType<Map>()
          .map(
            (item) =>
                FavoriteSyncOperation.fromJson(Map<String, dynamic>.from(item)),
          )
          .where((op) => op.hadithId.trim().isNotEmpty)
          .toList();
    } catch (_) {
      return const <FavoriteSyncOperation>[];
    }
  }

  static Future<void> savePendingOperations(
    String userId,
    List<FavoriteSyncOperation> operations,
  ) async {
    await _prefs.setString(
      _pendingKey(userId),
      jsonEncode(operations.map((operation) => operation.toJson()).toList()),
    );
  }

  static Future<void> enqueuePendingOperation(
    String userId,
    FavoriteSyncOperation operation,
  ) async {
    final current = await loadPendingOperations(userId);
    final deduped = current
        .where((item) => item.hadithId != operation.hadithId)
        .toList();
    deduped.add(operation);
    await savePendingOperations(userId, deduped);
  }

  static Future<void> clearPendingOperations(String userId) async {
    await _prefs.remove(_pendingKey(userId));
  }

  static String _key(String userId) => '$_favoritesPrefix$userId';

  static String _pendingKey(String userId) => '$_pendingPrefix$userId';
}

import 'package:supabase_flutter/supabase_flutter.dart';

class SearchHistoryRepository {
  SearchHistoryRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  static const String _table = 'search_history';

  String? get _userId => _client.auth.currentUser?.id;

  Future<List<String>> getSuggestions({
    required String query,
    required bool isHadith,
    int limit = 5,
  }) async {
    final userId = _userId;
    if (userId == null) return const [];

    final trimmed = query.trim();
    final effectiveLimit = limit < 1 ? 1 : limit;

    dynamic request = _client
        .from(_table)
        .select('id, search_text, updated_at')
        .eq('user', userId)
        .eq('ishadith', isHadith);

    if (trimmed.isNotEmpty) {
      request = request.ilike('search_text', '%$trimmed%');
    }

    final response = await request
        .order('updated_at', ascending: false)
        .limit(trimmed.isEmpty ? effectiveLimit : effectiveLimit * 3);

    final unique = <String>[];
    final seen = <String>{};

    for (final row in (response as List)) {
      final value = (row['search_text'] as String? ?? '').trim();
      if (value.isEmpty) continue;
      final key = value.toLowerCase();
      if (seen.add(key)) {
        unique.add(value);
      }
      if (unique.length >= effectiveLimit) break;
    }

    return unique;
  }

  Future<void> saveQuery({
    required String query,
    required bool isHadith,
  }) async {
    final userId = _userId;
    final trimmed = query.trim();

    if (userId == null || trimmed.isEmpty) return;

    String normalize(String value) => value.trim().toLowerCase();

    final existing = await _client
        .from(_table)
        .select('id, search_text')
        .eq('user', userId)
        .eq('ishadith', isHadith)
        .order('updated_at', ascending: false)
        .limit(50);

    final now = DateTime.now().toUtc().toIso8601String();
    final rows = (existing as List)
        .where(
          (row) =>
              normalize(row['search_text'] as String? ?? '') ==
              normalize(trimmed),
        )
        .toList();

    if (rows.isEmpty) {
      await _client.from(_table).insert({
        'user': userId,
        'search_text': trimmed,
        'ishadith': isHadith,
      });
      return;
    }

    final primaryId = rows.first['id'] as String?;
    if (primaryId != null && primaryId.isNotEmpty) {
      await _client
          .from(_table)
          .update({'updated_at': now})
          .eq('id', primaryId);
    }

    if (rows.length > 1) {
      final duplicateIds = rows
          .skip(1)
          .map((row) => row['id'] as String?)
          .whereType<String>()
          .toList();

      if (duplicateIds.isNotEmpty) {
        await _client.from(_table).delete().inFilter('id', duplicateIds);
      }
    }
  }

  Future<void> deleteQuery({
    required String query,
    required bool isHadith,
  }) async {
    final userId = _userId;
    final trimmed = query.trim();

    if (userId == null || trimmed.isEmpty) return;

    await _client
        .from(_table)
        .delete()
        .eq('user', userId)
        .eq('ishadith', isHadith)
        .eq('search_text', trimmed);
  }

  Future<void> clearAll({required bool isHadith}) async {
    final userId = _userId;
    if (userId == null) return;

    await _client
        .from(_table)
        .delete()
        .eq('user', userId)
        .eq('ishadith', isHadith);
  }
}

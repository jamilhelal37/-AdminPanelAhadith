import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/models/fake_ahadith.dart';
import '../repositories/fakeahadith_repository.dart';

class FakeAhadithSupabaseDatasource implements FakeAhadithRepository {
  final _client = Supabase.instance.client;
  static const String _table = 'fake_ahadith';
  static const String _ahadithTable = 'ahadith';
  static const int _pageSize = 1000;

  Future<List<String>> _searchFakeAhadithIds(String query) async {
    final matchedIds = <String>[];
    final seenIds = <String>{};
    var offset = 0;

    while (true) {
      final response = await _client.rpc(
        'search_fake_ahadith_or_words',
        params: {'p_query': query, 'p_limit': _pageSize, 'p_offset': offset},
      );

      final batch = (response as List)
          .map((row) => row['id']?.toString())
          .whereType<String>()
          .toList();

      if (batch.isEmpty) {
        break;
      }

      for (final id in batch) {
        if (seenIds.add(id)) {
          matchedIds.add(id);
        }
      }

      offset += batch.length;
    }

    return matchedIds;
  }

  Future<List<Map<String, dynamic>>> _fetchFakeAhadithRowsByIds(
    List<String> ids,
  ) async {
    if (ids.isEmpty) return const [];

    final rows = <Map<String, dynamic>>[];
    for (var start = 0; start < ids.length; start += _pageSize) {
      final end = (start + _pageSize > ids.length)
          ? ids.length
          : start + _pageSize;
      final chunk = ids.sublist(start, end);

      final response = await _client
          .from(_table)
          .select()
          .inFilter('id', chunk);
      rows.addAll((response as List).map((row) => row as Map<String, dynamic>));
    }

    rows.sort((a, b) {
      final aDate = DateTime.tryParse(a['created_at']?.toString() ?? '');
      final bDate = DateTime.tryParse(b['created_at']?.toString() ?? '');
      if (aDate != null && bDate != null) {
        return bDate.compareTo(aDate);
      }
      return (b['created_at']?.toString() ?? '').compareTo(
        a['created_at']?.toString() ?? '',
      );
    });

    return rows;
  }

  Future<List<Map<String, dynamic>>> _fetchAllFakeAhadithRows() async {
    final rows = <Map<String, dynamic>>[];
    var offset = 0;

    while (true) {
      var query = _client.from(_table).select();

      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + _pageSize - 1);

      final batch = (response as List)
          .map((row) => row as Map<String, dynamic>)
          .toList();

      if (batch.isEmpty) {
        break;
      }

      rows.addAll(batch);
      offset += batch.length;
    }

    return rows;
  }

  @override
  Future<List<FakeAhadith>> getFakeAhadiths(String? searchQuery) async {
    try {
      final trimmedQuery = searchQuery?.trim();

      final response = (trimmedQuery == null || trimmedQuery.isEmpty)
          ? await _fetchAllFakeAhadithRows()
          : await () async {
              final matchedIds = await _searchFakeAhadithIds(trimmedQuery);
              if (matchedIds.isEmpty) {
                return <Map<String, dynamic>>[];
              }
              return _fetchFakeAhadithRowsByIds(matchedIds);
            }();

      final fakeAhadiths = response.map(FakeAhadith.fromJson).toList();
      return _enrichSubValidTexts(fakeAhadiths);
    } catch (error) {
      throw AppFailure.network(
        'تعذر تحميل الأحاديث المنتشرة التي لا تصح الآن.',
        operation: 'fake_ahadith.list',
        cause: error,
      );
    }
  }

  @override
  Future<FakeAhadith?> getFakeAhadithById(String id) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      final fakeAhadith = FakeAhadith.fromJson(response);
      final enriched = await _enrichSubValidTexts([fakeAhadith]);
      return enriched.isEmpty ? fakeAhadith : enriched.first;
    } catch (error) {
      throw AppFailure.notFound(
        'تعذر العثور على الحديث المنتشر المطلوب.',
        operation: 'fake_ahadith.get',
        cause: error,
      );
    }
  }

  @override
  Stream<List<FakeAhadith>> getFakeAhadithsStream() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .asyncMap((event) async {
          final fakeAhadiths = event
              .map((fa) => FakeAhadith.fromJson(fa))
              .toList();
          return _enrichSubValidTexts(fakeAhadiths);
        });
  }

  Future<List<FakeAhadith>> _enrichSubValidTexts(
    List<FakeAhadith> fakeAhadiths,
  ) async {
    final subValidIds = <String>{};
    final rulingIds = <String>{};
    for (final item in fakeAhadiths) {
      if (item.subValid != null && item.subValid!.isNotEmpty) {
        subValidIds.add(item.subValid!);
      }
      if (item.ruling != null && item.ruling!.isNotEmpty) {
        rulingIds.add(item.ruling!);
      }
    }

    try {
      final textsMap = <String, String>{};
      final rulingsMap = <String, String>{};

      if (subValidIds.isNotEmpty) {
        final hadithTexts = await _client
            .from(_ahadithTable)
            .select('id, text')
            .inFilter('id', subValidIds.toList());

        for (final row in hadithTexts as List) {
          textsMap[row['id']] = row['text']?.toString() ?? '';
        }
      }

      if (rulingIds.isNotEmpty) {
        final rulings = await _client
            .from('ruling')
            .select('id, name')
            .inFilter('id', rulingIds.toList());

        for (final row in rulings as List) {
          rulingsMap[row['id']] = row['name']?.toString() ?? '';
        }
      }

      return fakeAhadiths.map((item) {
        final text = item.subValid != null ? textsMap[item.subValid] : null;
        final rulingName = rulingsMap[item.ruling];
        return item.copyWith(subValidText: text, rulingName: rulingName);
      }).toList();
    } catch (_) {
      return fakeAhadiths;
    }
  }

  @override
  Future<FakeAhadith> createFakeAhadith(FakeAhadith fakeAhadith) async {
    try {
      final json = fakeAhadith.toJson();
      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');

      final response = await _client
          .from(_table)
          .insert(json)
          .select()
          .single();
      return FakeAhadith.fromJson(response);
    } catch (error) {
      throw AppFailure.storage(
        'تعذر إنشاء الحديث المنتشر الآن.',
        operation: 'fake_ahadith.create',
        cause: error,
      );
    }
  }

  @override
  Future<void> deleteFakeAhadith(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
    } catch (error) {
      throw AppFailure.storage(
        'تعذر حذف الحديث المنتشر الآن.',
        operation: 'fake_ahadith.delete',
        cause: error,
      );
    }
  }

  @override
  Future<FakeAhadith> updateFakeAhadith(FakeAhadith fakeAhadith) async {
    final id = fakeAhadith.id;
    if (id == null || id.isEmpty) {
      throw AppFailure.validation(
        'معرّف الحديث المنتشر مطلوب قبل التعديل.',
        operation: 'fake_ahadith.update',
      );
    }

    try {
      final json = fakeAhadith.toJson();
      json.remove('created_at');
      json.remove('updated_at');

      final response = await _client
          .from(_table)
          .update(json)
          .eq('id', id)
          .select()
          .single();
      return FakeAhadith.fromJson(response);
    } catch (error) {
      throw AppFailure.storage(
        'تعذر تعديل الحديث المنتشر الآن.',
        operation: 'fake_ahadith.update',
        cause: error,
      );
    }
  }
}

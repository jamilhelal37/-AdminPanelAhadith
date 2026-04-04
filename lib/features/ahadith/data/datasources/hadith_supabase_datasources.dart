import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/arabic_text_normalizer.dart';
import '../../domain/models/hadith.dart';
import '../../domain/models/hadith_page_result.dart';
import '../repositories/hadith_repository.dart';

class HadithSupabaseDatasource implements HadithRepository {
  final _client = Supabase.instance.client;
  static const String _table = "ahadith";
  static const String _topicClassTable = "topic_class";
  static const String _booksTable = "books";
  static const int _pageSize = 1000;

  String? _normalizeUuid(dynamic value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void _normalizeOptionalUuidFields(Map<String, dynamic> json) {
    json['sub_valid'] = _normalizeUuid(json['sub_valid']);
    json['explaining'] = _normalizeUuid(json['explaining']);
    json['final_ruling'] = _normalizeUuid(json['final_ruling']);
  }

  List<String>? _normalizeTypeFilters(List<String>? types) {
    if (types == null || types.isEmpty) return null;

    const typeMap = <String, String>{
      'HadithType.marfu': 'marfu',
      'HadithType.mawquf': 'mawquf',
      'HadithType.qudsi': 'qudsi',
      'HadithType.atharSahaba': 'atharSahaba',
      'marfu': 'marfu',
      'mawquf': 'mawquf',
      'qudsi': 'qudsi',
      'atharSahaba': 'atharSahaba',
    };

    final normalized = types
        .map((type) => typeMap[type] ?? type)
        .where((type) => type.trim().isNotEmpty)
        .toSet()
        .toList();

    return normalized.isEmpty ? null : normalized;
  }

  Future<Set<String>?> _resolveBookIdsForMuhaddiths(
    List<String>? muhaddithIds,
  ) async {
    if (muhaddithIds == null || muhaddithIds.isEmpty) {
      return null;
    }

    final response = await _client
        .from(_booksTable)
        .select('id')
        .inFilter('muhaddith', muhaddithIds);

    final ids = (response as List)
        .map((row) => row['id']?.toString())
        .whereType<String>()
        .toSet();

    return ids;
  }

  Future<Set<String>?> _resolveHadithIdsForTopics(
    List<String>? topicIds,
  ) async {
    if (topicIds == null || topicIds.isEmpty) {
      return null;
    }

    final response = await _client
        .from(_topicClassTable)
        .select('hadith')
        .inFilter('topic', topicIds);

    final ids = (response as List)
        .map((row) => row['hadith']?.toString())
        .whereType<String>()
        .toSet();

    return ids;
  }

  Set<String>? _intersectIds(Set<String>? first, Set<String>? second) {
    if (first == null) return second;
    if (second == null) return first;
    return first.intersection(second);
  }

  Future<List<Hadith>> _fetchHadithsByIds(List<String> ids) async {
    if (ids.isEmpty) return const [];

    final rawRows = <Map<String, dynamic>>[];
    for (var start = 0; start < ids.length; start += _pageSize) {
      final end = (start + _pageSize > ids.length)
          ? ids.length
          : start + _pageSize;
      final chunk = ids.sublist(start, end);

      final response = await _client
          .from(_table)
          .select(_selectWithRelations)
          .inFilter('id', chunk);

      rawRows.addAll(
        (response as List).map((row) => row as Map<String, dynamic>),
      );
    }

    final hadiths = rawRows.map(Hadith.fromJson).toList();

    final order = <String, int>{for (var i = 0; i < ids.length; i++) ids[i]: i};

    hadiths.sort((a, b) {
      final aOrder = order[a.id] ?? 1 << 20;
      final bOrder = order[b.id] ?? 1 << 20;
      return aOrder.compareTo(bOrder);
    });

    return hadiths;
  }

  Future<List<Map<String, dynamic>>> _fetchAllHadithRows({
    required Set<String>? topicHadithIds,
    required List<String>? rawiIds,
    required Set<String>? filteredBookIds,
    required List<String>? rulingIds,
    required List<String>? normalizedTypes,
    int? limit,
  }) async {
    final rows = <Map<String, dynamic>>[];
    var offset = 0;

    while (true) {
      if (limit != null && rows.length >= limit) {
        return rows.take(limit).toList();
      }

      final remaining = limit == null ? _pageSize : limit - rows.length;
      if (remaining <= 0) {
        break;
      }

      final batchSize = remaining < _pageSize ? remaining : _pageSize;
      var query = _client.from(_table).select(_selectWithRelations);

      if (topicHadithIds != null) {
        if (topicHadithIds.isEmpty) {
          return const [];
        }
        query = query.inFilter('id', topicHadithIds.toList());
      }
      if (rawiIds != null && rawiIds.isNotEmpty) {
        query = query.inFilter('rawi', rawiIds);
      }
      if (filteredBookIds != null && filteredBookIds.isNotEmpty) {
        query = query.inFilter('source', filteredBookIds.toList());
      }
      if (rulingIds != null && rulingIds.isNotEmpty) {
        query = query.inFilter('final_ruling', rulingIds);
      }
      if (normalizedTypes != null && normalizedTypes.isNotEmpty) {
        query = query.inFilter('type', normalizedTypes);
      }

      final response = await query
          .order("created_at", ascending: false)
          .range(offset, offset + batchSize - 1);

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

  Future<List<String>> _searchHadithIds({
    required String query,
    required String searchMode,
  }) async {
    if (searchMode == 'exact') {
      return _searchHadithIdsByExactPhrase(query: query);
    }

    final functionName = searchMode == 'all'
        ? 'search_ahadith_and_words'
        : 'search_ahadith_or_words';

    final matchedIds = <String>[];
    final seenIds = <String>{};
    var offset = 0;

    while (true) {
      final res = await _client.rpc(
        functionName,
        params: {'p_query': query, 'p_limit': _pageSize, 'p_offset': offset},
      );

      final batch = (res as List)
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

  Future<String> _normalizeSearchQuery(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    try {
      final normalized = await _client.rpc(
        'normalize_arabic_search_text',
        params: {'p_text': trimmed},
      );
      final value = normalized?.toString().trim() ?? '';
      if (value.isNotEmpty) {
        return value;
      }
    } catch (error, stackTrace) {
      debugPrint('NORMALIZE SEARCH QUERY ERROR: $error');
      debugPrint('$stackTrace');
    }

    return ArabicTextNormalizer.normalize(trimmed);
  }

  String _escapeLikePattern(String value) {
    return value
        .replaceAll('\\', '\\\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
  }

  Future<List<String>> _searchHadithIdsByExactPhrase({
    required String query,
  }) async {
    final parsedHadithNumber = ArabicTextNormalizer.tryParseArabicInteger(
      query,
    );
    if (parsedHadithNumber != null) {
      return _searchHadithIdsByHadithNumber(hadithNumber: parsedHadithNumber);
    }

    final normalizedQuery = await _normalizeSearchQuery(query);
    if (normalizedQuery.isEmpty) {
      return const [];
    }

    final matchedIds = <String>[];
    final seenIds = <String>{};
    final pattern = '%${_escapeLikePattern(normalizedQuery)}%';
    var offset = 0;

    while (true) {
      final response = await _client
          .from(_table)
          .select('id')
          .like('search_text', pattern)
          .order('hadith_number', ascending: true)
          .range(offset, offset + _pageSize - 1);

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

  Future<List<String>> _searchHadithIdsByHadithNumber({
    required int hadithNumber,
  }) async {
    final response = await _client
        .from(_table)
        .select('id')
        .eq('hadith_number', hadithNumber)
        .order('hadith_number', ascending: true);

    return (response as List)
        .map((row) => row['id']?.toString())
        .whereType<String>()
        .toList();
  }

  Future<List<Hadith>> _loadSubValidTexts(List<Hadith> hadithsList) async {
    final subValidIds = hadithsList
        .where((h) => h.subValid != null && h.subValid!.isNotEmpty)
        .map((h) => h.subValid!)
        .toSet()
        .toList();

    Map<String, String> subValidTexts = {};
    if (subValidIds.isNotEmpty) {
      try {
        final subValidRes = await _client
            .from(_table)
            .select('id, text')
            .inFilter('id', subValidIds);

        for (var item in subValidRes as List) {
          subValidTexts[item['id']] = item['text'].toString();
        }
      } catch (e) {
        debugPrint("ERROR LOADING SUB_VALID TEXTS: $e");
      }
    }

    return hadithsList.map((h) {
      if (h.subValid != null && subValidTexts.containsKey(h.subValid)) {
        return h.copyWith(subValidText: subValidTexts[h.subValid]);
      }
      return h;
    }).toList();
  }

  Future<int> _countHadiths() async {
    return _client.from(_table).count(CountOption.exact);
  }

  
  static const String _selectWithRelations = '''
id,
sub_valid,
explaining,
type,
text,
normal_text,
search_text,
hadith_number,
muhaddith_ruling,
final_ruling,
rawi,
source,
sanad,
created_at,
updated_at,

rawi_rel:rawis!fk_ahadith_rawi(name),
source_rel:books!fk_ahadith_source(name),

muhaddith_ruling_rel:ruling!fk_ahadith_muhaddith_ruling(name),
final_ruling_rel:ruling!fk_ahadith_final_ruling(name),

explaining_rel:explaining!fk_ahadith_explaining(text)

''';

  @override
  Future<List<Hadith>> getHadiths({
    String? searchQuery,
    List<String>? rawiIds,
    List<String>? muhaddithIds,
    List<String>? topicIds,
    List<String>? bookIds,
    List<String>? rulingIds,
    List<String>? types,
    int? limit,
    String searchMode = 'any', 
  }) async {
    try {
      final q = searchQuery?.trim();
      final normalizedTypes = _normalizeTypeFilters(types);
      final topicHadithIds = await _resolveHadithIdsForTopics(topicIds);
      final muhaddithBookIds = await _resolveBookIdsForMuhaddiths(muhaddithIds);

      Set<String>? filteredBookIds = _intersectIds(
        bookIds?.toSet(),
        muhaddithBookIds,
      );
      if ((bookIds != null && bookIds.isNotEmpty) ||
          (muhaddithIds != null && muhaddithIds.isNotEmpty)) {
        if (filteredBookIds == null || filteredBookIds.isEmpty) {
          return const [];
        }
      }

      List<Hadith> hadithsList = [];
      if (q != null && q.isNotEmpty) {
        final matchedIds = await _searchHadithIds(
          query: q,
          searchMode: searchMode,
        );

        if (matchedIds.isEmpty) {
          return const [];
        }

        var filteredIds = matchedIds.toSet();
        if (topicHadithIds != null) {
          filteredIds = filteredIds.intersection(topicHadithIds);
        }

        final filteredMatchedIds = matchedIds
            .where(filteredIds.contains)
            .toList();
        final limitedIds =
            limit != null && limit > 0
            ? filteredMatchedIds.take(limit).toList()
            : filteredMatchedIds;

        hadithsList = await _fetchHadithsByIds(limitedIds);
      } else {
        final rows = await _fetchAllHadithRows(
          topicHadithIds: topicHadithIds,
          rawiIds: rawiIds,
          filteredBookIds: filteredBookIds,
          rulingIds: rulingIds,
          normalizedTypes: normalizedTypes,
          limit: limit,
        );
        hadithsList = rows.map(Hadith.fromJson).toList();
      }

      if (q != null && q.isNotEmpty) {
        if (rawiIds != null && rawiIds.isNotEmpty) {
          hadithsList = hadithsList
              .where((hadith) => rawiIds.contains(hadith.rawiId))
              .toList();
        }
        if (filteredBookIds != null && filteredBookIds.isNotEmpty) {
          hadithsList = hadithsList
              .where((hadith) => filteredBookIds.contains(hadith.sourceId))
              .toList();
        }
        if (rulingIds != null && rulingIds.isNotEmpty) {
          hadithsList = hadithsList
              .where((hadith) => rulingIds.contains(hadith.finalRulingId))
              .toList();
        }
        if (normalizedTypes != null && normalizedTypes.isNotEmpty) {
          hadithsList = hadithsList.where((hadith) {
            final typeValue = _normalizeTypeFilters([hadith.type.name]);
            return typeValue != null &&
                typeValue.isNotEmpty &&
                normalizedTypes.contains(typeValue.first);
          }).toList();
        }
      }

      return _loadSubValidTexts(hadithsList);
    } catch (e, st) {
      debugPrint("LOAD HADITHS ERROR: $e");
      debugPrint("$st");
      if (e is PostgrestException) {
        debugPrint("message=${e.message}");
        debugPrint("details=${e.details}");
        debugPrint("hint=${e.hint}");
        debugPrint("code=${e.code}");
      }
      throw AppFailure.network(
        'تعذر تحميل الأحاديث الآن.',
        operation: 'hadith.list',
        cause: e,
      );
    }
  }

  @override
  Future<HadithPageResult> getHadithsPage({
    String? searchQuery,
    int page = 1,
    int pageSize = 100,
  }) async {
    try {
      final safePage = page < 1 ? 1 : page;
      final safePageSize = pageSize < 1 ? 100 : pageSize;
      final offset = (safePage - 1) * safePageSize;
      final q = searchQuery?.trim();

      if (q != null && q.isNotEmpty) {
        final matchedIds = await _searchHadithIds(query: q, searchMode: 'any');
        final totalCount = matchedIds.length;
        final pageIds = matchedIds.skip(offset).take(safePageSize).toList();
        final items = await _loadSubValidTexts(
          await _fetchHadithsByIds(pageIds),
        );

        return HadithPageResult(
          items: items,
          totalCount: totalCount,
          page: safePage,
          pageSize: safePageSize,
        );
      }

      final totalCount = await _countHadiths();
      final response = await _client
          .from(_table)
          .select(_selectWithRelations)
          .order("created_at", ascending: false)
          .range(offset, offset + safePageSize - 1);

      final items = await _loadSubValidTexts(
        (response as List).map((row) => Hadith.fromJson(row)).toList(),
      );

      return HadithPageResult(
        items: items,
        totalCount: totalCount,
        page: safePage,
        pageSize: safePageSize,
      );
    } catch (e, st) {
      debugPrint("LOAD HADITH PAGE ERROR: $e");
      debugPrint("$st");
      throw AppFailure.network(
        'تعذر تحميل صفحة الأحاديث الآن.',
        operation: 'hadith.page',
        cause: e,
      );
    }
  }

  @override
  Future<Hadith> getHadithById(String id) async {
    try {
      final res = await _client
          .from(_table)
          .select(_selectWithRelations)
          .eq('id', id)
          .single();

      return Hadith.fromJson(res);
    } catch (e) {
      throw AppFailure.notFound(
        'تعذر تحميل الحديث المطلوب.',
        operation: 'hadith.get',
        cause: e,
      );
    }
  }

  @override
  Future<Hadith> createHadith(Hadith hadith) async {
    try {
      final json = hadith.toJson();
      json.remove("id");
      json.remove("created_at");
      json.remove("explaining_rel");
      json.remove("rawi_rel");
      json.remove("source_rel");
      json.remove("muhaddith_ruling_rel");
      json.remove("final_ruling_rel");
      json.remove("updated_at");
      _normalizeOptionalUuidFields(json);

      final res = await _client
          .from(_table)
          .insert(json)
          .select(_selectWithRelations)
          .single();

      return Hadith.fromJson(res);
    } catch (e) {
      throw AppFailure.storage(
        'تعذر إنشاء الحديث الآن.',
        operation: 'hadith.create',
        cause: e,
      );
    }
  }

  @override
  Future<Hadith> updateHadith(Hadith hadith) async {
    try {
      if (hadith.id == null) {
        throw AppFailure.validation(
          'معرّف الحديث مطلوب قبل التعديل.',
          operation: 'hadith.update',
        );
      }

      final json = hadith.toJson();
      json.remove("id");
      json.remove("created_at");
      json.remove("explaining_rel");
      json.remove("rawi_rel");
      json.remove("source_rel");
      json.remove("muhaddith_ruling_rel");
      json.remove("final_ruling_rel");
      _normalizeOptionalUuidFields(json);

      final res = await _client
          .from(_table)
          .update(json)
          .eq("id", hadith.id!)
          .select(_selectWithRelations)
          .single();

      return Hadith.fromJson(res);
    } catch (e) {
      throw AppFailure.storage(
        'تعذر تعديل الحديث الآن.',
        operation: 'hadith.update',
        cause: e,
      );
    }
  }

  @override
  Future<void> deleteHadith(String id) async {
    try {
      await _client.from(_table).delete().eq("id", id);
    } catch (e) {
      throw AppFailure.storage(
        'تعذر حذف الحديث الآن.',
        operation: 'hadith.delete',
        cause: e,
      );
    }
  }

  @override
  Stream<List<Hadith>> getHadithsStream() {
    return _client
        .from(_table)
        .stream(primaryKey: ["id"])
        .order("created_at", ascending: false)
        .map((event) => event.map((row) => Hadith.fromJson(row)).toList());
  }
}


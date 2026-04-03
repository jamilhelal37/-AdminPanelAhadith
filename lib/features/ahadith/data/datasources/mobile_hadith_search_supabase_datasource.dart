import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/arabic_text_normalizer.dart';
import '../../domain/models/hadith.dart';
import '../repositories/mobile_hadith_search_repository.dart';

class MobileHadithSearchSupabaseDatasource
    implements MobileHadithSearchRepository {
  MobileHadithSearchSupabaseDatasource({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const String _hadithTable = 'ahadith';
  static const String _topicClassTable = 'topic_class';
  static const String _booksTable = 'books';
  static const int _pageSize = 1000;

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
  Future<List<Hadith>> searchHadiths({
    required String searchQuery,
    List<String>? rawiIds,
    List<String>? muhaddithIds,
    List<String>? topicIds,
    List<String>? bookIds,
    List<String>? rulingIds,
    List<String>? types,
    String searchMode = 'any',
  }) async {
    try {
      final query = searchQuery.trim();
      if (query.isEmpty) {
        return const [];
      }

      final normalizedTypes = _normalizeTypeFilters(types);
      final topicHadithIds = await _resolveHadithIdsForTopics(topicIds);
      final muhaddithBookIds = await _resolveBookIdsForMuhaddiths(muhaddithIds);

      final filteredBookIds = _intersectIds(bookIds?.toSet(), muhaddithBookIds);
      if ((bookIds != null && bookIds.isNotEmpty) ||
          (muhaddithIds != null && muhaddithIds.isNotEmpty)) {
        if (filteredBookIds == null || filteredBookIds.isEmpty) {
          return const [];
        }
      }

      final rows = await _fetchCandidateRows(
        topicHadithIds: topicHadithIds,
        rawiIds: rawiIds,
        filteredBookIds: filteredBookIds,
        rulingIds: rulingIds,
        normalizedTypes: normalizedTypes,
      );

      final results = rows
          .map(Hadith.fromJson)
          .where(
            (hadith) => _matchesMobileSearch(
              hadith: hadith,
              query: query,
              searchMode: searchMode,
            ),
          )
          .toList();

      return _loadSubValidTexts(results);
    } catch (error, stackTrace) {
      throw AppFailure.network(
        'تعذر تحميل نتائج البحث على الجوال الآن.',
        operation: 'hadith.mobileSearch',
        cause: error,
        details: stackTrace.toString(),
      );
    }
  }

  List<String>? _normalizeTypeFilters(List<String>? types) {
    if (types == null || types.isEmpty) {
      return null;
    }

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

    return (response as List)
        .map((row) => row['id']?.toString())
        .whereType<String>()
        .toSet();
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

    return (response as List)
        .map((row) => row['hadith']?.toString())
        .whereType<String>()
        .toSet();
  }

  Set<String>? _intersectIds(Set<String>? first, Set<String>? second) {
    if (first == null) return second;
    if (second == null) return first;
    return first.intersection(second);
  }

  Future<List<Map<String, dynamic>>> _fetchCandidateRows({
    required Set<String>? topicHadithIds,
    required List<String>? rawiIds,
    required Set<String>? filteredBookIds,
    required List<String>? rulingIds,
    required List<String>? normalizedTypes,
  }) async {
    final rows = <Map<String, dynamic>>[];
    var offset = 0;

    while (true) {
      var query = _client.from(_hadithTable).select(_selectWithRelations);

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
          .order('hadith_number', ascending: true)
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

  bool _matchesMobileSearch({
    required Hadith hadith,
    required String query,
    required String searchMode,
  }) {
    final normalizedQuery = _normalizeForSearch(query);
    if (normalizedQuery.isEmpty) {
      return true;
    }

    final normalizedHaystack = _buildNormalizedHaystack(hadith);
    final hadithNumber = hadith.hadithNumber.toString();

    if (searchMode == 'exact') {
      return normalizedQuery == hadithNumber ||
          normalizedHaystack.contains(normalizedQuery);
    }

    final tokens = normalizedQuery
        .split(' ')
        .where((token) => token.trim().isNotEmpty)
        .toList();
    if (tokens.isEmpty) {
      return true;
    }

    final matches = tokens.map(
      (token) => _tokenMatches(
        token: token,
        normalizedHaystack: normalizedHaystack,
        hadithNumber: hadithNumber,
      ),
    );

    return searchMode == 'all'
        ? matches.every((match) => match)
        : matches.any((match) => match);
  }

  bool _tokenMatches({
    required String token,
    required String normalizedHaystack,
    required String hadithNumber,
  }) {
    final normalizedToken = _normalizeForSearch(token);
    if (normalizedToken.isEmpty) {
      return false;
    }

    if (normalizedToken == hadithNumber) {
      return true;
    }

    return normalizedHaystack.contains(normalizedToken);
  }

  String _buildNormalizedHaystack(Hadith hadith) {
    final combined = [
      hadith.searchText,
      hadith.normalText,
      hadith.text,
      hadith.rawiName,
      hadith.sourceName,
      hadith.muhaddithRulingName,
      hadith.finalRulingName,
      hadith.sanad,
      hadith.hadithNumber.toString(),
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' ');

    return _normalizeForSearch(combined);
  }

  String _normalizeForSearch(String text) {
    return ArabicTextNormalizer.normalizeDigits(
      ArabicTextNormalizer.normalize(text),
    ).trim();
  }

  Future<List<Hadith>> _loadSubValidTexts(List<Hadith> hadiths) async {
    final subValidIds = hadiths
        .where(
          (hadith) => hadith.subValid != null && hadith.subValid!.isNotEmpty,
        )
        .map((hadith) => hadith.subValid!)
        .toSet()
        .toList();

    if (subValidIds.isEmpty) {
      return hadiths;
    }

    final subValidTexts = <String, String>{};
    final response = await _client
        .from(_hadithTable)
        .select('id, text')
        .inFilter('id', subValidIds);

    for (final item in response as List) {
      final id = item['id']?.toString();
      final text = item['text']?.toString();
      if (id == null || id.isEmpty || text == null || text.isEmpty) {
        continue;
      }
      subValidTexts[id] = text;
    }

    return hadiths.map((hadith) {
      final subValidId = hadith.subValid;
      if (subValidId != null && subValidTexts.containsKey(subValidId)) {
        return hadith.copyWith(subValidText: subValidTexts[subValidId]);
      }
      return hadith;
    }).toList();
  }
}

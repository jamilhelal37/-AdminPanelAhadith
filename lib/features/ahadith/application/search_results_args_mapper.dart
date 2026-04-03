import '../presentation/models/search_results_args.dart';

class SearchResultsArgsMapper {
  const SearchResultsArgsMapper._();

  static const String _allFilterValue = '__all__';
  static final RegExp _uuidPattern = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
  );
  static const Set<String> _allowedTypes = {
    'marfu',
    'mawquf',
    'qudsi',
    'atharSahaba',
  };

  static SearchResultsArgs? fromAdvancedForm({
    required String title,
    required String? searchQuery,
    required String? searchMode,
    List<String>? rawiIds,
    List<String>? muhaddithIds,
    List<String>? topicIds,
    List<String>? bookIds,
    List<String>? rulingIds,
    List<String>? types,
  }) {
    final query = (searchQuery ?? '').trim();
    if (query.isEmpty) {
      return null;
    }

    return SearchResultsArgs(
      title: title,
      searchQuery: query,
      searchMode: _normalizeSearchMode(searchMode),
      rawiIds: _normalizeUuidList(rawiIds),
      muhaddithIds: _normalizeUuidList(muhaddithIds),
      topicIds: _normalizeUuidList(topicIds),
      bookIds: _normalizeUuidList(bookIds),
      rulingIds: _normalizeUuidList(rulingIds),
      types: _normalizeTypes(types),
    );
  }

  static String _normalizeSearchMode(String? value) {
    return value == 'all' ? 'all' : 'any';
  }

  static List<String>? _normalizeUuidList(List<String>? values) {
    final normalized = _normalizeCommonList(
      values,
    )?.where((value) => _uuidPattern.hasMatch(value)).toList();

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized;
  }

  static List<String>? _normalizeTypes(List<String>? values) {
    final normalized = _normalizeCommonList(
      values,
    )?.where(_allowedTypes.contains).toList();

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized;
  }

  static List<String>? _normalizeCommonList(List<String>? values) {
    if (values == null || values.isEmpty) {
      return null;
    }

    final normalized = values
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty && value != _allFilterValue)
        .toSet()
        .toList();

    return normalized.isEmpty ? null : normalized;
  }
}

class SearchResultsArgs {
  const SearchResultsArgs({
    required this.title,
    required this.searchQuery,
    required this.searchMode,
    this.rawiIds,
    this.muhaddithIds,
    this.topicIds,
    this.bookIds,
    this.rulingIds,
    this.types,
  });

  final String title;
  final String searchQuery;
  final String searchMode;
  final List<String>? rawiIds;
  final List<String>? muhaddithIds;
  final List<String>? topicIds;
  final List<String>? bookIds;
  final List<String>? rulingIds;
  final List<String>? types;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchResultsArgs &&
        other.title == title &&
        other.searchQuery == searchQuery &&
        other.searchMode == searchMode &&
        _listEquals(other.rawiIds, rawiIds) &&
        _listEquals(other.muhaddithIds, muhaddithIds) &&
        _listEquals(other.topicIds, topicIds) &&
        _listEquals(other.bookIds, bookIds) &&
        _listEquals(other.rulingIds, rulingIds) &&
        _listEquals(other.types, types);
  }

  @override
  int get hashCode => Object.hash(
    title,
    searchQuery,
    searchMode,
    Object.hashAll(rawiIds ?? const []),
    Object.hashAll(muhaddithIds ?? const []),
    Object.hashAll(topicIds ?? const []),
    Object.hashAll(bookIds ?? const []),
    Object.hashAll(rulingIds ?? const []),
    Object.hashAll(types ?? const []),
  );

  static bool _listEquals(List<String>? a, List<String>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null || a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

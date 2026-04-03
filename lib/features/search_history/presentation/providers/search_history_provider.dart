import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/search_history_repository.dart';

class SearchHistoryLookupArgs {
  const SearchHistoryLookupArgs({
    required this.query,
    required this.isHadith,
    required this.limit,
  });

  final String query;
  final bool isHadith;
  final int limit;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SearchHistoryLookupArgs &&
            runtimeType == other.runtimeType &&
            query == other.query &&
            isHadith == other.isHadith &&
            limit == other.limit;
  }

  @override
  int get hashCode => Object.hash(query, isHadith, limit);
}

final searchHistoryRepositoryProvider = Provider<SearchHistoryRepository>((
  ref,
) {
  return SearchHistoryRepository();
});

final searchHistorySuggestionsProvider = FutureProvider.autoDispose
    .family<List<String>, SearchHistoryLookupArgs>((ref, args) async {
      final repository = ref.watch(searchHistoryRepositoryProvider);
      return repository.getSuggestions(
        query: args.query,
        isHadith: args.isHadith,
        limit: args.limit,
      );
    });

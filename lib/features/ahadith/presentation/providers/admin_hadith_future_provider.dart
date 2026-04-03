import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/hadith_repository_provider.dart';
import '../../domain/models/hadith.dart';
import 'search_provider.dart';

String _sanitizeAdminSearchInput(String value) {
  return value.replaceAll(RegExp(r'\s+'), ' ').trim();
}

final hadithPickerSearchProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

final adminHadithsFutureProvider = FutureProvider.autoDispose<List<Hadith>>((
  ref,
) async {
  final repo = ref.read(hadithRepositoryProvider);
  final search = _sanitizeAdminSearchInput(ref.watch(searchProvider));

  return repo.getHadiths(
    // Uses the same backend RPC normalization as general search
    // (normalize_arabic_search_text in SQL search functions).
    searchQuery: search.isEmpty ? null : search,
    searchMode: 'any',
  );
});

final adminHadithPickerFutureProvider =
    FutureProvider.autoDispose<List<Hadith>>((ref) async {
      final repo = ref.read(hadithRepositoryProvider);
      final search = _sanitizeAdminSearchInput(
        ref.watch(hadithPickerSearchProvider),
      );

      if (search.isEmpty) {
        return const <Hadith>[];
      }

      return repo.getHadiths(
        searchQuery: search,
        searchMode: 'exact',
        limit: 60,
      );
    });

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ahadith/data/repositories/hadith_repository_provider.dart';
import '../../../ahadith/domain/models/hadith.dart';

String _sanitizeSearchInput(String value) {
  return value.replaceAll(RegExp(r'\s+'), ' ').trim();
}

final selectableHadithsFutureProvider = FutureProvider.autoDispose
    .family<List<Hadith>, String>((ref, search) async {
      final repo = ref.read(hadithRepositoryProvider);
      final normalizedSearch = _sanitizeSearchInput(search);

      return repo.getHadiths(
        searchQuery: normalizedSearch.isEmpty ? null : normalizedSearch,
        searchMode: 'exact',
      );
    });

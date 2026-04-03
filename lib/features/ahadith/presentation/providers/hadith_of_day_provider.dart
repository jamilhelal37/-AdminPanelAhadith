import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/hadith_of_day_cache.dart';
import '../../application/hadith_of_day_helper.dart';
import '../../data/repositories/hadith_repository_provider.dart';
import '../../domain/models/hadith.dart';

final hadithCatalogProvider = FutureProvider.autoDispose<List<Hadith>>((
  ref,
) async {
  final repo = ref.read(hadithRepositoryProvider);
  return repo.getHadiths();
});

final hadithOfTheDayProvider = FutureProvider.autoDispose<Hadith?>((ref) async {
  final cachedHadith = await HadithOfDayCache.loadHadithForDate();
  if (cachedHadith != null) {
    return cachedHadith;
  }

  final hadiths = await ref.watch(hadithCatalogProvider.future);
  final selectedHadith = selectHadithOfTheDay(hadiths);
  if (selectedHadith != null) {
    await HadithOfDayCache.cacheScheduledHadiths({
      DateTime.now(): selectedHadith,
    });
  }

  return selectedHadith;
});

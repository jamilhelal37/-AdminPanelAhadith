import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ahadith/data/repositories/hadith_repository_provider.dart';
import '../../../ahadith/domain/models/hadith.dart';

final bookHadithsProvider = FutureProvider.autoDispose
    .family<List<Hadith>, String>((ref, bookId) async {
      final repo = ref.read(hadithRepositoryProvider);
      final hadiths = await repo.getHadiths(bookIds: [bookId]);
      hadiths.sort((a, b) => a.hadithNumber.compareTo(b.hadithNumber));
      return hadiths;
    });

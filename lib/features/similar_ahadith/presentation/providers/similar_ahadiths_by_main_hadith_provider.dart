import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/similar_ahadith_repositories_provider.dart';
import '../../domain/models/similar_ahadith.dart';

// Provider لجلب جميع الأحاديث المشابهة لحديث رئيسي معين
final similarAhadithsByMainHadithProvider =
    FutureProvider.family<List<SimilarAhadith>, String>((
      ref,
      mainHadithId,
    ) async {
      final repo = ref.watch(similarAhadithRepositoryProvider);
      final allSimilarAhadiths = await repo.getSimilarAhadiths(null);

      // تصفية الأحاديث المشابهة للحديث الرئيسي المحدد
      return allSimilarAhadiths
          .where((sa) => sa.mainHadithId == mainHadithId)
          .toList();
    });


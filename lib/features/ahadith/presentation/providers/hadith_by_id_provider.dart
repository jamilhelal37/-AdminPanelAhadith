import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/hadith_repository_provider.dart';
import '../../domain/models/hadith.dart';

final hadithByIdProvider = FutureProvider.family<Hadith, String>((
  ref,
  hadithId,
) async {
  final repo = ref.watch(hadithRepositoryProvider);
  return repo.getHadithById(hadithId);
});

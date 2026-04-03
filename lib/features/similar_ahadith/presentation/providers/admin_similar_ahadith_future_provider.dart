import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/similar_ahadith_repositories_provider.dart';
import '../../domain/models/similar_ahadith.dart';
import 'search_provider.dart';

var adminSimilarAhadithsFutureProvider = FutureProvider<List<SimilarAhadith>>((
  ref,
) async {
  var repo = ref.read(similarAhadithRepositoryProvider);
  var search = ref.watch(searchProvider);
  return repo.getSimilarAhadiths(search);
});

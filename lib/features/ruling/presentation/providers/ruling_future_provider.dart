import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/ruling_repositories_provider.dart';
import '../../domain/models/ruling.dart';
import 'search_provider.dart';

var adminRulingsFutureProvider = FutureProvider<List<Ruling>>((ref) async {
  var repo = ref.read(rulingRepositoryProvider);
  var search = ref.watch(searchProvider);
  return repo.getRulings(search);
});

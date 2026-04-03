import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/explaining_repositories_provider.dart';
import '../../domain/models/explaining.dart';
import 'search_provider.dart';

var adminExplainingsFutureProvider = FutureProvider<List<Explaining>>((
  ref,
) async {
  var repo = ref.read(explainingRepositoryProvider);
  var search = ref.watch(searchProvider);
  return repo.getExplainings(search);
});

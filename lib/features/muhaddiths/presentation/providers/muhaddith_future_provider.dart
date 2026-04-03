import 'package:ahadith/features/muhaddiths/domain/models/muhaddith.dart';
import 'package:ahadith/features/muhaddiths/data/repositories/muhaddith_repositories_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'search_provider.dart';

var adminMuhaddithFutureProvider = FutureProvider<List<Muhaddith>>((ref) async {
  var repo = ref.read(muhaddithRepositoryProvider);
  var search = ref.watch(searchProvider);
  return repo.getMuhaddiths(search);
});

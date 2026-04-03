import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/rawi_repositories_provider.dart';
import '../../domain/models/rawi.dart';
import 'search_provider.dart';

var adminRawisFutureProvider = FutureProvider<List<Rawi>>((ref) async {
  var repo = ref.read(rawiRepositoryProvider);
  var search = ref.watch(searchProvider);
  return repo.getRawis(search);
});

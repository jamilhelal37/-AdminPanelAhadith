import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/fakeahadith_repositories_provider.dart';
import '../../domain/models/fake_ahadith.dart';
import 'search_provider.dart';

String _sanitizeAdminSearchInput(String value) {
  return value.replaceAll(RegExp(r'\s+'), ' ').trim();
}

var adminFakeAhadithsFutureProvider = FutureProvider<List<FakeAhadith>>((
  ref,
) async {
  var repo = ref.read(fakeAhadithRepositoryProvider);
  var search = _sanitizeAdminSearchInput(ref.watch(searchProvider));
  return repo.getFakeAhadiths(search);
});

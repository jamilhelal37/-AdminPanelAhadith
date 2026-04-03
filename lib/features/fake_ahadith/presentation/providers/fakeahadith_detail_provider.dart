import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/fakeahadith_repositories_provider.dart';
import '../../domain/models/fake_ahadith.dart';

final fakeAhadithByIdProvider = FutureProvider.autoDispose
    .family<FakeAhadith?, String>((ref, id) async {
      final repository = ref.watch(fakeAhadithRepositoryProvider);
      return repository.getFakeAhadithById(id);
    });

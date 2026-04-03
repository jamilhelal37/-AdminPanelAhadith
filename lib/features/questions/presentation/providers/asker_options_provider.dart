import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/asker_options_repository_provider.dart';

class AskerOption {
  const AskerOption({required this.id, required this.name});

  final String id;
  final String name;
}

final askerOptionsFutureProvider =
    FutureProvider.autoDispose<List<AskerOption>>((ref) async {
      final repo = ref.read(askerOptionsRepositoryProvider);
      final res = await repo.getAskerOptions();

      return res
          .map(
            (e) => AskerOption(
              id: e['id'].toString(),
              name: (e['name'] ?? '').toString(),
            ),
          )
          .where((x) => x.id.trim().isNotEmpty)
          .toList();
    });

import 'package:flutter_riverpod/flutter_riverpod.dart';

final scopedLoadingProvider = StateProvider.autoDispose.family<bool, String>((
  ref,
  scope,
) {
  return false;
});

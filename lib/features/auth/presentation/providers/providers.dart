import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_notifier_provider.dart';

final signupPasswordVisibilityProvider = StateProvider.autoDispose<bool>(
  (ref) => true,
);

final signupConfirmPasswordVisibilityProvider = StateProvider.autoDispose<bool>(
  (ref) => true,
);

final passwordVisibilityProvider = StateProvider.autoDispose<bool>(
  (ref) => true,
);

final showPostSignupAvatarProvider = StateProvider<bool>((ref) => false);

enum AuthSessionStatus { booting, anonymous, authenticated }

final authSessionStatusProvider = Provider<AuthSessionStatus>((ref) {
  final authState = ref.watch(authNotifierProvider);
  if (authState.isLoading) {
    return AuthSessionStatus.booting;
  }

  return authState.valueOrNull == null
      ? AuthSessionStatus.anonymous
      : AuthSessionStatus.authenticated;
});

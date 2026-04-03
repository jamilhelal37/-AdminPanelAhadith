import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/supabase_auth_repository.dart';
import '../../domain/models/app_user.dart';
import 'providers.dart';

class AuthNotifier extends AsyncNotifier<AppUser?> {
  late AppUser? appUser;
  static String get _adminOnlyMessage => 'فقط الأدمن يمكنه الدخول';
  static String get _inactiveAccountMessage =>
      'هذا الحساب غير نشط، لا يمكنك تسجيل الدخول حاليًا.';
  static const Duration _userLoadTimeout = Duration(seconds: 8);
  StreamSubscription<AuthState>? _authSubscription;

  bool _isInvalidSessionError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('invalid jwt') ||
        message.contains('jwt expired') ||
        message.contains('refresh token') ||
        message.contains('session_not_found');
  }

  String _errorMessage(Object error) {
    if (error is AuthException) {
      final message = error.message;
      if (message.contains('User already exists') ||
          message.contains('already registered') ||
          message.contains('already exists')) {
        return 'هذا البريد الإلكتروني مسجل مسبقًا، جرّب تسجيل الدخول.';
      }
      return message;
    }
    return error.toString();
  }

  @override
  Future<AppUser?> build() async {
    _authSubscription ??= Supabase.instance.client.auth.onAuthStateChange
        .listen((data) {
          unawaited(_syncAuthState(data.event));
        });

    ref.onDispose(() async {
      await _authSubscription?.cancel();
      _authSubscription = null;
    });

    return _loadCurrentUser();
  }

  Future<AppUser?> _loadCurrentUser() async {
    final repo = ref.read(authRepositoryProvider);
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      appUser = null;
      return null;
    }

    try {
      final user = await repo.getAppUser().timeout(
        _userLoadTimeout,
        onTimeout: () => _buildFallbackUser(session.user),
      );
      return _applyAccessRules(user);
    } catch (error) {
      if (_isInvalidSessionError(error)) {
        await repo.signOut();
        appUser = null;
        return null;
      }
      if (error is TimeoutException) {
        final fallbackUser = _buildFallbackUser(session.user);
        appUser = fallbackUser;
        return fallbackUser;
      }
      rethrow;
    }
  }

  AppUser _buildFallbackUser(User user) {
    final metadata = user.userMetadata ?? <String, dynamic>{};
    final email = user.email ?? '';
    final fallbackName = email.contains('@') ? email.split('@').first : email;
    final avatarUrl =
        (metadata['avatar_url'] as String?) ?? (metadata['picture'] as String?);

    return AppUser(
      id: user.id,
      name: (metadata['name'] as String?)?.trim().isNotEmpty == true
          ? (metadata['name'] as String).trim()
          : (metadata['full_name'] as String?)?.trim().isNotEmpty == true
          ? (metadata['full_name'] as String).trim()
          : fallbackName,
      email: email,
      avatarUrl: avatarUrl,
      isActivated: true,
      gender: _parseGender(metadata['gender']),
      type: _parseUserType(metadata['type']),
      birthDate: metadata['birth_date'] as String?,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  Gender? _parseGender(dynamic value) {
    return switch ((value as String?)?.trim().toLowerCase()) {
      'male' => Gender.male,
      'female' => Gender.female,
      _ => null,
    };
  }

  UserType? _parseUserType(dynamic value) {
    return switch ((value as String?)?.trim().toLowerCase()) {
      'admin' => UserType.admin,
      'member' => UserType.member,
      'scholar' => UserType.scholar,
      _ => null,
    };
  }

  Future<AppUser?> _applyAccessRules(AppUser? user) async {
    if (user == null) {
      appUser = null;
      return null;
    }

    final denialMessage = _accessDeniedMessage(user);
    if (denialMessage != null) {
      await _signOutSilently();
      appUser = null;
      return null;
    }

    appUser = user;
    return user;
  }

  String? _accessDeniedMessage(AppUser? user) {
    if (user == null) return null;
    if (!user.isActivated) {
      return _inactiveAccountMessage;
    }
    if (kIsWeb && user.type != UserType.admin) {
      return _adminOnlyMessage;
    }
    return null;
  }

  Future<void> _signOutSilently() async {
    try {
      await ref.read(authRepositoryProvider).signOut();
      // ignore: empty_catches
    } catch (_) {}
  }

  Future<void> _syncAuthState(AuthChangeEvent event) async {
    if (event == AuthChangeEvent.signedOut) {
      appUser = null;
      state = const AsyncValue.data(null);
      return;
    }

    if (event == AuthChangeEvent.initialSession ||
        event == AuthChangeEvent.signedIn ||
        event == AuthChangeEvent.tokenRefreshed ||
        event == AuthChangeEvent.userUpdated) {
      try {
        final user = await _loadCurrentUser();
        state = AsyncValue.data(user);
      } catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    String? gender,
    String? type,
    String? birthDate,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      var repo = ref.read(authRepositoryProvider);
      await repo.signUpWithEmail(
        name: name,
        email: email,
        password: password,
        gender: gender,
        type: type,
        birthDate: birthDate,
      );

      onSuccess();
    } catch (e) {
      onError(_errorMessage(e));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    String? avatarUrl,
    String? gender,
    String? type,
    String? birthDate,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final repo = ref.read(authRepositoryProvider);
      appUser = await repo.updateAppUserProfile(
        name: name,
        email: email,
        avatarUrl: avatarUrl,
        gender: gender,
        type: type,
        birthDate: birthDate,
      );
      state = AsyncValue.data(appUser);
      onSuccess();
    } catch (e) {
      onError(_errorMessage(e));
    }
  }

  Future<void> uploadAvatar({
    required Uint8List bytes,
    required String fileExtension,
    required void Function(String publicUrl) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final repo = ref.read(authRepositoryProvider);
      final publicUrl = await repo.uploadAvatarImage(
        bytes: bytes,
        fileExtension: fileExtension,
      );
      await repo.updateAvatarUrl(publicUrl);

      final current = state.valueOrNull;
      if (current != null) {
        final updated = current.copyWith(avatarUrl: publicUrl);
        appUser = updated;
        state = AsyncValue.data(updated);
      } else {
        final reloaded = await repo.getAppUser();
        appUser = reloaded;
        state = AsyncValue.data(reloaded);
      }

      onSuccess(publicUrl);
    } catch (e) {
      onError(_errorMessage(e));
    }
  }

  Future<void> removeAvatar({
    String? currentAvatarUrl,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.deleteAvatarImage(currentAvatarUrl: currentAvatarUrl);

      final current = state.valueOrNull;
      if (current != null) {
        final updated = current.copyWith(avatarUrl: null);
        appUser = updated;
        state = AsyncValue.data(updated);
      } else {
        final reloaded = await repo.getAppUser();
        appUser = reloaded;
        state = AsyncValue.data(reloaded);
      }

      // Show post-signup avatar screen
      ref.read(showPostSignupAvatarProvider.notifier).state = true;
      onSuccess();
    } catch (e) {
      onError(_errorMessage(e));
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signInWithEmail(email, password);

      final user = await repo.getAppUser();
      final denialMessage = _accessDeniedMessage(user);
      if (denialMessage != null) {
        await _signOutSilently();
        state = const AsyncValue.data(null);
        onError(denialMessage);
        return;
      }

      appUser = user;
      state = AsyncValue.data(user);
      onSuccess();
    } catch (e) {
      onError(_errorMessage(e));
    }
  }

  Future<void> logout() async {
    try {
      var repo = ref.read(authRepositoryProvider);
      await repo.signOut();
      state = const AsyncValue.data(null);
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> googleAuth() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.googleAuth();

      final user = await repo.getAppUser();
      final denialMessage = _accessDeniedMessage(user);
      if (denialMessage != null) {
        await _signOutSilently();
        state = const AsyncValue.data(null);
        throw AuthException(denialMessage);
      }

      appUser = user;
      state = AsyncValue.data(user);
    } catch (e) {
      rethrow;
    }
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AppUser?>(
  AuthNotifier.new,
);

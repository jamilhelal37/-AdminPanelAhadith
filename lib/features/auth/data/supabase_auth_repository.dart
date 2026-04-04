import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models/app_user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(Supabase.instance.client);
});

class AuthRepository {
  final SupabaseClient _supabase;
  AuthRepository(this._supabase);

  String _normalizeEmail(String email) => email.trim().toLowerCase();

  bool _isInvalidSessionError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('invalid jwt') ||
        message.contains('jwt expired') ||
        message.contains('refresh token') ||
        message.contains('session_not_found');
  }

  AuthException _asAuthException(Object error) {
    if (error is AuthException) {
      final raw = error.message.trim();
      if (raw.contains('already registered') ||
          raw.contains('already exists') ||
          raw.contains('duplicate key value')) {
        return AuthException('User already exists');
      }
      return error;
    }

    final message = error.toString();
    if (message.contains('ClientException: Failed to fetch') ||
        message.contains('Failed to fetch') ||
        message.contains('XMLHttpRequest error')) {
      return AuthException(
        'تعذر الاتصال بخدمة تسجيل الدخول. إذا كنت تعمل على نسخة الويب محليًا فتأكد من تشغيلها على المسار الصحيح وأن المتصفح أو الـ VPN لا يحجب طلبات Supabase.',
      );
    }
    if (message.contains('Failed host lookup') ||
        message.contains('SocketException')) {
      return AuthException(
        'Network error: unable to reach server. Please check your internet connection.',
      );
    }

    if (message.contains('already registered') ||
        message.contains('already exists') ||
        message.contains('duplicate key value')) {
      return AuthException('User already exists');
    }

    return AuthException(message);
  }

  String? _firstEnv(List<String> keys) {
    for (final key in keys) {
      final value = dotenv.env[key]?.trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String? gender,
    String? type,
    String? birthDate,
  }) async {
    try {
      final normalizedEmail = _normalizeEmail(email);
      final res = await _supabase.auth.signUp(
        email: normalizedEmail,
        password: password,
        data: {
          'name': name,
          'full_name': name,
          'gender': gender,
          'type': type ?? 'member',
          'birth_date': birthDate,
        },
      );

      final authUser = res.user;
      if (authUser != null) {
        await _supabase.from('app_user').upsert({
          'id': authUser.id,
          'name': name,
          'email': normalizedEmail,
          'is_activated': true,
          'gender': gender,
          'type': type ?? 'member',
          'birth_date': birthDate,
        }, onConflict: 'id');
      }

      return res;
    } catch (e) {
      throw _asAuthException(e);
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: _normalizeEmail(email),
        password: password,
      );
      return response.user ?? _supabase.auth.currentUser;
    } catch (e) {
      throw _asAuthException(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw _asAuthException(e);
    }
  }

  Future<void> googleAuth() async {
    Object? nativeFlowError;

    try {
      final serverClientId = _firstEnv([
        'GOOGLE_SERVER',
        'GOOGLE_WEB_CLIENT_ID',
        'GOOGLE_SERVER_CLIENT_ID',
      ]);

      final platformClientId = _firstEnv([
        if (kIsWeb) 'GOOGLE_WEB_CLIENT_ID' else 'GOOGLE_IOS_ID',
        'GOOGLE_IOS_CLIENT_ID',
      ]);

      if (serverClientId == null) {
        throw AuthException(
          'Google Sign-In misconfigured: missing GOOGLE_SERVER (web client id).',
        );
      }

      final googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        serverClientId: serverClientId,
        clientId: platformClientId,
      );

      final googleUser = await googleSignIn.authenticate();

      final googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw AuthException('Google authentication failed');
      }

      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
      );

      await _syncAppUserFromAuth();
      return;
    } catch (e) {
      nativeFlowError = e;
    }

    if (nativeFlowError is AuthException &&
        nativeFlowError.message.contains('Google Sign-In misconfigured')) {
      throw nativeFlowError;
    }

    try {
      final redirectTo = _firstEnv(['SUPABASE_REDIRECT_URL']);

      if (!kIsWeb && (redirectTo == null || redirectTo.isEmpty)) {
        throw AuthException(
          'Missing SUPABASE_REDIRECT_URL for mobile OAuth. Add a deep link URL like myapp://login-callback/ and whitelist it in Supabase Auth Redirect URLs.',
        );
      }

      final launched = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? null : redirectTo,
      );

      if (!launched) {
        throw AuthException('Could not launch Google OAuth flow.');
      }

      await _supabase.auth.onAuthStateChange
          .where((event) => event.event == AuthChangeEvent.signedIn)
          .first
          .timeout(const Duration(seconds: 45));

      await _syncAppUserFromAuth();
    } catch (oauthError) {
      final oauthMessage = oauthError.toString();
      if (oauthMessage.contains('missing OAuth secret')) {
        throw AuthException(
          'Google provider is not fully configured in Supabase. Add Google OAuth Client ID and Client Secret in Supabase Auth Providers.',
        );
      }
      debugPrint(
        'Google auth failure | native: $nativeFlowError | oauth: $oauthError',
      );
      throw _asAuthException(
        'Google Sign-In failed. Native error: $nativeFlowError | OAuth error: $oauthError',
      );
    }
  }

  Future<void> _syncAppUserFromAuth({User? authUser}) async {
    final resolvedAuthUser = authUser ?? _supabase.auth.currentUser;
    if (resolvedAuthUser == null) {
      throw AuthException('No authenticated user after sign-in.');
    }

    final email = resolvedAuthUser.email;
    if (email == null || email.trim().isEmpty) {
      throw AuthException('Authenticated user has no email.');
    }
    final normalizedEmail = _normalizeEmail(email);

    final metadata = resolvedAuthUser.userMetadata ?? <String, dynamic>{};
    final fallbackName = normalizedEmail.split('@').first;
    final name = (metadata['full_name'] as String?)?.trim().isNotEmpty == true
        ? (metadata['full_name'] as String).trim()
        : (metadata['name'] as String?)?.trim().isNotEmpty == true
        ? (metadata['name'] as String).trim()
        : fallbackName;

    final existingProfile = await _supabase
        .from('app_user')
        .select('is_activated, type, gender, birth_date, avatar_url')
        .eq('id', resolvedAuthUser.id)
        .maybeSingle();

    await _supabase.from('app_user').upsert({
      'id': resolvedAuthUser.id,
      'name': name,
      'email': normalizedEmail,
      'avatar_url':
          metadata['avatar_url'] ??
          metadata['picture'] ??
          existingProfile?['avatar_url'],
      'is_activated': existingProfile?['is_activated'] ?? true,
      'gender': existingProfile?['gender'] ?? metadata['gender'],
      'type': existingProfile?['type'] ?? metadata['type'] ?? 'member',
      'birth_date': existingProfile?['birth_date'] ?? metadata['birth_date'],
    }, onConflict: 'id');
  }

  Future<AppUser> updateAppUserProfile({
    required String name,
    required String email,
    String? avatarUrl,
    String? gender,
    String? type,
    String? birthDate,
  }) async {
    try {
      final authUser = _supabase.auth.currentUser;
      if (authUser == null) {
        throw AuthException('No authenticated user.');
      }
      final normalizedEmail = _normalizeEmail(email);

      final updated = await _supabase
          .from('app_user')
          .update({
            'name': name,
            'email': normalizedEmail,
            'avatar_url': avatarUrl,
            'gender': gender,
            'type': type,
            'birth_date': birthDate,
          })
          .eq('id', authUser.id)
          .select('*')
          .single();

      return AppUser.fromJson(updated);
    } catch (e) {
      throw _asAuthException(e);
    }
  }

  Future<String> uploadAvatarImage({
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    try {
      final authUser = _supabase.auth.currentUser;
      if (authUser == null) {
        throw AuthException('No authenticated user.');
      }

      final normalizedExt = fileExtension.toLowerCase().replaceAll('.', '');
      final safeExt = switch (normalizedExt) {
        'jpg' || 'jpeg' => 'jpg',
        'png' => 'png',
        'webp' => 'webp',
        _ => 'jpg',
      };
      final path =
          '${authUser.id}/avatar_${DateTime.now().microsecondsSinceEpoch}_${authUser.id.substring(0, 8)}.$safeExt';

      await _supabase.storage
          .from('avatars')
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(upsert: false),
          );

      return _supabase.storage.from('avatars').getPublicUrl(path);
    } catch (e) {
      throw _asAuthException(e);
    }
  }

  Future<void> updateAvatarUrl(String avatarUrl) async {
    try {
      final authUser = _supabase.auth.currentUser;
      if (authUser == null) {
        throw AuthException('No authenticated user.');
      }

      await _supabase
          .from('app_user')
          .update({'avatar_url': avatarUrl})
          .eq('id', authUser.id);
    } catch (e) {
      throw _asAuthException(e);
    }
  }

  String? _extractAvatarPathFromPublicUrl(String publicUrl) {
    const marker = '/storage/v1/object/public/avatars/';
    final index = publicUrl.indexOf(marker);
    if (index == -1) return null;

    final encodedPath = publicUrl.substring(index + marker.length);
    final cleanPath = encodedPath.split('?').first;
    if (cleanPath.trim().isEmpty) return null;
    return Uri.decodeComponent(cleanPath);
  }

  Future<void> deleteAvatarImage({String? currentAvatarUrl}) async {
    try {
      final authUser = _supabase.auth.currentUser;
      if (authUser == null) {
        throw AuthException('No authenticated user.');
      }

      final avatarUrl = currentAvatarUrl?.trim() ?? '';
      if (avatarUrl.isNotEmpty) {
        final path = _extractAvatarPathFromPublicUrl(avatarUrl);
        if (path != null && path.isNotEmpty) {
          try {
            await _supabase.storage.from('avatars').remove([path]);
          } catch (_) {}
        }
      }

      await _supabase
          .from('app_user')
          .update({'avatar_url': null})
          .eq('id', authUser.id);
    } catch (e) {
      throw _asAuthException(e);
    }
  }

  Future<AppUser?> getAppUser({
    User? authUser,
    bool verifySession = true,
  }) async {
    try {
      final user =
          authUser ??
          (verifySession
              ? await _getVerifiedAuthUser()
              : (_supabase.auth.currentUser ??
                    _supabase.auth.currentSession?.user));
      if (user == null) return null;

      final res = await _supabase
          .from('app_user')
          .select('*')
          .eq('id', user.id)
          .maybeSingle();

      if (res == null) {
        await _syncAppUserFromAuth(authUser: user);
        final syncedRes = await _supabase
            .from('app_user')
            .select('*')
            .eq('id', user.id)
            .maybeSingle();

        if (syncedRes == null) {
          throw AuthException('Failed to create app_user profile.');
        }
        return AppUser.fromJson(syncedRes);
      }

      return AppUser.fromJson(res);
    } catch (e) {
      throw _asAuthException(e);
    }
  }

  Future<User?> _getVerifiedAuthUser() async {
    final currentSession = _supabase.auth.currentSession;
    if (currentSession == null) {
      return null;
    }

    try {
      final response = await _supabase.auth.getUser(currentSession.accessToken);
      return response.user;
    } on AuthException catch (error) {
      if (!_isInvalidSessionError(error)) {
        rethrow;
      }

      try {
        final refreshed = await _supabase.auth.refreshSession();
        final refreshedSession =
            refreshed.session ?? _supabase.auth.currentSession;
        if (refreshedSession == null) {
          throw AuthException('Invalid JWT');
        }

        final refreshedUser = await _supabase.auth.getUser(
          refreshedSession.accessToken,
        );
        return refreshedUser.user;
      } on AuthException catch (refreshError) {
        if (_isInvalidSessionError(refreshError)) {
          throw AuthException('Invalid JWT');
        }
        rethrow;
      }
    }
  }
}

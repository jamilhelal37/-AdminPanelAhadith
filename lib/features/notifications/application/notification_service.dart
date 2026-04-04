import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../firebase_options.dart';
import '../../ahadith/application/hadith_of_day_notification_service.dart';

final pushNotificationServiceProvider = Provider<PushNotificationService>((
  ref,
) {
  throw UnimplementedError(
    'pushNotificationServiceProvider must be overridden in main()',
  );
});

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('Handling a background message: ${message.messageId}');
}

class PushNotificationService {
  PushNotificationService({
    FirebaseMessaging? messaging,
    SupabaseClient? supabase,
    required HadithOfDayNotificationService localNotifications,
  }) : _messagingOverride = messaging,
       _supabase = supabase ?? Supabase.instance.client,
       _localNotifications = localNotifications;

  static const String _topicAll = 'all';
  static const String _channelId = 'push_notifications';
  static const String _channelName = 'إشعارات التطبيق';
  static const String _channelDescription = 'الإشعارات الفورية العامة والخاصة';

  final FirebaseMessaging? _messagingOverride;
  final SupabaseClient _supabase;
  final HadithOfDayNotificationService _localNotifications;

  StreamSubscription<AuthState>? _authSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;
  final StreamController<String> _payloadStream =
      StreamController<String>.broadcast();
  String? _launchPayload;

  bool _initialized = false;

  Stream<String> get payloadStream => _payloadStream.stream;

  FirebaseMessaging get _messaging =>
      _messagingOverride ?? FirebaseMessaging.instance;

  String? consumeLaunchPayload() {
    final payload = _launchPayload;
    _launchPayload = null;
    return payload;
  }

  Future<void> initialize() async {
    if (_initialized || !_supportsPushNotifications) return;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _messaging.setAutoInitEnabled(true);

    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final permissionGranted =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (!permissionGranted) {
      log('Push notifications permission was not granted.');
      return;
    }

    await _messaging.subscribeToTopic(_topicAll);
    await _saveCurrentToken();

    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn ||
          data.event == AuthChangeEvent.tokenRefreshed) {
        unawaited(_saveCurrentToken());
      }
    });

    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((newToken) {
      unawaited(_messaging.subscribeToTopic(_topicAll));
      unawaited(_saveTokenToSupabase(newToken));
    });

    _openedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen((
      message,
    ) {
      final payload = _serializePayload(message.data);
      if (payload != null && payload.isNotEmpty) {
        _payloadStream.add(payload);
      }
    });

    final initialMessage = await _messaging.getInitialMessage();
    final initialPayload = initialMessage == null
        ? null
        : _serializePayload(initialMessage.data);
    if (initialPayload != null && initialPayload.isNotEmpty) {
      _launchPayload = initialPayload;
    }

    _foregroundSubscription = FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      unawaited(
        _localNotifications.showInstantNotification(
          id: notification.hashCode,
          title: notification.title ?? 'إشعار جديد',
          body: notification.body ?? '',
          channelId: _channelId,
          channelName: _channelName,
          channelDescription: _channelDescription,
          payload: _serializePayload(message.data),
        ),
      );
    });

    _initialized = true;
  }

  bool get _supportsPushNotifications {
    if (kIsWeb) return false;

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  Future<void> dispose() async {
    await _authSubscription?.cancel();
    await _tokenRefreshSubscription?.cancel();
    await _foregroundSubscription?.cancel();
    await _openedAppSubscription?.cancel();
    await _payloadStream.close();
  }

  Future<void> _saveCurrentToken() async {
    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) return;

    await _saveTokenToSupabase(token);
  }

  Future<void> _saveTokenToSupabase(String token) async {
    final session = _supabase.auth.currentSession;
    if (session == null) return;

    try {
      await _supabase.from('user_fcm_tokens').upsert({
        'user_id': session.user.id,
        'fcm_token': token,
        'last_seen': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id, fcm_token');
      log('FCM token saved to Supabase.');
    } catch (error, stackTrace) {
      log(
        'Failed to save FCM token to Supabase.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  String? _serializePayload(Map<String, dynamic> data) {
    if (data.isEmpty) return null;

    final payload = data['payload'];
    if (payload is String && payload.trim().isNotEmpty) {
      return payload.trim();
    }

    return jsonEncode(data);
  }
}

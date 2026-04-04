import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/hadith.dart';
import 'hadith_of_day_notification_constants.dart';
import 'hadith_of_day_notification_scheduler.dart';

final hadithOfDayNotificationServiceProvider =
    Provider<HadithOfDayNotificationService>((ref) {
      throw UnimplementedError(
        'hadithOfDayNotificationServiceProvider must be overridden in main()',
      );
    });

@pragma('vm:entry-point')
Future<void> onNotificationActionReceived(ReceivedAction receivedAction) async {
  final sendPort = IsolateNameServer.lookupPortByName(
    HadithOfDayNotificationService.portName,
  );

  if (sendPort != null) {
    sendPort.send(receivedAction.toMap());
  }
}

class HadithOfDayNotificationService {
  static const Color _brandNotificationColor = Color(0xFFD0953B);
  static const String hadithOfDayPayload =
      HadithOfDayNotificationConstants.payload;
  static const String portName = 'ahadith_notification_action_port';
  static const String payloadKey = 'payload';
  static const String pushChannelId = 'push_notifications';
  static const String pushChannelName = 'إشعارات التطبيق';
  static const String pushChannelDescription =
      'الإشعارات الفورية العامة والخاصة';

  HadithOfDayNotificationService({AwesomeNotifications? notifications})
    : _notificationsOverride = notifications;

  final AwesomeNotifications? _notificationsOverride;
  late final HadithOfDayNotificationScheduler _scheduler =
      HadithOfDayNotificationScheduler(_notifications);
  final StreamController<String> _payloadStream =
      StreamController<String>.broadcast();

  ReceivePort? _receivePort;
  bool _initialized = false;
  String? _launchPayload;

  Stream<String> get payloadStream => _payloadStream.stream;

  AwesomeNotifications get _notifications =>
      _notificationsOverride ?? AwesomeNotifications();

  Future<void> initialize() async {
    if (_initialized) return;
    if (!_supportsLocalNotifications) {
      _initialized = true;
      return;
    }

    _initializeReceivePort();
    await _initializePlugin();
    await _notifications.setListeners(
      onActionReceivedMethod: onNotificationActionReceived,
    );
    await _requestPermissions();
    await _captureLaunchPayload();

    _initialized = true;
  }

  String? consumeLaunchPayload() {
    final payload = _launchPayload;
    _launchPayload = null;
    return payload;
  }

  Future<void> scheduleUpcomingNotifications(List<Hadith> hadiths) async {
    if (hadiths.isEmpty) return;

    await initialize();
    if (!_supportsLocalNotifications) return;

    await _scheduler.scheduleUpcomingNotifications(hadiths);
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
    required String channelDescription,
    String? payload,
  }) async {
    await initialize();
    if (!_supportsLocalNotifications) return;

    await _ensureChannel(
      channelKey: channelId,
      channelName: channelName,
      channelDescription: channelDescription,
    );

    await _notifications.createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelId,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        payload: _buildPayload(payload),
      ),
    );
  }

  Future<void> _initializePlugin() async {
    await _notifications.initialize(null, [
      NotificationChannel(
        channelKey: HadithOfDayNotificationConstants.channelId,
        channelName: HadithOfDayNotificationConstants.channelName,
        channelDescription: HadithOfDayNotificationConstants.channelDescription,
        importance: NotificationImportance.High,
        defaultColor: _brandNotificationColor,
        ledColor: _brandNotificationColor,
        playSound: true,
        channelShowBadge: true,
      ),
      NotificationChannel(
        channelKey: pushChannelId,
        channelName: pushChannelName,
        channelDescription: pushChannelDescription,
        importance: NotificationImportance.High,
        defaultColor: _brandNotificationColor,
        ledColor: _brandNotificationColor,
        playSound: true,
        channelShowBadge: true,
      ),
    ], debug: false);
  }

  void _initializeReceivePort() {
    IsolateNameServer.removePortNameMapping(portName);
    _receivePort?.close();

    _receivePort = ReceivePort()
      ..listen((serializedAction) {
        if (serializedAction is! Map) return;

        final action = ReceivedAction().fromMap(
          Map<String, dynamic>.from(serializedAction),
        );
        final payload = action.payload?[payloadKey];
        if (payload != null && payload.isNotEmpty) {
          _payloadStream.add(payload);
        }
      });

    IsolateNameServer.registerPortWithName(_receivePort!.sendPort, portName);
  }

  Future<void> _captureLaunchPayload() async {
    final initialAction = await _notifications.getInitialNotificationAction(
      removeFromActionEvents: false,
    );
    final payload = initialAction?.payload?[payloadKey];
    if (payload != null && payload.isNotEmpty) {
      _launchPayload = payload;
    }
  }

  Future<void> _requestPermissions() async {
    final isAllowed = await _notifications.isNotificationAllowed();
    if (isAllowed) return;

    await _notifications.requestPermissionToSendNotifications();
  }

  Future<void> _ensureChannel({
    required String channelKey,
    required String channelName,
    required String channelDescription,
  }) async {
    await _notifications.setChannel(
      NotificationChannel(
        channelKey: channelKey,
        channelName: channelName,
        channelDescription: channelDescription,
        importance: NotificationImportance.High,
        defaultColor: _brandNotificationColor,
        ledColor: _brandNotificationColor,
        playSound: true,
        channelShowBadge: true,
      ),
    );
  }

  Map<String, String?>? _buildPayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    return {payloadKey: payload};
  }

  bool get _supportsLocalNotifications {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }
}

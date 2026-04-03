import 'dart:async';

import 'package:go_router/go_router.dart';

import '../../../../router.dart';
import '../../ahadith/application/hadith_of_day_notification_constants.dart';
import '../../ahadith/application/hadith_of_day_notification_service.dart';
import '../domain/models/app_notification_payload.dart';
import '../domain/models/notification_details_args.dart';
import 'notification_service.dart';

class NotificationRouteHandler {
  NotificationRouteHandler(
    this._localService, {
    PushNotificationService? pushService,
  }) : _pushService = pushService;

  final HadithOfDayNotificationService _localService;
  final PushNotificationService? _pushService;
  final List<StreamSubscription<String>> _subscriptions = [];
  GoRouter? _router;
  String? _pendingPayload;
  bool _isBound = false;

  static const Duration _initialNavigationDelay = Duration(milliseconds: 600);
  static const Duration _retryDelay = Duration(milliseconds: 450);
  static const int _maxNavigationAttempts = 12;

  void bind(GoRouter router) {
    _router = router;

    final pendingPayload = _pendingPayload;
    if (pendingPayload != null && pendingPayload.isNotEmpty) {
      Future<void>.delayed(
        const Duration(milliseconds: 150),
        () => _handlePayload(pendingPayload),
      );
    }

    if (_isBound) return;

    _subscriptions.add(
      _localService.payloadStream.listen((payload) {
        _handlePayload(payload);
      }),
    );

    final pushService = _pushService;
    if (pushService != null) {
      _subscriptions.add(
        pushService.payloadStream.listen((payload) {
          _handlePayload(payload);
        }),
      );
    }

    final initialPayloads = <String?>[
      _localService.consumeLaunchPayload(),
      pushService?.consumeLaunchPayload(),
    ];

    for (final payload in initialPayloads) {
      if (payload != null && payload.isNotEmpty) {
        Future<void>.delayed(
          _initialNavigationDelay,
          () => _handlePayload(payload),
        );
      }
    }

    _isBound = true;
  }

  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
  }

  void _handlePayload(String payload) {
    if (_router == null) return;
    _pendingPayload = payload;

    if (payload == HadithOfDayNotificationConstants.payload) {
      _navigateWithRetry(
        targetPath: '/hadith-of-day',
        action: (router) => router.goNamed(AppRouteNames.hadithOfDay),
      );
      return;
    }

    final notificationPayload = AppNotificationPayload.tryParse(payload);
    final fakeHadithId = notificationPayload?.fakeHadithId;
    if (notificationPayload?.type == AppNotificationPayload.fakeAhadithType &&
        fakeHadithId != null &&
        fakeHadithId.isNotEmpty) {
      _navigateWithRetry(
        targetPath: '/fake-hadith-notification',
        action: (router) => router.goNamed(
          AppRouteNames.fakeHadithNotification,
          queryParameters: {'id': fakeHadithId},
        ),
      );
      return;
    }

    final title = notificationPayload?.title?.trim() ?? '';
    final body = notificationPayload?.body?.trim() ?? '';
    if (notificationPayload?.type ==
            AppNotificationPayload.adminNotificationType &&
        title.isNotEmpty &&
        body.isNotEmpty) {
      final args = NotificationDetailsArgs(title: title, body: body);
      _navigateWithRetry(
        targetPath: '/notification-details',
        action: (router) => router.goNamed(
          AppRouteNames.notificationDetails,
          queryParameters: args.toQueryParameters(),
        ),
      );
      return;
    }

    _clearPendingPayload();
  }

  void _navigateWithRetry({
    required String targetPath,
    required void Function(GoRouter router) action,
    int attemptsLeft = _maxNavigationAttempts,
  }) {
    final router = _router;
    if (router == null) return;

    final currentPath = _currentPath(router);
    if (_shouldWaitForRouter(currentPath)) {
      if (attemptsLeft <= 0) return;
      Future<void>.delayed(
        _retryDelay,
        () => _navigateWithRetry(
          targetPath: targetPath,
          action: action,
          attemptsLeft: attemptsLeft - 1,
        ),
      );
      return;
    }

    action(router);

    if (attemptsLeft <= 0) return;

    Future<void>.delayed(_retryDelay, () {
      final activeRouter = _router;
      if (activeRouter == null) return;

      final activePath = _currentPath(activeRouter);
      if (activePath != targetPath) {
        _navigateWithRetry(
          targetPath: targetPath,
          action: action,
          attemptsLeft: attemptsLeft - 1,
        );
      } else {
        _clearPendingPayloadForTarget(targetPath);
      }
    });
  }

  bool _shouldWaitForRouter(String path) {
    return path == '/splash' || path == '/auth' || path.isEmpty;
  }

  String _currentPath(GoRouter router) {
    try {
      return router.routeInformationProvider.value.uri.path;
    } catch (_) {
      return '';
    }
  }

  void _clearPendingPayload() {
    _pendingPayload = null;
  }

  void _clearPendingPayloadForTarget(String targetPath) {
    final pendingPayload = _pendingPayload;
    if (pendingPayload == null || pendingPayload.isEmpty) {
      return;
    }

    if (_targetPathForPayload(pendingPayload) == targetPath) {
      _pendingPayload = null;
    }
  }

  String? _targetPathForPayload(String payload) {
    if (payload == HadithOfDayNotificationConstants.payload) {
      return '/hadith-of-day';
    }

    final notificationPayload = AppNotificationPayload.tryParse(payload);
    if (notificationPayload?.type == AppNotificationPayload.fakeAhadithType &&
        notificationPayload?.fakeHadithId?.isNotEmpty == true) {
      return '/fake-hadith-notification';
    }

    if (notificationPayload?.type ==
            AppNotificationPayload.adminNotificationType &&
        (notificationPayload?.title?.trim().isNotEmpty ?? false) &&
        (notificationPayload?.body?.trim().isNotEmpty ?? false)) {
      return '/notification-details';
    }

    return null;
  }
}


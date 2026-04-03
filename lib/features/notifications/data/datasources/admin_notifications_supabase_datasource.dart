import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/models/app_notification_payload.dart';
import '../repositories/admin_notifications_repository.dart';

class AdminNotificationsSupabaseDatasource
    implements AdminNotificationsRepository {
  AdminNotificationsSupabaseDatasource({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<void> sendPush({
    required String title,
    required String body,
    String? userId,
  }) async {
    try {
      final response = await _invokeSendPush(
        title: title,
        body: body,
        userId: userId,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      }

      throw AppFailure.storage(
        _extractErrorMessage(response.payload) ?? 'تعذر إرسال الإشعار.',
      );
    } on _SessionExpiredException {
      throw AppFailure.unauthorized(
        'انتهت جلسة الإدارة. سجّل الدخول من جديد ثم أعد المحاولة.',
      );
    } on AppFailure {
      rethrow;
    } on FunctionException catch (error) {
      throw AppFailure.storage(
        'تعذر إرسال الإشعار.',
        details: error.details?.toString() ?? error.reasonPhrase,
      );
    } catch (error) {
      throw AppFailure.network(
        'تعذر إرسال الإشعار.',
        details: error.toString(),
      );
    }
  }

  Future<_SendPushHttpResponse> _invokeSendPush({
    required String title,
    required String body,
    String? userId,
  }) async {
    try {
      final initialResponse = await _invokeSendPushOnce(
        title: title,
        body: body,
        userId: userId,
        forceRefresh: false,
      );
      if (!_isSessionResponse(initialResponse)) {
        return initialResponse;
      }

      final refreshedResponse = await _invokeSendPushOnce(
        title: title,
        body: body,
        userId: userId,
        forceRefresh: true,
      );
      if (_isSessionResponse(refreshedResponse)) {
        throw const _SessionExpiredException();
      }

      return refreshedResponse;
    } catch (error) {
      final message = _extractErrorMessage(error);
      if (!_isSessionError(message)) {
        rethrow;
      }

      final refreshedResponse = await _invokeSendPushOnce(
        title: title,
        body: body,
        userId: userId,
        forceRefresh: true,
      );
      if (_isSessionResponse(refreshedResponse)) {
        throw const _SessionExpiredException();
      }

      return refreshedResponse;
    }
  }

  Future<_SendPushHttpResponse> _invokeSendPushOnce({
    required String title,
    required String body,
    String? userId,
    required bool forceRefresh,
  }) async {
    if (forceRefresh) {
      final refreshed = await _client.auth.refreshSession();
      if (refreshed.session == null && _client.auth.currentSession == null) {
        throw const _SessionExpiredException();
      }
    }

    final session = _client.auth.currentSession;
    final accessToken = session?.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      throw const _SessionExpiredException();
    }

    final payload = {
      'title': title.trim(),
      'body': body.trim(),
      'userId': (userId == null || userId.trim().isEmpty)
          ? null
          : userId.trim(),
      'payload': AppNotificationPayload.admin(
        title: title,
        body: body,
      ).encode(),
    };

    final response = await _client.functions.invoke(
      'send-push',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(payload),
    );

    return _SendPushHttpResponse(
      statusCode: response.status,
      payload: response.data,
    );
  }

  bool _isSessionResponse(_SendPushHttpResponse response) {
    if (response.statusCode != 401) {
      return false;
    }

    return _isSessionError(_extractErrorMessage(response.payload));
  }

  bool _isSessionError(String? message) {
    if (message == null) {
      return false;
    }

    final normalized = message.toLowerCase();
    return normalized.contains('invalid jwt') ||
        normalized.contains('jwt expired') ||
        normalized.contains('refresh token') ||
        normalized.contains('session_not_found') ||
        normalized.contains('missing authorization header') ||
        normalized.contains('unauthorized');
  }

  String? _extractErrorMessage(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is AppFailure) {
      return value.message;
    }

    if (value is AuthException) {
      return value.message;
    }

    if (value is FunctionException) {
      final details = value.details?.toString();
      if (details != null && details.trim().isNotEmpty) {
        return details.trim();
      }
      return value.reasonPhrase;
    }

    if (value is Map) {
      final error = value['error'];
      if (error is String && error.trim().isNotEmpty) {
        return error.trim();
      }

      final message = value['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
    }

    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}

class _SendPushHttpResponse {
  const _SendPushHttpResponse({
    required this.statusCode,
    required this.payload,
  });

  final int statusCode;
  final dynamic payload;
}

class _SessionExpiredException implements Exception {
  const _SessionExpiredException();
}

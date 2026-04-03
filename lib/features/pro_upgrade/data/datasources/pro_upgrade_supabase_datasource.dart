import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/models/pro_upgrade_certificate.dart';
import '../../domain/models/pro_upgrade_decision.dart';
import '../../domain/models/pro_upgrade_request.dart';
import '../repositories/pro_upgrade_repository.dart';

class ProUpgradeSupabaseDatasource implements ProUpgradeRepository {
  final SupabaseClient _client;

  static const String _requestsTable = 'pro_upgrade_requests';
  static const String _certificatesTable = 'pro_upgrade_certificates';
  static const String _decisionsTable = 'pro_upgrade_decisions';
  static const String _bucket = 'scholar-certificates';

  String _resolveContentType(String fileName, String? providedContentType) {
    if (providedContentType != null && providedContentType.trim().isNotEmpty) {
      return providedContentType;
    }

    final lowerName = fileName.toLowerCase();
    if (lowerName.endsWith('.pdf')) return 'application/pdf';
    if (lowerName.endsWith('.jpg') || lowerName.endsWith('.jpeg')) {
      return 'image/jpeg';
    }
    if (lowerName.endsWith('.png')) return 'image/png';
    return 'application/octet-stream';
  }

  ProUpgradeSupabaseDatasource({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  @override
  Future<List<ProUpgradeRequest>> getMyRequests() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return [];

    try {
      final res = await _client
          .from(_requestsTable)
          .select()
          .eq('user_id', uid)
          .order('created_at', ascending: false);

      return (res as List)
          .map((e) => ProUpgradeRequest.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (error) {
      throw AppFailure.network(
        'تعذر تحميل طلبات الترقية.',
        details: error.message,
      );
    } catch (error) {
      throw AppFailure.network(
        'تعذر تحميل طلبات الترقية.',
        details: error.toString(),
      );
    }
  }

  @override
  Future<Map<String, dynamic>> createUpgradeRequest() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw AppFailure.unauthorized('يجب تسجيل الدخول أولًا.');
    }

    try {
      final res = await _client.rpc(
        'create_pro_upgrade_request',
        params: {'p_user_id': uid},
      );

      if (res is! Map<String, dynamic>) {
        throw AppFailure.storage('تعذر إنشاء طلب الترقية.');
      }

      if (res['error'] != null) {
        throw AppFailure.storage(res['error'].toString());
      }

      return res;
    } on AppFailure {
      rethrow;
    } on PostgrestException catch (error) {
      throw AppFailure.storage(
        'تعذر إنشاء طلب الترقية.',
        details: error.message,
      );
    } catch (error) {
      throw AppFailure.storage(
        'تعذر إنشاء طلب الترقية.',
        details: error.toString(),
      );
    }
  }

  @override
  Future<List<ProUpgradeCertificate>> getCertificatesByRequest(
    String requestId,
  ) async {
    try {
      final res = await _client
          .from(_certificatesTable)
          .select()
          .eq('request_id', requestId)
          .order('created_at', ascending: false);

      return (res as List)
          .map((e) => ProUpgradeCertificate.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (error) {
      throw AppFailure.network(
        'تعذر تحميل الوثائق المرفوعة.',
        details: error.message,
      );
    } catch (error) {
      throw AppFailure.network(
        'تعذر تحميل الوثائق المرفوعة.',
        details: error.toString(),
      );
    }
  }

  @override
  Future<String> uploadCertificate({
    required String requestId,
    required String fileName,
    required List<int> bytes,
    String? contentType,
  }) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw AppFailure.unauthorized('يجب تسجيل الدخول أولًا.');
    }

    final sanitizedFileName = fileName
        .trim()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '');
    final safeFileName = sanitizedFileName.isEmpty
        ? 'certificate_${DateTime.now().millisecondsSinceEpoch}.bin'
        : sanitizedFileName;
    final filePath =
        '$uid/$requestId/${DateTime.now().millisecondsSinceEpoch}_$safeFileName';

    try {
      await _client.storage.from(_bucket).uploadBinary(
        filePath,
        Uint8List.fromList(bytes),
        fileOptions: FileOptions(
          upsert: false,
          contentType: _resolveContentType(safeFileName, contentType),
        ),
      );
      return filePath;
    } on StorageException catch (error) {
      throw AppFailure.storage('تعذر رفع الوثيقة.', details: error.message);
    } catch (error) {
      throw AppFailure.storage('تعذر رفع الوثيقة.', details: error.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> submitUpgradeRequestForReview({
    required String requestId,
  }) async {
    if (requestId.trim().isEmpty) {
      throw AppFailure.validation('معرّف الطلب مفقود.');
    }

    try {
      final res = await _client.rpc(
        'submit_pro_upgrade_request',
        params: {'p_request_id': requestId},
      );

      if (res is! Map<String, dynamic>) {
        throw AppFailure.storage('تعذر إرسال الطلب للمراجعة.');
      }

      if (res['error'] != null) {
        throw AppFailure.storage(res['error'].toString());
      }

      return res;
    } on AppFailure {
      rethrow;
    } on PostgrestException catch (error) {
      throw AppFailure.storage(
        'تعذر إرسال الطلب للمراجعة.',
        details: error.message,
      );
    } catch (error) {
      throw AppFailure.storage(
        'تعذر إرسال الطلب للمراجعة.',
        details: error.toString(),
      );
    }
  }

  @override
  Future<String> getCertificateSignedUrl(
    String filePath, {
    int expiresInSeconds = 3600,
  }) async {
    try {
      return _client.storage
          .from(_bucket)
          .createSignedUrl(filePath, expiresInSeconds);
    } on StorageException catch (error) {
      throw AppFailure.storage(
        'تعذر إنشاء رابط الوثيقة.',
        details: error.message,
      );
    } catch (error) {
      throw AppFailure.storage(
        'تعذر إنشاء رابط الوثيقة.',
        details: error.toString(),
      );
    }
  }

  @override
  Future<List<ProUpgradeDecision>> getMyDecisions() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return [];

    try {
      final res = await _client
          .from(_decisionsTable)
          .select()
          .eq('user_id', uid)
          .order('created_at', ascending: false);

      return (res as List)
          .map((e) => ProUpgradeDecision.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (error) {
      throw AppFailure.network(
        'تعذر تحميل قرارات الترقية.',
        details: error.message,
      );
    } catch (error) {
      throw AppFailure.network(
        'تعذر تحميل قرارات الترقية.',
        details: error.toString(),
      );
    }
  }
}

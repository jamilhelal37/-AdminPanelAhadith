import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../repositories/admin_pro_upgrade_repository.dart';

class AdminProUpgradeSupabaseDatasource implements AdminProUpgradeRepository {
  AdminProUpgradeSupabaseDatasource({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const String _requestsTable = 'pro_upgrade_requests';
  static const String _certificatesTable = 'pro_upgrade_certificates';
  static const String _decisionsTable = 'pro_upgrade_decisions';
  static const String _usersTable = 'app_user';
  static const String _bucket = 'scholar-certificates';

  @override
  Future<List<AdminProRequestView>> getRequests() async {
    try {
      final requestsResponse = await _client
          .from(_requestsTable)
          .select(
            'id, user_id, status, created_at, '
            'certificates:$_certificatesTable(id, file_path, created_at), '
            'decisions:$_decisionsTable(id, approved, notes, created_at)',
          )
          .order('created_at', ascending: false);

      final rawRows = (requestsResponse as List)
          .cast<Map>()
          .map((entry) => entry.cast<String, dynamic>())
          .toList();

      final userIds = rawRows
          .map((row) => (row['user_id'] ?? '').toString())
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      final usersById = <String, Map<String, dynamic>>{};
      if (userIds.isNotEmpty) {
        final usersResponse = await _client
            .from(_usersTable)
            .select('id, name, email, avatar_url')
            .inFilter('id', userIds);

        for (final raw in (usersResponse as List).cast<Map>()) {
          final map = raw.cast<String, dynamic>();
          usersById[(map['id'] ?? '').toString()] = map;
        }
      }

      return rawRows.map((row) {
        final userId = (row['user_id'] ?? '').toString();
        final user = usersById[userId];

        return AdminProRequestView(
          requestId: (row['id'] ?? '').toString(),
          userId: userId,
          status: (row['status'] ?? '').toString(),
          createdAt: (row['created_at'] ?? '').toString(),
          userName: (user?['name'] ?? '').toString(),
          userEmail: (user?['email'] ?? '').toString(),
          certificates: _parseCertificates(row['certificates']),
          decision: _parseDecision(row['decisions']),
        );
      }).toList();
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
  Future<void> submitDecision({
    required String requestId,
    required String userId,
    required bool approved,
    String? notes,
  }) async {
    if (requestId.trim().isEmpty || userId.trim().isEmpty) {
      throw AppFailure.validation('بيانات القرار غير مكتملة.');
    }

    final adminId = _client.auth.currentUser?.id;

    try {
      await _client.from(_decisionsTable).upsert({
        'request_id': requestId,
        'user_id': userId,
        'approved': approved,
        'reviewed_by': adminId,
        'notes': (notes == null || notes.trim().isEmpty) ? null : notes.trim(),
      });

      if (approved) {
        await _client
            .from(_usersTable)
            .update({'type': 'scholar'})
            .eq('id', userId);
      }

      await _client
          .from(_requestsTable)
          .update({'status': 'reviewed'})
          .eq('id', requestId);
    } on PostgrestException catch (error) {
      throw AppFailure.storage(
        'تعذر حفظ قرار الترقية.',
        details: error.message,
      );
    } catch (error) {
      throw AppFailure.storage(
        'تعذر حفظ قرار الترقية.',
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

  List<AdminProCertificateAttachment> _parseCertificates(dynamic raw) {
    if (raw is! List) {
      return const [];
    }

    return raw
        .whereType<Map>()
        .map((entry) {
          final map = entry.cast<String, dynamic>();
          return AdminProCertificateAttachment(
            filePath: (map['file_path'] ?? '').toString(),
            createdAt: (map['created_at'] ?? '').toString(),
          );
        })
        .where((certificate) => certificate.filePath.isNotEmpty)
        .toList();
  }

  AdminProDecisionView? _parseDecision(dynamic raw) {
    if (raw is! List || raw.isEmpty) {
      return null;
    }

    final first = raw.first;
    if (first is! Map) {
      return null;
    }

    final map = first.cast<String, dynamic>();
    return AdminProDecisionView(
      approved: map['approved'] == true,
      notes: (map['notes'] ?? '').toString(),
      createdAt: (map['created_at'] ?? '').toString(),
    );
  }
}

import 'package:ahadith/core/presentation/widgets/core_actions_widget.dart';
import 'package:ahadith/core/presentation/widgets/golden_drawer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../auth/domain/models/app_user.dart';
import '../../../auth/presentation/providers/auth_notifier_provider.dart';
import '../../data/repositories/pro_upgrade_repository_provider.dart';
import '../../domain/models/pro_upgrade_request.dart';
import '../../domain/models/pro_upgrade_view_state.dart';
import '../providers/pro_upgrade_future_providers.dart';
import '../widgets/pro_upgrade_section_widgets.dart';

class ProUpgradeScreen extends ConsumerStatefulWidget {
  const ProUpgradeScreen({super.key});

  @override
  ConsumerState<ProUpgradeScreen> createState() => _ProUpgradeScreenState();
}

class _ProUpgradeScreenState extends ConsumerState<ProUpgradeScreen> {
  bool _isCreatingRequest = false;
  bool _isUploading = false;
  bool _isSubmittingRequest = false;
  bool _didBootstrapInitialRequest = false;
  String? _activeRequestId;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authNotifierProvider).valueOrNull;
    final requestsAsync = ref.watch(myProUpgradeRequestsProvider);
    final decisionsAsync = ref.watch(myProUpgradeDecisionsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      endDrawer: const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
        actions: const [CoreActionsWidget()],
        title: const Text('طلب الترقية إلى عالم'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: currentUser != null && currentUser.type != UserType.member
            ? _buildLoadError(
                context,
                message:
                    'هذه الواجهة متاحة فقط للحسابات من نوع عضو. حدّث نوع الحساب في جدول app_user إلى member قبل رفع وثائق الترقية.',
              )
            : requestsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => _buildLoadError(
                  context,
                  message: 'تعذر تحميل طلبات الترقية.\n$error',
                ),
                data: (requests) {
                  return decisionsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => _buildLoadError(
                      context,
                      message: 'تعذر تحميل حالة المراجعة.\n$error',
                    ),
                    data: (decisions) {
                      _bootstrapRequestIfNeeded(requests);

                      final viewState = ProUpgradeViewState.resolve(
                        requests: requests,
                        decisions: decisions,
                        activeRequestId: _activeRequestId,
                      );
                      _syncActiveRequestId(viewState.resolvedRequestId);

                      final activeRequest = viewState.activeRequest;
                      final requestId = viewState.resolvedRequestId;
                      final certificatesAsync = requestId == null
                          ? null
                          : ref.watch(requestCertificatesProvider(requestId));

                      return ListView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        children: [
                          ProUpgradeDecisionCard(
                            state: viewState,
                            isCreatingRequest: _isCreatingRequest,
                          ),
                          const SizedBox(height: 16),
                          ProUpgradeProgressCard(
                            state: viewState,
                            isCreatingRequest: _isCreatingRequest,
                          ),
                          if (activeRequest != null) ...[
                            const SizedBox(height: 16),
                            ProUpgradeCertificatesCard(
                              request: activeRequest,
                              certificatesAsync: certificatesAsync!,
                              isUploading: _isUploading,
                              isSubmittingRequest: _isSubmittingRequest,
                              onUpload:
                                  !_isUploading &&
                                      activeRequest.status ==
                                          'pending_documents'
                                  ? () => _pickAndUploadCertificate(requestId!)
                                  : null,
                              onSubmit:
                                  !_isSubmittingRequest &&
                                      activeRequest.status ==
                                          'pending_documents'
                                  ? () => _submitRequestForReview(requestId!)
                                  : null,
                            ),
                          ],
                          if (viewState.canRetryRejectedRequest) ...[
                            const SizedBox(height: 16),
                            ProUpgradeRetryRequestCard(
                              isCreatingRequest: _isCreatingRequest,
                              onRetry: _isCreatingRequest
                                  ? null
                                  : _handleCreateRequest,
                            ),
                          ],
                        ],
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  void _syncActiveRequestId(String? requestId) {
    if (requestId == null || requestId == _activeRequestId) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _activeRequestId == requestId) return;
      setState(() => _activeRequestId = requestId);
    });
  }

  void _bootstrapRequestIfNeeded(List<ProUpgradeRequest> requests) {
    if (_didBootstrapInitialRequest ||
        requests.isNotEmpty ||
        _isCreatingRequest) {
      return;
    }

    _didBootstrapInitialRequest = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _handleCreateRequest(showSnackBar: false);
    });
  }

  Future<void> _handleCreateRequest({bool showSnackBar = true}) async {
    if (_isCreatingRequest) return;

    setState(() => _isCreatingRequest = true);
    try {
      final repo = ref.read(proUpgradeRepositoryProvider);
      final created = await repo.createUpgradeRequest();
      final requestId = created['request_id']?.toString();

      if (requestId == null || requestId.isEmpty) {
        throw AppFailure.storage(
          created['message']?.toString() ?? 'تعذر إنشاء الطلب.',
        );
      }

      if (!mounted) return;

      setState(() => _activeRequestId = requestId);
      ref.invalidate(myProUpgradeRequestsProvider);
      ref.invalidate(myProUpgradeDecisionsProvider);
      ref.invalidate(requestCertificatesProvider(requestId));

      if (showSnackBar) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              created['message']?.toString() ??
                  'تم تجهيز طلب الترقية. يمكنك الآن رفع الوثائق.',
            ),
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر إنشاء طلب الترقية: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isCreatingRequest = false);
      }
    }
  }

  Future<void> _pickAndUploadCertificate(String requestId) async {
    if (_isUploading) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final extension = (file.extension ?? '').toLowerCase();
    const allowedExtensions = {'pdf', 'jpg', 'jpeg', 'png'};
    if (!allowedExtensions.contains(extension)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'صيغة الملف غير مدعومة. المسموح: PDF, JPG, JPEG, PNG',
          ),
        ),
      );
      return;
    }

    const maxFileSizeBytes = 10 * 1024 * 1024;
    if (file.size > maxFileSizeBytes) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حجم الملف أكبر من الحد المسموح (10MB).'),
        ),
      );
      return;
    }

    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر قراءة الملف المحدد.')),
      );
      return;
    }

    setState(() => _isUploading = true);
    try {
      final repo = ref.read(proUpgradeRepositoryProvider);
      final fileName = file.name.trim().isEmpty
          ? 'certificate_${DateTime.now().millisecondsSinceEpoch}.pdf'
          : file.name;

      final contentType = switch (extension) {
        'pdf' => 'application/pdf',
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        _ => 'application/octet-stream',
      };

      await repo.uploadCertificate(
        requestId: requestId,
        fileName: fileName,
        bytes: bytes,
        contentType: contentType,
      );

      if (!mounted) return;

      ref.invalidate(requestCertificatesProvider(requestId));
      ref.invalidate(myProUpgradeRequestsProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم رفع الوثيقة بنجاح')));
    } on AppFailure catch (error) {
      if (!mounted) return;
      final details = error.details?.toString();
      final message = (details == null || details.isEmpty)
          ? error.message
          : '${error.message}\n$details';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل رفع الوثيقة: $message')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل رفع الوثيقة: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _submitRequestForReview(String requestId) async {
    if (_isSubmittingRequest) return;

    setState(() => _isSubmittingRequest = true);
    try {
      final repo = ref.read(proUpgradeRepositoryProvider);
      final result = await repo.submitUpgradeRequestForReview(
        requestId: requestId,
      );

      if (!mounted) return;

      ref.invalidate(myProUpgradeRequestsProvider);
      ref.invalidate(myProUpgradeDecisionsProvider);
      ref.invalidate(requestCertificatesProvider(requestId));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message']?.toString() ?? 'تم إرسال الطلب للمراجعة بنجاح',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر إرسال الطلب للمراجعة: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmittingRequest = false);
      }
    }
  }

  Widget _buildLoadError(BuildContext context, {required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, height: 1.5),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

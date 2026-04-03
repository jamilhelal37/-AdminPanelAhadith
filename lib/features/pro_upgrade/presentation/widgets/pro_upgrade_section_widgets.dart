import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/pro_upgrade_certificate.dart';
import '../../domain/models/pro_upgrade_request.dart';
import '../../domain/models/pro_upgrade_view_state.dart';

String _withColon(String value) {
  final trimmed = value.trimRight();
  return trimmed.endsWith(':') ? trimmed : '$trimmed:';
}

class ProUpgradeProgressCard extends StatelessWidget {
  const ProUpgradeProgressCard({
    super.key,
    required this.state,
    required this.isCreatingRequest,
  });

  final ProUpgradeViewState state;
  final bool isCreatingRequest;

  @override
  Widget build(BuildContext context) {
    final request = state.activeRequest;
    final isUnderReview = request?.status == 'under_review';
    final isReviewed = request?.status == 'reviewed';

    return _SectionCard(
      title: 'مراحل الطلب',
      icon: Icons.timeline_rounded,
      child: Column(
        children: [
          _ProgressStepTile(
            title: 'رفع الوثائق',
            subtitle:
                'ارفع الوثائق المطلوبة بصيغة PDF أو كصور واضحة حتى يبدأ تجهيز طلبك للمراجعة.',
            stepNumber: 1,
            state: isUnderReview || isReviewed
                ? _ProgressState.completed
                : _ProgressState.current,
          ),
          const _InnerDivider(),
          _ProgressStepTile(
            title: 'انتظار مراجعة المشرف',
            subtitle:
                'المشرف العام يراجع الوثائق التي رفعتها ويتأكد من صحتها ومطابقتها لشروط الترقية.',
            stepNumber: 2,
            state: isReviewed
                ? _ProgressState.completed
                : isUnderReview
                ? _ProgressState.current
                : _ProgressState.upcoming,
          ),
        ],
      ),
    );
  }
}

class ProUpgradeCertificatesCard extends StatelessWidget {
  const ProUpgradeCertificatesCard({
    super.key,
    required this.request,
    required this.certificatesAsync,
    required this.isUploading,
    required this.isSubmittingRequest,
    required this.onUpload,
    required this.onSubmit,
  });

  final ProUpgradeRequest request;
  final AsyncValue<List<ProUpgradeCertificate>> certificatesAsync;
  final bool isUploading;
  final bool isSubmittingRequest;
  final VoidCallback? onUpload;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final isPendingDocuments = request.status == 'pending_documents';

    return _SectionCard(
      title: 'الوثائق المرفوعة',
      icon: Icons.file_present_outlined,
      child: certificatesAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Text(
          'تعذر تحميل الوثائق: $error',
          style: const TextStyle(fontSize: 14),
        ),
        data: (certificates) {
          final hasCertificates = certificates.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                hasCertificates
                    ? 'تم رفع ${certificates.length} وثيقة حتى الآن.'
                    : 'لم يتم رفع أي وثيقة بعد.',
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              if (hasCertificates) ...[
                const SizedBox(height: 12),
                ...certificates.map(
                  (certificate) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _CertificateTile(
                      fileName: ProUpgradeViewState.extractFileName(
                        certificate.filePath,
                      ),
                      createdAt: ProUpgradeViewState.formatDate(
                        certificate.createdAt,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _ActionPillButton(
                    label: hasCertificates ? 'رفع وثيقة إضافية' : 'رفع وثيقة',
                    icon: Icons.upload_file_outlined,
                    onTap: isPendingDocuments ? onUpload : null,
                    isLoading: isUploading,
                  ),
                  _ActionPillButton(
                    label: 'إرسال للمراجعة',
                    icon: Icons.send_rounded,
                    onTap: isPendingDocuments && hasCertificates
                        ? onSubmit
                        : null,
                    isLoading: isSubmittingRequest,
                  ),
                ],
              ),
              if (isPendingDocuments) ...[
                const SizedBox(height: 12),
                const Text(
                  'بعد رفع الوثائق كاملة اضغط على إرسال للمراجعة.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class ProUpgradeDecisionCard extends StatelessWidget {
  const ProUpgradeDecisionCard({
    super.key,
    required this.state,
    required this.isCreatingRequest,
  });

  final ProUpgradeViewState state;
  final bool isCreatingRequest;

  @override
  Widget build(BuildContext context) {
    final request = state.activeRequest;
    final decision = state.currentDecision;

    if (request == null) {
      return _SectionCard(
        title: 'الخطوة الحالية',
        icon: Icons.hourglass_top_rounded,
        child: Text(
          isCreatingRequest
              ? 'جارٍ تجهيز طلب الترقية لك الآن...'
              : 'سيتم إنشاء طلب الترقية عند فتح هذه الصفحة لأول مرة.',
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      );
    }

    if (request.status == 'pending_documents') {
      return _SectionCard(
        title: 'المطلوب لترقية الحساب',
        icon: Icons.assignment_outlined,
        child: const Text(
          'ارفع الوثائق المطلوبة في هذه المرحلة حتى يتمكن المشرف من مراجعة الطلب والانتقال به إلى المرحلة التالية.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      );
    }

    if (request.status == 'under_review') {
      return _SectionCard(
        title: 'بانتظار المراجعة',
        icon: Icons.pending_actions_outlined,
        child: const Text(
          'تم إرسال طلبك بنجاح، وهو الآن بانتظار مراجعة المشرف. عند صدور القرار سيظهر هنا مباشرة.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      );
    }

    final approved = decision?.approved == true;
    final decisionText = approved
        ? 'تمت الموافقة على طلب الترقية الخاص بك.'
        : 'تمت مراجعة الطلب، ولم تتم الموافقة عليه حاليًا.';

    return _SectionCard(
      title: approved ? 'نتيجة المراجعة' : 'قرار المشرف',
      icon: approved ? Icons.verified_outlined : Icons.rule_folder_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            decisionText,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          if ((decision?.notes ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'ملاحظات المشرف:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    decision!.notes!.trim(),
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ProUpgradeRetryRequestCard extends StatelessWidget {
  const ProUpgradeRetryRequestCard({
    super.key,
    required this.isCreatingRequest,
    required this.onRetry,
  });

  final bool isCreatingRequest;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'إعادة الطلب',
      icon: Icons.restart_alt_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'تم رفض الطلب الحالي. يمكنك إنشاء طلب جديد بعد رفع الوثائق من المرحلة الأولى.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: _ActionPillButton(
              label: 'إعادة الطلب',
              icon: Icons.replay_rounded,
              onTap: onRetry,
              isLoading: isCreatingRequest,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _withColon(title),
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ProgressStepTile extends StatelessWidget {
  const _ProgressStepTile({
    required this.title,
    required this.subtitle,
    required this.stepNumber,
    required this.state,
  });

  final String title;
  final String subtitle;
  final int stepNumber;
  final _ProgressState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = state == _ProgressState.completed;
    final isCurrent = state == _ProgressState.current;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted || isCurrent
                ? colorScheme.primary.withValues(alpha: 0.14)
                : colorScheme.surfaceContainerHighest,
            border: Border.all(
              color: isCompleted || isCurrent
                  ? colorScheme.primary.withValues(alpha: 0.3)
                  : colorScheme.outlineVariant,
            ),
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: colorScheme.primary,
                  )
                : Text(
                    '$stepNumber',
                    style: const TextStyle(fontSize: 14),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _withColon(title),
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionPillButton extends StatelessWidget {
  const _ActionPillButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isLoading = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: enabled
                ? colorScheme.primary.withValues(alpha: 0.12)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
            border: Border.all(
              color: enabled
                  ? colorScheme.primary.withValues(alpha: 0.16)
                  : colorScheme.outlineVariant.withValues(alpha: 0.8),
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                )
              else
                Icon(
                  icon,
                  color: enabled
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CertificateTile extends StatelessWidget {
  const _CertificateTile({required this.fileName, required this.createdAt});

  final String fileName;
  final String createdAt;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outline, width: 1),
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withValues(alpha: 0.12),
            ),
            child: Icon(
              Icons.description_outlined,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 4),
                Text(createdAt, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InnerDivider extends StatelessWidget {
  const _InnerDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        height: 1,
        color: Theme.of(
          context,
        ).colorScheme.outlineVariant.withValues(alpha: 0.6),
      ),
    );
  }
}

enum _ProgressState { completed, current, upcoming }

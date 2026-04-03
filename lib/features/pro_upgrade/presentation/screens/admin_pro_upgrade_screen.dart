import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/repositories/admin_metrics_repository.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/presentation/providers/admin_table_count_provider.dart';
import '../../../../core/presentation/widgets/admin_pagination.dart';
import '../../../../core/presentation/widgets/unified_state_widgets.dart';
import '../../../auth/presentation/providers/admin_users_provider.dart';
import '../../../auth/presentation/providers/auth_notifier_provider.dart';
import '../../data/repositories/admin_pro_upgrade_repository_provider.dart';
import '../providers/admin_pro_upgrade_requests_provider.dart';
import '../widgets/admin_pro_requests_datagrid.dart';
import '../widgets/admin_pro_upgrade_sections.dart';

enum _AdminProRequestsFilter { all, accepted, rejected, undecided, decided }

class AdminProUpgradeScreen extends ConsumerStatefulWidget {
  const AdminProUpgradeScreen({super.key});

  @override
  ConsumerState<AdminProUpgradeScreen> createState() =>
      _AdminProUpgradeScreenState();
}

class _AdminProUpgradeScreenState extends ConsumerState<AdminProUpgradeScreen> {
  String? _busyRequestId;
  _AdminProRequestsFilter _activeFilter = _AdminProRequestsFilter.all;

  Future<String?> _askNotes(String title) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'أضف ملاحظة اختيارية لهذا القرار',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('تأكيد'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return result;
  }

  Future<void> _submitDecision(
    AdminProRequestView request, {
    required bool approved,
  }) async {
    final notes = await _askNotes(approved ? 'ترقية المستخدم' : 'رفض الطلب');
    if (notes == null) {
      return;
    }

    setState(() {
      _busyRequestId = request.requestId;
    });

    try {
      final repo = ref.read(adminProUpgradeRepositoryProvider);
      await repo.submitDecision(
        requestId: request.requestId,
        userId: request.userId,
        approved: approved,
        notes: notes,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            approved ? 'تمت ترقية المستخدم بنجاح.' : 'تم رفض الطلب بنجاح.',
          ),
        ),
      );
      ref.invalidate(adminProUpgradeRequestsProvider);
      ref.invalidate(
        adminTableCountProvider(AdminCountTarget.proUpgradeRequests),
      );
      ref.invalidate(
        adminTableCountProvider(AdminCountTarget.proUpgradeDecisions),
      );
      ref.invalidate(adminUsersProvider);
      ref.invalidate(authNotifierProvider);
    } on AppFailure catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تعذر إرسال القرار: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _busyRequestId = null;
        });
      }
    }
  }

  Future<void> _showDocuments(AdminProRequestView request) async {
    if (request.certificates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد وثائق مرفوعة لهذا الطلب.')),
      );
      return;
    }

    final repo = ref.read(adminProUpgradeRepositoryProvider);
    final previews = <AdminProDocumentPreview>[];
    for (final certificate in request.certificates) {
      final signedUrl = await repo.getCertificateSignedUrl(
        certificate.filePath,
      );
      previews.add(
        AdminProDocumentPreview(
          fileName: certificate.fileName,
          createdAt: shortDate(certificate.createdAt),
          signedUrl: signedUrl,
          isImage: certificate.isImage,
        ),
      );
    }

    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) =>
          AdminProDocumentsDialog(request: request, previews: previews),
    );
  }

  bool _matchesFilter(AdminProRequestView request) {
    switch (_activeFilter) {
      case _AdminProRequestsFilter.all:
        return true;
      case _AdminProRequestsFilter.accepted:
        return request.isApproved;
      case _AdminProRequestsFilter.rejected:
        return request.isRejected;
      case _AdminProRequestsFilter.undecided:
        return request.isPendingDecision;
      case _AdminProRequestsFilter.decided:
        return request.hasDecision;
    }
  }

  DateTime _parseDate(String value) {
    return DateTime.tryParse(value) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  List<AdminProRequestView> _filterAndSortRows(List<AdminProRequestView> rows) {
    final filtered = rows.where(_matchesFilter).toList();

    filtered.sort((a, b) {
      if (a.hasDecision != b.hasDecision) {
        return a.hasDecision ? 1 : -1;
      }

      final aDate = _parseDate(a.decision?.createdAt ?? a.createdAt);
      final bDate = _parseDate(b.decision?.createdAt ?? b.createdAt);
      return bDate.compareTo(aDate);
    });

    return filtered;
  }

  int _countForFilter(
    List<AdminProRequestView> rows,
    _AdminProRequestsFilter filter,
  ) {
    switch (filter) {
      case _AdminProRequestsFilter.all:
        return rows.length;
      case _AdminProRequestsFilter.accepted:
        return rows.where((row) => row.isApproved).length;
      case _AdminProRequestsFilter.rejected:
        return rows.where((row) => row.isRejected).length;
      case _AdminProRequestsFilter.undecided:
        return rows.where((row) => row.isPendingDecision).length;
      case _AdminProRequestsFilter.decided:
        return rows.where((row) => row.hasDecision).length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(adminProUpgradeRequestsProvider);

    return Material(
      color: Colors.transparent,
      child: requestsAsync.when(
        data: (rows) => ListView(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
          children: [
            _SectionCard(
              child: rows.isEmpty
                  ? const AdminProEmptyState(
                      title: 'لا توجد طلبات حاليًا',
                      subtitle: 'بمجرد وصول أول طلب ترقية سيظهر هنا للمراجعة.',
                    )
                  : _RequestsContent(
                      rows: rows,
                      activeFilter: _activeFilter,
                      busyRequestId: _busyRequestId,
                      filterRows: _filterAndSortRows(rows),
                      acceptedCount: _countForFilter(
                        rows,
                        _AdminProRequestsFilter.accepted,
                      ),
                      rejectedCount: _countForFilter(
                        rows,
                        _AdminProRequestsFilter.rejected,
                      ),
                      undecidedCount: _countForFilter(
                        rows,
                        _AdminProRequestsFilter.undecided,
                      ),
                      decidedCount: _countForFilter(
                        rows,
                        _AdminProRequestsFilter.decided,
                      ),
                      onFilterChanged: (filter) {
                        setState(() {
                          _activeFilter = filter;
                        });
                      },
                      onViewDocuments: _showDocuments,
                      onApprove: (request) =>
                          _submitDecision(request, approved: true),
                      onReject: (request) =>
                          _submitDecision(request, approved: false),
                    ),
            ),
          ],
        ),
        loading: () => const UnifiedLoadingState(),
        error: (error, stackTrace) => ListView(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
          children: [
            _SectionCard(
              child: AdminProEmptyState(
                title: 'تعذر تحميل الطلبات',
                subtitle: error.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestsContent extends StatelessWidget {
  const _RequestsContent({
    required this.rows,
    required this.filterRows,
    required this.activeFilter,
    required this.busyRequestId,
    required this.acceptedCount,
    required this.rejectedCount,
    required this.undecidedCount,
    required this.decidedCount,
    required this.onFilterChanged,
    required this.onViewDocuments,
    required this.onApprove,
    required this.onReject,
  });

  final List<AdminProRequestView> rows;
  final List<AdminProRequestView> filterRows;
  final _AdminProRequestsFilter activeFilter;
  final String? busyRequestId;
  final int acceptedCount;
  final int rejectedCount;
  final int undecidedCount;
  final int decidedCount;
  final ValueChanged<_AdminProRequestsFilter> onFilterChanged;
  final ValueChanged<AdminProRequestView> onViewDocuments;
  final ValueChanged<AdminProRequestView> onApprove;
  final ValueChanged<AdminProRequestView> onReject;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RequestsOverviewHeader(
          totalCount: rows.length,
          activeFilter: activeFilter,
          acceptedCount: acceptedCount,
          rejectedCount: rejectedCount,
          undecidedCount: undecidedCount,
          decidedCount: decidedCount,
          onFilterChanged: onFilterChanged,
        ),
        const SizedBox(height: 12),
        if (filterRows.isEmpty)
          const AdminProEmptyState(
            title: 'لا توجد نتائج ضمن هذا التصنيف',
            subtitle: 'جرّب تغيير الفلتر لعرض بقية طلبات الترقية.',
          )
        else
          AdminPaginatedDataView<AdminProRequestView>(
            items: filterRows,
            stateKey: activeFilter.name,
            expandBody: false,
            itemBuilder: (context, pageItems) => AdminProRequestsDataGrid(
              rows: pageItems,
              busyRequestId: busyRequestId,
              onViewDocuments: onViewDocuments,
              onApprove: onApprove,
              onReject: onReject,
            ),
          ),
      ],
    );
  }
}

class _RequestsOverviewHeader extends StatelessWidget {
  const _RequestsOverviewHeader({
    required this.totalCount,
    required this.activeFilter,
    required this.acceptedCount,
    required this.rejectedCount,
    required this.undecidedCount,
    required this.decidedCount,
    required this.onFilterChanged,
  });

  final int totalCount;
  final _AdminProRequestsFilter activeFilter;
  final int acceptedCount;
  final int rejectedCount;
  final int undecidedCount;
  final int decidedCount;
  final ValueChanged<_AdminProRequestsFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _FilterChip(
          label: 'الجميع',
          count: totalCount,
          selected: activeFilter == _AdminProRequestsFilter.all,
          onTap: () => onFilterChanged(_AdminProRequestsFilter.all),
        ),
        _FilterChip(
          label: 'المقبولة',
          count: acceptedCount,
          selected: activeFilter == _AdminProRequestsFilter.accepted,
          onTap: () => onFilterChanged(_AdminProRequestsFilter.accepted),
        ),
        _FilterChip(
          label: 'المرفوضة',
          count: rejectedCount,
          selected: activeFilter == _AdminProRequestsFilter.rejected,
          onTap: () => onFilterChanged(_AdminProRequestsFilter.rejected),
        ),
        _FilterChip(
          label: 'لم يتخذ قرار بعد',
          count: undecidedCount,
          selected: activeFilter == _AdminProRequestsFilter.undecided,
          onTap: () => onFilterChanged(_AdminProRequestsFilter.undecided),
        ),
        _FilterChip(
          label: 'تم اتخاذ قرار',
          count: decidedCount,
          selected: activeFilter == _AdminProRequestsFilter.decided,
          onTap: () => onFilterChanged(_AdminProRequestsFilter.decided),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? Color.alphaBlend(
                  cs.primary.withValues(alpha: 0.1),
                  cs.primaryContainer.withValues(alpha: 0.45),
                )
              : cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? cs.primary.withValues(alpha: 0.22)
                : cs.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: selected ? cs.primary : cs.onSurfaceVariant,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: selected
                    ? cs.primary.withValues(alpha: 0.14)
                    : cs.surface,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: selected ? cs.primary : cs.onSurface,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

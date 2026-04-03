import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/presentation/widgets/admin_data_grid.dart';
import '../providers/admin_pro_upgrade_requests_provider.dart';

class AdminProRequestsDataGrid extends StatelessWidget {
  const AdminProRequestsDataGrid({
    super.key,
    required this.rows,
    required this.busyRequestId,
    required this.onViewDocuments,
    required this.onApprove,
    required this.onReject,
  });

  final List<AdminProRequestView> rows;
  final String? busyRequestId;
  final ValueChanged<AdminProRequestView> onViewDocuments;
  final ValueChanged<AdminProRequestView> onApprove;
  final ValueChanged<AdminProRequestView> onReject;

  @override
  Widget build(BuildContext context) {
    final source = _AdminProRequestsGridSource(
      context: context,
      requests: rows,
      busyRequestId: busyRequestId,
      onViewDocuments: onViewDocuments,
      onApprove: onApprove,
      onReject: onReject,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final widths = _AdminProRequestsColumnWidths.fromWidth(availableWidth);

        return AdminDataGrid(
          source: source,
          rowHeight: 88,
          headerRowHeight: 44,
          columnWidthMode: ColumnWidthMode.none,
          columns: [
            GridColumn(
              columnName: 'user',
              width: widths.user,
              label: const AdminGridHeaderCell(
                'المستخدم',
                alignment: Alignment.centerRight,
              ),
            ),
            GridColumn(
              columnName: 'status',
              width: widths.status,
              label: const AdminGridHeaderCell('الحالة'),
            ),
            GridColumn(
              columnName: 'documents',
              width: widths.documents,
              label: const AdminGridHeaderCell('الوثائق'),
            ),
            GridColumn(
              columnName: 'decision',
              width: widths.decision,
              label: const AdminGridHeaderCell('القرار'),
            ),
            GridColumn(
              columnName: 'createdAt',
              width: widths.createdAt,
              label: const AdminGridHeaderCell('تاريخ الإنشاء'),
            ),
            GridColumn(
              columnName: 'actions',
              width: widths.actions,
              label: const AdminGridHeaderCell('الإجراءات'),
            ),
          ],
        );
      },
    );
  }
}

class _AdminProRequestsColumnWidths {
  const _AdminProRequestsColumnWidths({
    required this.user,
    required this.status,
    required this.documents,
    required this.decision,
    required this.createdAt,
    required this.actions,
  });

  factory _AdminProRequestsColumnWidths.fromWidth(double width) {
    final usableWidth = width > 0 ? width : 1180.0;
    return _AdminProRequestsColumnWidths(
      user: usableWidth * 0.27,
      status: usableWidth * 0.14,
      documents: usableWidth * 0.11,
      decision: usableWidth * 0.15,
      createdAt: usableWidth * 0.11,
      actions: usableWidth * 0.22,
    );
  }

  final double user;
  final double status;
  final double documents;
  final double decision;
  final double createdAt;
  final double actions;
}

class _AdminProRequestsGridSource extends DataGridSource {
  _AdminProRequestsGridSource({
    required this.context,
    required this.requests,
    required this.busyRequestId,
    required this.onViewDocuments,
    required this.onApprove,
    required this.onReject,
  }) : _rows = requests
           .map(
             (request) => DataGridRow(
               cells: [
                 DataGridCell<String>(
                   columnName: 'user',
                   value: request.displayName,
                 ),
                 DataGridCell<String>(
                   columnName: 'status',
                   value: request.status,
                 ),
                 DataGridCell<int>(
                   columnName: 'documents',
                   value: request.certificates.length,
                 ),
                 DataGridCell<String>(
                   columnName: 'decision',
                   value: request.isApproved
                       ? 'accepted'
                       : request.isRejected
                       ? 'rejected'
                       : 'pending',
                 ),
                 DataGridCell<String>(
                   columnName: 'createdAt',
                   value: request.createdAt,
                 ),
                 const DataGridCell<String>(columnName: 'actions', value: ''),
               ],
             ),
           )
           .toList();

  final BuildContext context;
  final List<AdminProRequestView> requests;
  final String? busyRequestId;
  final ValueChanged<AdminProRequestView> onViewDocuments;
  final ValueChanged<AdminProRequestView> onApprove;
  final ValueChanged<AdminProRequestView> onReject;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cs = Theme.of(context).colorScheme;
    final index = _rows.indexOf(row);
    final request = requests[index];
    final busy = busyRequestId == request.requestId;

    return DataGridRowAdapter(
      color: index.isEven ? cs.surface : cs.surface.withValues(alpha: 0.52),
      cells: [
        _GridCell(child: _UserSummary(request: request)),
        _GridCell(
          alignment: Alignment.center,
          child: _StatusBadge(status: request.status),
        ),
        _GridCell(
          alignment: Alignment.center,
          child: _DocumentsSummary(
            request: request,
            onPressed: () => onViewDocuments(request),
          ),
        ),
        _GridCell(
          alignment: Alignment.center,
          child: _DecisionBadge(
            approved: request.isApproved,
            hasDecision: request.hasDecision,
          ),
        ),
        _GridCell(
          alignment: Alignment.center,
          child: Text(
            _shortDateOnly(request.createdAt),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
            ),
          ),
        ),
        _GridCell(
          alignment: Alignment.center,
          child: SizedBox(
            width: double.infinity,
            child: Center(
              child: _ActionButtons(
                busy: busy,
                canReview:
                    request.status == 'under_review' && !request.hasDecision,
                onApprove: () => onApprove(request),
                onReject: () => onReject(request),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GridCell extends StatelessWidget {
  const _GridCell({
    required this.child,
    this.alignment = Alignment.centerRight,
  });

  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: child,
    );
  }
}

class _UserSummary extends StatelessWidget {
  const _UserSummary({required this.request});

  final AdminProRequestView request;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.person_outline_rounded,
            color: cs.primary,
            size: 19,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.25,
                ),
              ),
              const SizedBox(height: 2),
              AdminGridSubText(
                request.secondaryIdentity,
                maxLines: 1,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DocumentsSummary extends StatelessWidget {
  const _DocumentsSummary({required this.request, required this.onPressed});

  final AdminProRequestView request;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            request.certificates.length.toString(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
              color: cs.primary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.visibility_outlined, size: 16),
          label: const Text('عرض'),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 26),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    late final String label;
    late final Color backgroundColor;
    late final Color foregroundColor;

    switch (status) {
      case 'under_review':
        label = 'قيد المراجعة';
        backgroundColor = const Color(0xFFFFF0C9);
        foregroundColor = const Color(0xFFB7791F);
        break;
      case 'reviewed':
        label = 'تمت المراجعة';
        backgroundColor = const Color(0xFFE8F1FF);
        foregroundColor = const Color(0xFF2F6CC4);
        break;
      case 'accepted':
        label = 'تمت الترقية';
        backgroundColor = const Color(0xFFDFF5E8);
        foregroundColor = const Color(0xFF1E8E5A);
        break;
      case 'rejected':
        label = 'مرفوضة';
        backgroundColor = const Color(0xFFFFE4DE);
        foregroundColor = const Color(0xFFB3472F);
        break;
      default:
        label = status;
        backgroundColor = cs.primaryContainer.withValues(alpha: 0.34);
        foregroundColor = cs.onSurface;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 13.5,
          color: foregroundColor,
        ),
      ),
    );
  }
}

class _DecisionBadge extends StatelessWidget {
  const _DecisionBadge({required this.approved, required this.hasDecision});

  final bool approved;
  final bool hasDecision;

  @override
  Widget build(BuildContext context) {
    final label = !hasDecision
        ? 'بانتظار قرار المشرف'
        : approved
        ? 'مقبول'
        : 'مرفوض';

    final backgroundColor = !hasDecision
        ? const Color(0xFFF2ECE8)
        : approved
        ? const Color(0xFFDFF5E8)
        : const Color(0xFFFFE4DE);

    final foregroundColor = !hasDecision
        ? const Color(0xFF5B4C43)
        : approved
        ? const Color(0xFF1E8E5A)
        : const Color(0xFFB3472F);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 13.5,
          color: foregroundColor,
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.busy,
    required this.canReview,
    required this.onApprove,
    required this.onReject,
  });

  final bool busy;
  final bool canReview;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    if (!canReview) {
      return const Text('—', style: TextStyle(fontSize: 18));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionButton(
          label: busy ? 'جارٍ...' : 'ترقية',
          icon: busy ? Icons.sync : Icons.workspace_premium_rounded,
          filled: true,
          onPressed: busy ? () {} : onApprove,
        ),
        const SizedBox(width: 8),
        _ActionButton(
          label: 'رفض',
          icon: Icons.close_rounded,
          filled: false,
          onPressed: busy ? () {} : onReject,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final style = ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(filled ? cs.onPrimary : cs.error),
      backgroundColor: WidgetStatePropertyAll(
        filled ? cs.primary : Colors.transparent,
      ),
      side: WidgetStatePropertyAll(
        filled ? null : BorderSide(color: cs.error.withValues(alpha: 0.45)),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      minimumSize: const WidgetStatePropertyAll(Size(0, 34)),
      visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(label)],
    );

    return filled
        ? FilledButton(onPressed: onPressed, style: style, child: child)
        : OutlinedButton(onPressed: onPressed, style: style, child: child);
  }
}

String _shortDateOnly(String value) {
  if (value.isEmpty) return '-';
  return value.length >= 10 ? value.substring(0, 10) : value;
}

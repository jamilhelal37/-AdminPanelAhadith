import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/presentation/widgets/admin_data_grid.dart';
import '../../domain/models/admin_audit_log.dart';

class AdminAuditLogTable extends StatelessWidget {
  const AdminAuditLogTable({super.key, required this.logs});

  final List<AdminAuditLog> logs;

  @override
  Widget build(BuildContext context) {
    final source = _AdminAuditLogGridSource(context: context, logs: logs);

    return AdminDataGrid(
      source: source,
      rowHeight: 84,
      columnWidthMode: ColumnWidthMode.fill,
      columns: [
        GridColumn(
          columnName: 'actor',
          minimumWidth: 240,
          label: const AdminGridHeaderCell('المشرف / المستخدم'),
        ),
        GridColumn(
          columnName: 'operation',
          minimumWidth: 130,
          label: const AdminGridHeaderCell('نوع العملية'),
        ),
        GridColumn(
          columnName: 'table',
          minimumWidth: 180,
          label: const AdminGridHeaderCell('اسم الجدول'),
        ),
        GridColumn(
          columnName: 'record',
          minimumWidth: 140,
          label: const AdminGridHeaderCell('السجل المستهدف'),
        ),
        GridColumn(
          columnName: 'details',
          minimumWidth: 340,
          label: const AdminGridHeaderCell('الملخص'),
        ),
        GridColumn(
          columnName: 'createdAt',
          minimumWidth: 180,
          label: const AdminGridHeaderCell('وقت العملية'),
        ),
      ],
    );
  }
}

class _AdminAuditLogGridSource extends DataGridSource {
  _AdminAuditLogGridSource({required this.context, required this.logs})
    : _rows = logs
          .map(
            (entry) => DataGridRow(
              cells: [
                DataGridCell<String>(
                  columnName: 'actor',
                  value: entry.actorDisplay,
                ),
                DataGridCell<String>(
                  columnName: 'operation',
                  value: entry.operationArabic,
                ),
                DataGridCell<String>(
                  columnName: 'table',
                  value: entry.tableName,
                ),
                DataGridCell<String>(
                  columnName: 'record',
                  value: entry.shortRecordId,
                ),
                DataGridCell<String>(
                  columnName: 'details',
                  value: entry.detailsSummary,
                ),
                DataGridCell<String>(
                  columnName: 'createdAt',
                  value: entry.createdAtShort,
                ),
              ],
            ),
          )
          .toList();

  final BuildContext context;
  final List<AdminAuditLog> logs;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cs = Theme.of(context).colorScheme;
    final index = _rows.indexOf(row);
    final entry = logs[index];

    return DataGridRowAdapter(
      color: index.isEven ? cs.surface : cs.surface.withValues(alpha: 0.52),
      cells: [
        AdminGridCell(child: _ActorCell(entry: entry)),
        AdminGridCell(
          alignment: Alignment.center,
          child: _OperationBadge(operation: entry.operation),
        ),
        AdminGridCell(child: AdminGridText(entry.tableName, maxLines: 1)),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridText(entry.shortRecordId),
        ),
        AdminGridCell(child: AdminGridText(entry.detailsSummary, maxLines: 2)),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridText(entry.createdAtShort),
        ),
      ],
    );
  }
}

class _ActorCell extends StatelessWidget {
  const _ActorCell({required this.entry});

  final AdminAuditLog entry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          entry.actorDisplay,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 3),
        AdminGridText(
          entry.actorSubline,
          maxLines: 1,
          color: cs.onSurfaceVariant,
        ),
      ],
    );
  }
}

class _OperationBadge extends StatelessWidget {
  const _OperationBadge({required this.operation});

  final String operation;

  @override
  Widget build(BuildContext context) {
    final op = operation.toUpperCase();

    if (op == 'INSERT') {
      return const AdminGridBadge(
        label: 'إضافة',
        backgroundColor: Color(0xFFDFF5E8),
        foregroundColor: Color(0xFF1E8E5A),
      );
    }

    if (op == 'DELETE') {
      return const AdminGridBadge(
        label: 'حذف',
        backgroundColor: Color(0xFFFFE4DE),
        foregroundColor: Color(0xFFB3472F),
      );
    }

    return const AdminGridBadge(
      label: 'تحديث',
      backgroundColor: Color(0xFFE4EEFF),
      foregroundColor: Color(0xFF2F6FDB),
    );
  }
}

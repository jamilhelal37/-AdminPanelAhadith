import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/presentation/widgets/admin_data_grid.dart';
import '../../domain/models/fake_ahadith.dart';

class AdminFakeAhadithsTable extends StatelessWidget {
  const AdminFakeAhadithsTable({
    super.key,
    required this.fakeAhadiths,
    required this.onDelete,
    required this.onEdit,
    required this.onLinkSubValid,
  });

  final List<FakeAhadith> fakeAhadiths;
  final void Function(FakeAhadith) onDelete;
  final void Function(FakeAhadith) onEdit;
  final void Function(FakeAhadith) onLinkSubValid;

  @override
  Widget build(BuildContext context) {
    final source = _AdminFakeAhadithsGridSource(
      context: context,
      fakeAhadiths: fakeAhadiths,
      onDelete: onDelete,
      onEdit: onEdit,
      onLinkSubValid: onLinkSubValid,
    );

    return AdminDataGrid(
      source: source,
      rowHeight: 96,
      columnWidthMode: ColumnWidthMode.fill,
      columns: [
        GridColumn(
          columnName: 'text',
          minimumWidth: 320,
          label: AdminGridHeaderCell('نص الحديث'),
        ),
        GridColumn(
          columnName: 'ruling',
          minimumWidth: 180,
          label: AdminGridHeaderCell('الحكم'),
        ),
        GridColumn(
          columnName: 'subValid',
          minimumWidth: 240,
          label: AdminGridHeaderCell('الصحيح البديل'),
        ),
        GridColumn(
          columnName: 'actions',
          minimumWidth: 150,
          label: AdminGridHeaderCell('الإجراءات'),
        ),
      ],
    );
  }
}

class _AdminFakeAhadithsGridSource extends DataGridSource {
  _AdminFakeAhadithsGridSource({
    required this.context,
    required this.fakeAhadiths,
    required this.onDelete,
    required this.onEdit,
    required this.onLinkSubValid,
  }) : _rows = fakeAhadiths
           .map(
             (item) => DataGridRow(
               cells: [
                 DataGridCell<String>(columnName: 'text', value: item.text),
                 DataGridCell<String>(
                   columnName: 'ruling',
                   value: item.rulingName ?? 'غير محدد',
                 ),
                 DataGridCell<String>(
                   columnName: 'subValid',
                   value: item.subValidText ?? '',
                 ),
                 DataGridCell<String>(columnName: 'actions', value: ''),
               ],
             ),
           )
           .toList();

  final BuildContext context;
  final List<FakeAhadith> fakeAhadiths;
  final void Function(FakeAhadith) onDelete;
  final void Function(FakeAhadith) onEdit;
  final void Function(FakeAhadith) onLinkSubValid;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cs = Theme.of(context).colorScheme;
    final index = _rows.indexOf(row);
    final item = fakeAhadiths[index];
    final hasSubValid = item.subValid?.isNotEmpty == true;

    return DataGridRowAdapter(
      color: index.isEven ? cs.surface : cs.surface.withValues(alpha: 0.52),
      cells: [
        AdminGridCell(child: AdminGridText(item.text, maxLines: 3)),
        AdminGridCell(
          child: AdminGridBadge(
            label: item.rulingName ?? 'غير محدد',
            backgroundColor: cs.primaryContainer.withValues(alpha: 0.34),
            foregroundColor: cs.onSurface,
          ),
        ),
        AdminGridCell(
          child: AdminGridActionButton(
            label: hasSubValid ? 'تعديل الربط' : 'ربط حديث صحيح',
            icon: hasSubValid ? Icons.edit_outlined : Icons.add_link_rounded,
            onPressed: () => onLinkSubValid(item),
          ),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridActionBar(
            children: [
              AdminGridIconAction(
                icon: Icons.edit_outlined,
                tooltip: 'تعديل الحديث',
                onPressed: () => onEdit(item),
              ),
              AdminGridIconAction(
                icon: Icons.delete_outline_rounded,
                tooltip: 'حذف الحديث',
                color: cs.error,
                onPressed: () => onDelete(item),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

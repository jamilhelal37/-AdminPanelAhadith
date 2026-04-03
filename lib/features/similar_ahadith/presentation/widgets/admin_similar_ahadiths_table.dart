import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/presentation/widgets/admin_data_grid.dart';
import '../../domain/models/similar_ahadith.dart';

class AdminSimilarAhadithsTable extends StatelessWidget {
  const AdminSimilarAhadithsTable({
    super.key,
    required this.similarAhadiths,
    required this.onDelete,
    required this.onEdit,
  });

  final List<SimilarAhadith> similarAhadiths;
  final void Function(SimilarAhadith) onDelete;
  final void Function(SimilarAhadith) onEdit;

  @override
  Widget build(BuildContext context) {
    final source = _AdminSimilarAhadithsGridSource(
      context: context,
      similarAhadiths: similarAhadiths,
      onDelete: onDelete,
      onEdit: onEdit,
    );

    return AdminDataGrid(
      source: source,
      rowHeight: 96,
      columnWidthMode: ColumnWidthMode.fill,
      columns: [
        GridColumn(
          columnName: 'mainBook',
          minimumWidth: 180,
          label: AdminGridHeaderCell('الكتاب الرئيسي'),
        ),
        GridColumn(
          columnName: 'mainNumber',
          minimumWidth: 120,
          label: AdminGridHeaderCell('رقمه'),
        ),
        GridColumn(
          columnName: 'mainText',
          minimumWidth: 300,
          label: AdminGridHeaderCell('النص الرئيسي'),
        ),
        GridColumn(
          columnName: 'similarBook',
          minimumWidth: 180,
          label: AdminGridHeaderCell('الكتاب المشابه'),
        ),
        GridColumn(
          columnName: 'similarNumber',
          minimumWidth: 120,
          label: AdminGridHeaderCell('رقمه'),
        ),
        GridColumn(
          columnName: 'similarText',
          minimumWidth: 300,
          label: AdminGridHeaderCell('النص المشابه'),
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

class _AdminSimilarAhadithsGridSource extends DataGridSource {
  _AdminSimilarAhadithsGridSource({
    required this.context,
    required this.similarAhadiths,
    required this.onDelete,
    required this.onEdit,
  }) : _rows = similarAhadiths
           .map(
             (item) => DataGridRow(
               cells: [
                 DataGridCell<String>(
                   columnName: 'mainBook',
                   value: item.mainBookName ?? 'غير محدد',
                 ),
                 DataGridCell<String>(
                   columnName: 'mainNumber',
                   value: item.mainHadithNumber?.toString() ?? '-',
                 ),
                 DataGridCell<String>(
                   columnName: 'mainText',
                   value: item.mainHadithText ?? '',
                 ),
                 DataGridCell<String>(
                   columnName: 'similarBook',
                   value: item.simBookName ?? 'غير محدد',
                 ),
                 DataGridCell<String>(
                   columnName: 'similarNumber',
                   value: item.simHadithNumber?.toString() ?? '-',
                 ),
                 DataGridCell<String>(
                   columnName: 'similarText',
                   value: item.simHadithText ?? '',
                 ),
                 DataGridCell<String>(columnName: 'actions', value: ''),
               ],
             ),
           )
           .toList();

  final BuildContext context;
  final List<SimilarAhadith> similarAhadiths;
  final void Function(SimilarAhadith) onDelete;
  final void Function(SimilarAhadith) onEdit;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cs = Theme.of(context).colorScheme;
    final index = _rows.indexOf(row);
    final item = similarAhadiths[index];

    return DataGridRowAdapter(
      color: index.isEven ? cs.surface : cs.surface.withValues(alpha: 0.52),
      cells: [
        AdminGridCell(child: AdminGridText(item.mainBookName ?? 'غير محدد')),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridText(item.mainHadithNumber?.toString() ?? '-'),
        ),
        AdminGridCell(
          child: AdminGridText(item.mainHadithText ?? 'غير محدد', maxLines: 3),
        ),
        AdminGridCell(child: AdminGridText(item.simBookName ?? 'غير محدد')),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridText(item.simHadithNumber?.toString() ?? '-'),
        ),
        AdminGridCell(
          child: AdminGridText(item.simHadithText ?? 'غير محدد', maxLines: 3),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridActionBar(
            children: [
              AdminGridIconAction(
                icon: Icons.edit_outlined,
                tooltip: 'تعديل الربط',
                onPressed: () => onEdit(item),
              ),
              AdminGridIconAction(
                icon: Icons.delete_outline_rounded,
                tooltip: 'حذف الربط',
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

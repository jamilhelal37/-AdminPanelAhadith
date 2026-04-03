import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/presentation/widgets/admin_data_grid.dart';
import '../../domain/models/muhaddith.dart';

class AdminMuhaddithsTable extends StatelessWidget {
  const AdminMuhaddithsTable({
    super.key,
    required this.muhaddiths,
    required this.onDelete,
    required this.onEdit,
  });

  final List<Muhaddith> muhaddiths;
  final void Function(Muhaddith) onDelete;
  final void Function(Muhaddith) onEdit;

  @override
  Widget build(BuildContext context) {
    final source = _AdminMuhaddithsGridSource(
      context: context,
      muhaddiths: muhaddiths,
      onDelete: onDelete,
      onEdit: onEdit,
    );

    return AdminDataGrid(
      source: source,
      rowHeight: 94,
      columnWidthMode: ColumnWidthMode.fill,
      columns: [
        GridColumn(
          columnName: 'name',
          minimumWidth: 220,
          label: AdminGridHeaderCell('الاسم'),
        ),
        GridColumn(
          columnName: 'gender',
          minimumWidth: 120,
          label: AdminGridHeaderCell('الجنس'),
        ),
        GridColumn(
          columnName: 'about',
          minimumWidth: 460,
          label: AdminGridHeaderCell('نبذة'),
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

class _AdminMuhaddithsGridSource extends DataGridSource {
  _AdminMuhaddithsGridSource({
    required this.context,
    required this.muhaddiths,
    required this.onDelete,
    required this.onEdit,
  }) : _rows = muhaddiths
           .map(
             (muhaddith) => DataGridRow(
               cells: [
                 DataGridCell<String>(
                   columnName: 'name',
                   value: muhaddith.name,
                 ),
                 DataGridCell<String>(
                   columnName: 'gender',
                   value: _genderLabel(muhaddith.gender),
                 ),
                 DataGridCell<String>(
                   columnName: 'about',
                   value: muhaddith.about,
                 ),
                 DataGridCell<String>(columnName: 'actions', value: ''),
               ],
             ),
           )
           .toList();

  final BuildContext context;
  final List<Muhaddith> muhaddiths;
  final void Function(Muhaddith) onDelete;
  final void Function(Muhaddith) onEdit;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cs = Theme.of(context).colorScheme;
    final index = _rows.indexOf(row);
    final muhaddith = muhaddiths[index];

    return DataGridRowAdapter(
      color: index.isEven ? cs.surface : cs.surface.withValues(alpha: 0.52),
      cells: [
        AdminGridCell(child: AdminGridText(muhaddith.name, maxLines: 2)),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridText(_genderLabel(muhaddith.gender)),
        ),
        AdminGridCell(child: AdminGridText(muhaddith.about, maxLines: 3)),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridActionBar(
            children: [
              AdminGridIconAction(
                icon: Icons.edit_outlined,
                tooltip: 'تعديل المحدّث',
                onPressed: () => onEdit(muhaddith),
              ),
              AdminGridIconAction(
                icon: Icons.delete_outline_rounded,
                tooltip: 'حذف المحدّث',
                color: cs.error,
                onPressed: () => onDelete(muhaddith),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _genderLabel(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'ذكر';
      case Gender.female:
        return 'أنثى';
    }
  }
}

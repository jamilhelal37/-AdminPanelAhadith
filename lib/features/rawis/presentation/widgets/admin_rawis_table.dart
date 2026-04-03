import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/presentation/widgets/admin_data_grid.dart';
import '../../domain/models/rawi.dart';

class AdminRawisTable extends StatelessWidget {
  const AdminRawisTable({
    super.key,
    required this.rawis,
    required this.onDelete,
    required this.onEdit,
  });

  final List<Rawi> rawis;
  final void Function(Rawi) onDelete;
  final void Function(Rawi) onEdit;

  @override
  Widget build(BuildContext context) {
    final source = _AdminRawisGridSource(
      context: context,
      rawis: rawis,
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

class _AdminRawisGridSource extends DataGridSource {
  _AdminRawisGridSource({
    required this.context,
    required this.rawis,
    required this.onDelete,
    required this.onEdit,
  }) : _rows = rawis
           .map(
             (rawi) => DataGridRow(
               cells: [
                 DataGridCell<String>(columnName: 'name', value: rawi.name),
                 DataGridCell<String>(
                   columnName: 'gender',
                   value: _genderLabel(rawi.gender),
                 ),
                 DataGridCell<String>(columnName: 'about', value: rawi.about),
                 DataGridCell<String>(columnName: 'actions', value: ''),
               ],
             ),
           )
           .toList();

  final BuildContext context;
  final List<Rawi> rawis;
  final void Function(Rawi) onDelete;
  final void Function(Rawi) onEdit;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cs = Theme.of(context).colorScheme;
    final index = _rows.indexOf(row);
    final rawi = rawis[index];

    return DataGridRowAdapter(
      color: index.isEven ? cs.surface : cs.surface.withValues(alpha: 0.52),
      cells: [
        AdminGridCell(child: AdminGridText(rawi.name, maxLines: 2)),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridText(_genderLabel(rawi.gender)),
        ),
        AdminGridCell(child: AdminGridText(rawi.about, maxLines: 3)),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridActionBar(
            children: [
              AdminGridIconAction(
                icon: Icons.edit_outlined,
                tooltip: 'تعديل الراوي',
                onPressed: () => onEdit(rawi),
              ),
              AdminGridIconAction(
                icon: Icons.delete_outline_rounded,
                tooltip: 'حذف الراوي',
                color: cs.error,
                onPressed: () => onDelete(rawi),
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

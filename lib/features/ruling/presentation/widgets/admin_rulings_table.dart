import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/presentation/widgets/admin_data_grid.dart';
import '../../domain/models/ruling.dart';

class AdminRulingsTable extends StatelessWidget {
  const AdminRulingsTable({
    super.key,
    required this.rulings,
    required this.onDelete,
    required this.onEdit,
  });

  final List<Ruling> rulings;
  final void Function(Ruling) onDelete;
  final void Function(Ruling) onEdit;

  @override
  Widget build(BuildContext context) {
    final source = _AdminRulingsGridSource(
      context: context,
      rulings: rulings,
      onDelete: onDelete,
      onEdit: onEdit,
    );

    return AdminDataGrid(
      source: source,
      rowHeight: 82,
      columnWidthMode: ColumnWidthMode.fill,
      columns: [
        GridColumn(
          columnName: 'name',
          minimumWidth: 260,
          label: AdminGridHeaderCell('الحكم'),
        ),
        GridColumn(
          columnName: 'actions',
          width: 150,
          label: AdminGridHeaderCell('الإجراءات'),
        ),
      ],
    );
  }
}

class _AdminRulingsGridSource extends DataGridSource {
  _AdminRulingsGridSource({
    required this.context,
    required this.rulings,
    required this.onDelete,
    required this.onEdit,
  }) : _rows = rulings
           .map(
             (ruling) => DataGridRow(
               cells: [
                 DataGridCell<String>(columnName: 'name', value: ruling.name),
                 DataGridCell<String>(columnName: 'actions', value: ''),
               ],
             ),
           )
           .toList();

  final BuildContext context;
  final List<Ruling> rulings;
  final void Function(Ruling) onDelete;
  final void Function(Ruling) onEdit;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cs = Theme.of(context).colorScheme;
    final index = _rows.indexOf(row);
    final ruling = rulings[index];

    return DataGridRowAdapter(
      color: index.isEven ? cs.surface : cs.surface.withValues(alpha: 0.52),
      cells: [
        AdminGridCell(child: AdminGridText(ruling.name, maxLines: 2)),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridActionBar(
            children: [
              AdminGridIconAction(
                icon: Icons.edit_outlined,
                tooltip: 'تعديل الحكم',
                onPressed: () => onEdit(ruling),
              ),
              AdminGridIconAction(
                icon: Icons.delete_outline_rounded,
                tooltip: 'حذف الحكم',
                color: cs.error,
                onPressed: () => onDelete(ruling),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

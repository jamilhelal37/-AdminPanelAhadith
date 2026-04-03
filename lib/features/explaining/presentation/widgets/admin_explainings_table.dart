import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/presentation/widgets/admin_data_grid.dart';
import '../../domain/models/explaining.dart';

class AdminExplainingsTable extends StatelessWidget {
  const AdminExplainingsTable({
    super.key,
    required this.explainings,
    required this.onDelete,
    required this.onEdit,
  });

  final List<Explaining> explainings;
  final void Function(Explaining) onDelete;
  final void Function(Explaining) onEdit;

  @override
  Widget build(BuildContext context) {
    final source = _AdminExplainingsGridSource(
      context: context,
      explainings: explainings,
      onDelete: onDelete,
      onEdit: onEdit,
    );

    return AdminDataGrid(
      source: source,
      rowHeight: 102,
      columnWidthMode: ColumnWidthMode.fill,
      columns: [
        GridColumn(
          columnName: 'text',
          minimumWidth: 520,
          label: AdminGridHeaderCell('نص الشرح'),
        ),
        GridColumn(
          columnName: 'actions',
          width: 160,
          label: AdminGridHeaderCell('الإجراءات'),
        ),
      ],
    );
  }
}

class _AdminExplainingsGridSource extends DataGridSource {
  _AdminExplainingsGridSource({
    required this.context,
    required this.explainings,
    required this.onDelete,
    required this.onEdit,
  }) : _rows = explainings
           .map(
             (explaining) => DataGridRow(
               cells: [
                 DataGridCell<String>(columnName: 'text', value: ''),
                 DataGridCell<String>(columnName: 'actions', value: ''),
               ],
             ),
           )
           .toList();

  final BuildContext context;
  final List<Explaining> explainings;
  final void Function(Explaining) onDelete;
  final void Function(Explaining) onEdit;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cs = Theme.of(context).colorScheme;
    final index = _rows.indexOf(row);
    final explaining = explainings[index];

    return DataGridRowAdapter(
      color: index.isEven ? cs.surface : cs.surface.withValues(alpha: 0.52),
      cells: [
        AdminGridCell(child: AdminGridText(explaining.text, maxLines: 4)),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridActionBar(
            children: [
              AdminGridIconAction(
                icon: Icons.edit_outlined,
                tooltip: 'تعديل الشرح',
                onPressed: () => onEdit(explaining),
              ),
              AdminGridIconAction(
                icon: Icons.delete_outline_rounded,
                tooltip: 'حذف الشرح',
                color: cs.error,
                onPressed: () => onDelete(explaining),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

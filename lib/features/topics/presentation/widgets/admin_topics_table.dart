import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/presentation/widgets/admin_data_grid.dart';
import '../../domain/models/topic.dart';

class AdminTopicsTable extends StatelessWidget {
  const AdminTopicsTable({
    super.key,
    required this.topics,
    required this.onDelete,
    required this.onEdit,
  });

  final List<Topic> topics;
  final void Function(Topic) onDelete;
  final void Function(Topic) onEdit;

  @override
  Widget build(BuildContext context) {
    final source = _AdminTopicsGridSource(
      context: context,
      topics: topics,
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
          minimumWidth: 280,
          label: AdminGridHeaderCell('الموضوع'),
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

class _AdminTopicsGridSource extends DataGridSource {
  _AdminTopicsGridSource({
    required this.context,
    required this.topics,
    required this.onDelete,
    required this.onEdit,
  }) : _rows = topics
           .map(
             (topic) => DataGridRow(
               cells: [
                 DataGridCell<String>(columnName: 'name', value: topic.name),
                 DataGridCell<String>(columnName: 'actions', value: ''),
               ],
             ),
           )
           .toList();

  final BuildContext context;
  final List<Topic> topics;
  final void Function(Topic) onDelete;
  final void Function(Topic) onEdit;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cs = Theme.of(context).colorScheme;
    final index = _rows.indexOf(row);
    final topic = topics[index];

    return DataGridRowAdapter(
      color: index.isEven ? cs.surface : cs.surface.withValues(alpha: 0.52),
      cells: [
        AdminGridCell(child: AdminGridText(topic.name, maxLines: 2)),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridActionBar(
            children: [
              AdminGridIconAction(
                icon: Icons.edit_outlined,
                tooltip: 'تعديل الموضوع',
                onPressed: () => onEdit(topic),
              ),
              AdminGridIconAction(
                icon: Icons.delete_outline_rounded,
                tooltip: 'حذف الموضوع',
                color: cs.error,
                onPressed: () => onDelete(topic),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

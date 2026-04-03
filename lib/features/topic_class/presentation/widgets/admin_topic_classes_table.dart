import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/presentation/widgets/admin_data_grid.dart';
import '../../domain/models/topic_class.dart';

class AdminTopicClassesTable extends StatelessWidget {
  const AdminTopicClassesTable({
    super.key,
    required this.topicClasses,
    required this.onDelete,
    required this.onEdit,
  });

  final List<TopicClass> topicClasses;
  final void Function(TopicClass) onDelete;
  final void Function(TopicClass) onEdit;

  @override
  Widget build(BuildContext context) {
    final source = _AdminTopicClassesGridSource(
      context: context,
      topicClasses: topicClasses,
      onDelete: onDelete,
      onEdit: onEdit,
    );

    return AdminDataGrid(
      source: source,
      rowHeight: 96,
      columnWidthMode: ColumnWidthMode.fill,
      columns: [
        GridColumn(
          columnName: 'book',
          minimumWidth: 220,
          label: AdminGridHeaderCell('الكتاب'),
        ),
        GridColumn(
          columnName: 'number',
          minimumWidth: 120,
          label: AdminGridHeaderCell('رقم الحديث'),
        ),
        GridColumn(
          columnName: 'hadith',
          minimumWidth: 360,
          label: AdminGridHeaderCell('نص الحديث'),
        ),
        GridColumn(
          columnName: 'topic',
          minimumWidth: 220,
          label: AdminGridHeaderCell('الموضوع'),
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

class _AdminTopicClassesGridSource extends DataGridSource {
  _AdminTopicClassesGridSource({
    required this.context,
    required this.topicClasses,
    required this.onDelete,
    required this.onEdit,
  }) : _rows = topicClasses
           .map(
             (topicClass) => DataGridRow(
               cells: [
                 DataGridCell<String>(
                   columnName: 'book',
                   value: topicClass.bookName ?? '-',
                 ),
                 DataGridCell<String>(
                   columnName: 'number',
                   value: topicClass.hadithNumber?.toString() ?? '-',
                 ),
                 DataGridCell<String>(
                   columnName: 'hadith',
                   value: topicClass.hadithText ?? '-',
                 ),
                 DataGridCell<String>(
                   columnName: 'topic',
                   value: topicClass.topicName ?? topicClass.topicId ?? '-',
                 ),
                 DataGridCell<String>(columnName: 'actions', value: ''),
               ],
             ),
           )
           .toList();

  final BuildContext context;
  final List<TopicClass> topicClasses;
  final void Function(TopicClass) onDelete;
  final void Function(TopicClass) onEdit;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cs = Theme.of(context).colorScheme;
    final index = _rows.indexOf(row);
    final topicClass = topicClasses[index];

    return DataGridRowAdapter(
      color: index.isEven ? cs.surface : cs.surface.withValues(alpha: 0.52),
      cells: [
        AdminGridCell(
          child: AdminGridText(topicClass.bookName ?? '-', maxLines: 2),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridText(topicClass.hadithNumber?.toString() ?? '-'),
        ),
        AdminGridCell(
          child: AdminGridText(topicClass.hadithText ?? '-', maxLines: 3),
        ),
        AdminGridCell(
          child: AdminGridText(
            topicClass.topicName ?? topicClass.topicId ?? '-',
            maxLines: 2,
          ),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridActionBar(
            children: [
              AdminGridIconAction(
                icon: Icons.edit_outlined,
                tooltip: 'تعديل الربط',
                onPressed: () => onEdit(topicClass),
              ),
              AdminGridIconAction(
                icon: Icons.delete_outline_rounded,
                tooltip: 'حذف الربط',
                color: cs.error,
                onPressed: () => onDelete(topicClass),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

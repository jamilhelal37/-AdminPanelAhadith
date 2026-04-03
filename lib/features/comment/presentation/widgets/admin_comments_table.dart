import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/presentation/widgets/admin_data_grid.dart';
import '../../domain/models/comment.dart';

class AdminCommentsTable extends StatelessWidget {
  const AdminCommentsTable({
    super.key,
    required this.comments,
    required this.onDelete,
    required this.onEdit,
  });

  final List<Comment> comments;
  final void Function(Comment) onDelete;
  final void Function(Comment) onEdit;

  @override
  Widget build(BuildContext context) {
    final source = _AdminCommentsGridSource(
      context: context,
      comments: comments,
      onDelete: onDelete,
      onEdit: onEdit,
    );

    return AdminDataGrid(
      source: source,
      rowHeight: 92,
      columnWidthMode: ColumnWidthMode.fill,
      columns: [
        GridColumn(
          columnName: 'text',
          minimumWidth: 360,
          label: AdminGridHeaderCell('التعليق'),
        ),
        GridColumn(
          columnName: 'userId',
          minimumWidth: 220,
          label: AdminGridHeaderCell('المستخدم'),
        ),
        GridColumn(
          columnName: 'hadithId',
          minimumWidth: 200,
          label: AdminGridHeaderCell('الحديث'),
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

class _AdminCommentsGridSource extends DataGridSource {
  _AdminCommentsGridSource({
    required this.context,
    required this.comments,
    required this.onDelete,
    required this.onEdit,
  }) : _rows = comments
           .map(
             (comment) => DataGridRow(
               cells: [
                 DataGridCell<String>(columnName: 'text', value: comment.text),
                 DataGridCell<String>(
                   columnName: 'userId',
                   value: comment.userId ?? '-',
                 ),
                 DataGridCell<String>(
                   columnName: 'hadithId',
                   value: comment.hadithId ?? '-',
                 ),
                 DataGridCell<String>(columnName: 'actions', value: ''),
               ],
             ),
           )
           .toList();

  final BuildContext context;
  final List<Comment> comments;
  final void Function(Comment) onDelete;
  final void Function(Comment) onEdit;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cs = Theme.of(context).colorScheme;
    final index = _rows.indexOf(row);
    final comment = comments[index];

    return DataGridRowAdapter(
      color: index.isEven ? cs.surface : cs.surface.withValues(alpha: 0.52),
      cells: [
        AdminGridCell(child: AdminGridText(comment.text, maxLines: 3)),
        AdminGridCell(child: AdminGridText(comment.userId ?? '-', maxLines: 2)),
        AdminGridCell(
          child: AdminGridText(comment.hadithId ?? '-', maxLines: 2),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridActionBar(
            children: [
              AdminGridIconAction(
                icon: Icons.edit_outlined,
                tooltip: 'تعديل التعليق',
                onPressed: () => onEdit(comment),
              ),
              AdminGridIconAction(
                icon: Icons.delete_outline_rounded,
                tooltip: 'حذف التعليق',
                color: cs.error,
                onPressed: () => onDelete(comment),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

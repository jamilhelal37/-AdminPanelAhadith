import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/presentation/widgets/admin_data_grid.dart';
import '../../domain/models/book.dart';

class AdminBooksTable extends StatelessWidget {
  const AdminBooksTable({
    super.key,
    required this.books,
    required this.muhaddithNameById,
    required this.onDelete,
    required this.onEdit,
  });

  final List<Book> books;
  final Map<String, String> muhaddithNameById;
  final void Function(Book) onDelete;
  final void Function(Book) onEdit;

  @override
  Widget build(BuildContext context) {
    final source = _AdminBooksGridSource(
      context: context,
      books: books,
      muhaddithNameById: muhaddithNameById,
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
          minimumWidth: 220,
          label: AdminGridHeaderCell('الكتاب'),
        ),
        GridColumn(
          columnName: 'muhaddith',
          minimumWidth: 260,
          label: AdminGridHeaderCell('المحدّث'),
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

class _AdminBooksGridSource extends DataGridSource {
  _AdminBooksGridSource({
    required this.context,
    required this.books,
    required this.muhaddithNameById,
    required this.onDelete,
    required this.onEdit,
  }) : _rows = books
           .map(
             (book) => DataGridRow(
               cells: [
                 DataGridCell<String>(columnName: 'name', value: book.name),
                 DataGridCell<String>(
                   columnName: 'muhaddith',
                   value: muhaddithNameById[book.muhaddithId] ?? 'غير معروف',
                 ),
                 DataGridCell<String>(columnName: 'actions', value: ''),
               ],
             ),
           )
           .toList();

  final BuildContext context;
  final List<Book> books;
  final Map<String, String> muhaddithNameById;
  final void Function(Book) onDelete;
  final void Function(Book) onEdit;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cs = Theme.of(context).colorScheme;
    final index = _rows.indexOf(row);
    final book = books[index];

    return DataGridRowAdapter(
      color: index.isEven ? cs.surface : cs.surface.withValues(alpha: 0.52),
      cells: [
        AdminGridCell(child: AdminGridText(book.name, maxLines: 2)),
        AdminGridCell(
          child: AdminGridText(
            muhaddithNameById[book.muhaddithId] ?? 'غير معروف',
            maxLines: 2,
          ),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridActionBar(
            children: [
              AdminGridIconAction(
                icon: Icons.edit_outlined,
                tooltip: 'تعديل الكتاب',
                onPressed: () => onEdit(book),
              ),
              AdminGridIconAction(
                icon: Icons.delete_outline_rounded,
                tooltip: 'حذف الكتاب',
                color: cs.error,
                onPressed: () => onDelete(book),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/presentation/widgets/admin_data_grid.dart';
import '../../domain/models/question.dart';

class AdminQuestionsTable extends StatelessWidget {
  const AdminQuestionsTable({
    super.key,
    required this.questions,
    required this.askerNameById,
    required this.onDelete,
    required this.onEditAnswer,
  });

  final List<Question> questions;
  final Map<String, String> askerNameById;
  final void Function(Question) onDelete;
  final void Function(Question) onEditAnswer;

  @override
  Widget build(BuildContext context) {
    final source = _AdminQuestionsGridSource(
      context: context,
      questions: questions,
      askerNameById: askerNameById,
      onDelete: onDelete,
      onEditAnswer: onEditAnswer,
    );

    return AdminDataGrid(
      source: source,
      rowHeight: 94,
      columnWidthMode: ColumnWidthMode.fill,
      columns: [
        GridColumn(
          columnName: 'asker',
          minimumWidth: 170,
          label: AdminGridHeaderCell('السائل'),
        ),
        GridColumn(
          columnName: 'question',
          minimumWidth: 260,
          label: AdminGridHeaderCell('السؤال'),
        ),
        GridColumn(
          columnName: 'answer',
          minimumWidth: 260,
          label: AdminGridHeaderCell('الجواب'),
        ),
        GridColumn(
          columnName: 'active',
          minimumWidth: 110,
          label: AdminGridHeaderCell('الحالة'),
        ),
        GridColumn(
          columnName: 'actions',
          minimumWidth: 130,
          label: AdminGridHeaderCell('الإجراءات'),
        ),
      ],
    );
  }
}

class _AdminQuestionsGridSource extends DataGridSource {
  _AdminQuestionsGridSource({
    required this.context,
    required this.questions,
    required this.askerNameById,
    required this.onDelete,
    required this.onEditAnswer,
  }) : _rows = questions
           .map(
             (question) => DataGridRow(
               cells: [
                 DataGridCell<String>(
                   columnName: 'asker',
                   value: question.askerId ?? '',
                 ),
                 DataGridCell<String>(
                   columnName: 'question',
                   value: question.askerText,
                 ),
                 DataGridCell<String>(
                   columnName: 'answer',
                   value: question.answerText ?? '',
                 ),
                 DataGridCell<bool>(
                   columnName: 'active',
                   value: question.isActive,
                 ),
                 DataGridCell<String>(columnName: 'actions', value: ''),
               ],
             ),
           )
           .toList();

  final BuildContext context;
  final List<Question> questions;
  final Map<String, String> askerNameById;
  final void Function(Question) onDelete;
  final void Function(Question) onEditAnswer;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cs = Theme.of(context).colorScheme;
    final index = _rows.indexOf(row);
    final question = questions[index];
    final askerLabel = question.askerId == null
        ? '-'
        : (askerNameById[question.askerId!] ?? question.askerId!);

    return DataGridRowAdapter(
      color: index.isEven ? cs.surface : cs.surface.withValues(alpha: 0.52),
      cells: [
        AdminGridCell(child: AdminGridText(askerLabel, maxLines: 2)),
        AdminGridCell(child: AdminGridText(question.askerText, maxLines: 3)),
        AdminGridCell(
          child: AdminGridText(
            question.answerText?.trim().isNotEmpty == true
                ? question.answerText!.trim()
                : 'لا يوجد جواب بعد',
            maxLines: 3,
            color: question.answerText?.trim().isNotEmpty == true
                ? null
                : cs.onSurfaceVariant,
          ),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridBadge(
            label: question.isActive ? 'نشط' : 'غير نشط',
            backgroundColor: question.isActive
                ? const Color(0xFFDFF5E8)
                : const Color(0xFFFFE4DE),
            foregroundColor: question.isActive
                ? const Color(0xFF1E8E5A)
                : const Color(0xFFB3472F),
          ),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridActionBar(
            children: [
              AdminGridIconAction(
                icon: Icons.edit_outlined,
                tooltip: 'تعديل الجواب',
                onPressed: () => onEditAnswer(question),
              ),
              AdminGridIconAction(
                icon: Icons.delete_outline_rounded,
                tooltip: 'حذف السؤال',
                color: cs.error,
                onPressed: () => onDelete(question),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

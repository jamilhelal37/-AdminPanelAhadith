import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/presentation/widgets/admin_data_grid.dart';
import '../../domain/models/hadith.dart';

class AdminAhadithTable extends StatelessWidget {
  const AdminAhadithTable({
    super.key,
    required this.ahadith,
    required this.onDelete,
    required this.onEdit,
    required this.onLinkExplaining,
    required this.onLinkSubValid,
  });

  final List<Hadith> ahadith;
  final void Function(Hadith) onDelete;
  final void Function(Hadith) onEdit;
  final void Function(Hadith) onLinkExplaining;
  final void Function(Hadith) onLinkSubValid;

  @override
  Widget build(BuildContext context) {
    final source = _AdminAhadithGridSource(
      context: context,
      ahadith: ahadith,
      onDelete: onDelete,
      onEdit: onEdit,
      onLinkExplaining: onLinkExplaining,
      onLinkSubValid: onLinkSubValid,
    );

    return AdminDataGrid(
      source: source,
      rowHeight: 88,
      headerRowHeight: 48,
      columnWidthMode: ColumnWidthMode.fill,
      columns: [
        GridColumn(
          columnName: 'source',
          minimumWidth: 180,
          label: AdminGridHeaderCell('الكتاب'),
        ),
        GridColumn(
          columnName: 'type',
          minimumWidth: 120,
          label: AdminGridHeaderCell('النوع'),
        ),
        GridColumn(
          columnName: 'number',
          minimumWidth: 100,
          label: AdminGridHeaderCell('الرقم'),
        ),
        GridColumn(
          columnName: 'rawi',
          minimumWidth: 180,
          label: AdminGridHeaderCell('الراوي'),
        ),
        GridColumn(
          columnName: 'text',
          minimumWidth: 380,
          label: AdminGridHeaderCell('النص'),
        ),
        GridColumn(
          columnName: 'muhaddithRuling',
          minimumWidth: 180,
          label: AdminGridHeaderCell('حكم المحدّث'),
        ),
        GridColumn(
          columnName: 'finalRuling',
          minimumWidth: 180,
          label: AdminGridHeaderCell('الحكم النهائي'),
        ),
        GridColumn(
          columnName: 'explaining',
          minimumWidth: 180,
          label: AdminGridHeaderCell('الشروحات'),
        ),
        GridColumn(
          columnName: 'subValid',
          minimumWidth: 180,
          label: AdminGridHeaderCell('الصحيح البديل'),
        ),
        GridColumn(
          columnName: 'sanad',
          minimumWidth: 240,
          label: AdminGridHeaderCell('السند'),
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

class _AdminAhadithGridSource extends DataGridSource {
  _AdminAhadithGridSource({
    required this.context,
    required this.ahadith,
    required this.onDelete,
    required this.onEdit,
    required this.onLinkExplaining,
    required this.onLinkSubValid,
  }) : _rows = ahadith
           .map(
             (hadith) => DataGridRow(
               cells: [
                 DataGridCell<String>(
                   columnName: 'source',
                   value: hadith.sourceName ?? 'غير محدد',
                 ),
                 DataGridCell<String>(
                   columnName: 'type',
                   value: _typeLabel(hadith.type),
                 ),
                 DataGridCell<String>(
                   columnName: 'number',
                   value: hadith.hadithNumber.toString(),
                 ),
                 DataGridCell<String>(
                   columnName: 'rawi',
                   value: hadith.rawiName ?? 'غير محدد',
                 ),
                 DataGridCell<String>(columnName: 'text', value: hadith.text),
                 DataGridCell<String>(
                   columnName: 'muhaddithRuling',
                   value: hadith.muhaddithRulingName ?? 'غير محدد',
                 ),
                 DataGridCell<String>(
                   columnName: 'finalRuling',
                   value: hadith.finalRulingName ?? 'غير محدد',
                 ),
                 DataGridCell<String>(
                   columnName: 'explaining',
                   value: hadith.explainingText ?? '',
                 ),
                 DataGridCell<String>(
                   columnName: 'subValid',
                   value: hadith.subValidText ?? '',
                 ),
                 DataGridCell<String>(
                   columnName: 'sanad',
                   value: hadith.sanad ?? 'غير محدد',
                 ),
                 DataGridCell<String>(columnName: 'actions', value: ''),
               ],
             ),
           )
           .toList();

  final BuildContext context;
  final List<Hadith> ahadith;
  final void Function(Hadith) onDelete;
  final void Function(Hadith) onEdit;
  final void Function(Hadith) onLinkExplaining;
  final void Function(Hadith) onLinkSubValid;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cs = Theme.of(context).colorScheme;
    final index = _rows.indexOf(row);
    final hadith = ahadith[index];
    final hasExplaining = hadith.explainingId?.isNotEmpty == true;
    final hasSubValid = hadith.subValid?.isNotEmpty == true;

    return DataGridRowAdapter(
      color: index.isEven ? cs.surface : cs.surface.withValues(alpha: 0.52),
      cells: [
        AdminGridCell(
          child: AdminGridText(hadith.sourceName ?? 'غير محدد', maxLines: 2),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridBadge(
            label: _typeLabel(hadith.type),
            backgroundColor: cs.primaryContainer.withValues(alpha: 0.34),
            foregroundColor: cs.onSurface,
          ),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridText(hadith.hadithNumber.toString()),
        ),
        AdminGridCell(
          child: AdminGridText(hadith.rawiName ?? 'غير محدد', maxLines: 2),
        ),
        AdminGridCell(child: AdminGridText(hadith.text, maxLines: 3)),
        AdminGridCell(
          child: AdminGridText(
            hadith.muhaddithRulingName ?? 'غير محدد',
            maxLines: 2,
          ),
        ),
        AdminGridCell(
          child: AdminGridText(
            hadith.finalRulingName ?? 'غير محدد',
            maxLines: 2,
          ),
        ),
        AdminGridCell(
          child: AdminGridActionButton(
            label: hasExplaining ? 'تعديل الشرح' : 'ربط شرح',
            icon: hasExplaining
                ? Icons.edit_note_rounded
                : Icons.add_link_rounded,
            onPressed: () => onLinkExplaining(hadith),
          ),
        ),
        AdminGridCell(
          child: AdminGridActionButton(
            label: hasSubValid ? 'تعديل الربط' : 'ربط حديث صحيح',
            icon: hasSubValid ? Icons.edit_outlined : Icons.add_link_rounded,
            onPressed: () => onLinkSubValid(hadith),
          ),
        ),
        AdminGridCell(
          child: AdminGridText(hadith.sanad ?? 'غير محدد', maxLines: 3),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridActionBar(
            children: [
              AdminGridIconAction(
                icon: Icons.edit_outlined,
                tooltip: 'تعديل الحديث',
                onPressed: () => onEdit(hadith),
              ),
              AdminGridIconAction(
                icon: Icons.delete_outline_rounded,
                tooltip: 'حذف الحديث',
                color: cs.error,
                onPressed: () => onDelete(hadith),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _typeLabel(HadithType type) {
    switch (type) {
      case HadithType.marfu:
        return 'مرفوع';
      case HadithType.mawquf:
        return 'موقوف';
      case HadithType.qudsi:
        return 'قدسي';
      case HadithType.atharSahaba:
        return 'آثار الصحابة';
    }
  }
}

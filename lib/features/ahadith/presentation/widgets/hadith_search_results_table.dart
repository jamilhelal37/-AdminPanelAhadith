import 'package:flutter/material.dart';

import '../../domain/models/hadith.dart';

class HadithSearchResultsTable extends StatelessWidget {
  const HadithSearchResultsTable({super.key, required this.ahadith});

  final List<Hadith> ahadith;

  static const String _emptyLabel = 'غير محدد';

  String _typeLabel(HadithType t) {
    switch (t) {
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

  String _nameFromRel(String? relName, String? id) {
    final name = relName?.trim();
    if (name != null && name.isNotEmpty) return name;
    if (id == null || id.isEmpty) return _emptyLabel;
    return id;
  }

  String _short(String? text, {int max = 90}) {
    if (text == null) return _emptyLabel;
    final t = text.trim();
    if (t.isEmpty) return _emptyLabel;
    if (t.length <= max) return t;
    return '${t.substring(0, max)}...';
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final verticalScrollController = ScrollController();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          thumbVisibility: true,
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Scrollbar(
                thumbVisibility: true,
                controller: verticalScrollController,
                child: SingleChildScrollView(
                  controller: verticalScrollController,
                  child: DataTable(
                    columnSpacing: 18,
                    columns: [
                      DataColumn(label: Text('الرقم')),
                      DataColumn(label: Text('النوع')),
                      DataColumn(label: Text('النص')),
                      DataColumn(label: Text('الراوي')),
                      DataColumn(label: Text('الكتاب')),
                      DataColumn(label: Text('حكم المحدث')),
                    ],
                    rows: ahadith.map((h) {
                      final rawiName = _nameFromRel(h.rawiName, h.rawiId);
                      final bookName = _nameFromRel(h.sourceName, h.sourceId);
                      final rulingName = _nameFromRel(
                        h.muhaddithRulingName,
                        h.muhaddithRulingId,
                      );

                      return DataRow(
                        cells: [
                          DataCell(Text('${h.hadithNumber}')),
                          DataCell(Text(_typeLabel(h.type))),
                          DataCell(
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 520),
                              child: Text(
                                _short(h.text, max: 140),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(Text(rawiName)),
                          DataCell(Text(bookName)),
                          DataCell(Text(rulingName)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:ahadith/core/presentation/widgets/core_actions_widget.dart';
import 'package:ahadith/core/presentation/widgets/golden_drawer.dart';
import 'package:flutter/material.dart';

import '../../domain/models/fake_ahadith.dart';
import '../widgets/fake_hadith_card_widget.dart';

class FakeHadithDetailScreen extends StatelessWidget {
  const FakeHadithDetailScreen({
    super.key,
    required this.fakeHadith,
    this.serialNumber = 1,
    this.showScaffold = true,
  });

  final FakeAhadith fakeHadith;
  final int serialNumber;
  final bool showScaffold;

  String get _formattedCreatedAt {
    final parsed = DateTime.tryParse(fakeHadith.createdAt);
    if (parsed == null) {
      return fakeHadith.createdAt;
    }

    final month = parsed.month.toString().padLeft(2, '0');
    final day = parsed.day.toString().padLeft(2, '0');
    return '${parsed.year}/$month/$day';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final content = Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          children: [
            Text(
              'حديث منتشر لا يصح :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.primary.withValues(alpha: 0.14)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: cs.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'تاريخ الإضافة : ',
                    style: TextStyle(fontSize: 14),
                  ),
                  Expanded(
                    child: Text(
                      _formattedCreatedAt,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            FakeHadithCard(
              fakeHadith: fakeHadith,
              serialNumber: serialNumber,
              showFullText: true,
              showDetailAction: false,
            ),
          ],
        ),
      ),
    );

    if (!showScaffold) {
      return content;
    }

    return Scaffold(
      endDrawer: const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: const [CoreActionsWidget()],
        title: const Text(
          'تفاصيل الحديث',
        ),
        centerTitle: true,
        backgroundColor: cs.surface,
        foregroundColor: cs.primary,
      ),
      body: content,
    );
  }
}



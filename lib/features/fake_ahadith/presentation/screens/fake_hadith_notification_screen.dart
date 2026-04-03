import 'package:ahadith/core/presentation/widgets/core_actions_widget.dart';
import 'package:ahadith/core/presentation/widgets/golden_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../router.dart';
import '../providers/fakeahadith_detail_provider.dart';
import 'fake_hadith_detail_screen.dart';

class FakeHadithNotificationScreen extends ConsumerWidget {
  const FakeHadithNotificationScreen({super.key, required this.fakeAhadithId});

  final String fakeAhadithId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(fakeAhadithByIdProvider(fakeAhadithId));
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      endDrawer: const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => context.goNamed(AppRouteNames.home),
          tooltip:
              'العودة إلى الرئيسية',
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: const [CoreActionsWidget()],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.highlight_off_rounded, color: cs.error, size: 24),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'انتبه حديث منتشر لا يصح',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: cs.surface,
        foregroundColor: cs.primary,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: asyncValue.when(
          data: (fakeAhadith) {
            if (fakeAhadith == null) {
              return Center(
                child: Text(
                  'تعذر العثور على الحديث المطلوب',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              );
            }

            return FakeHadithDetailScreen(
              fakeHadith: fakeAhadith,
              serialNumber: 1,
              showScaffold: false,
            );
          },
          loading: () =>
              Center(child: CircularProgressIndicator(color: cs.primary)),
          error: (error, stackTrace) => Center(
            child: Text(
              'تعذر تحميل الحديث',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}




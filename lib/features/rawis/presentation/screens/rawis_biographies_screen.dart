import 'package:flutter/material.dart';
import 'package:ahadith/core/presentation/widgets/core_actions_widget.dart';
import 'package:ahadith/core/presentation/widgets/biography_card_widget.dart';
import 'package:ahadith/core/presentation/widgets/golden_drawer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/admin_rawi_future_provider.dart';

/// Rawis biographies screen
class RawisBiographiesScreen extends ConsumerWidget {
  const RawisBiographiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawisAsync = ref.watch(adminRawisFutureProvider);

    return Scaffold(
      endDrawer: const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: const [CoreActionsWidget()],
        title: Text('تراجم الرواة'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: rawisAsync.when(
          data: (rawis) {
            final sorted = [...rawis]
              ..sort((a, b) => a.name.trim().compareTo(b.name.trim()));

            if (sorted.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد سير متاحة',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sorted.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final rawi = sorted[index];
                final about = rawi.about.trim().isEmpty ? '-' : rawi.about;
                final copyText = '${rawi.name}\n\n$about';

                return BiographyCardWidget(
                  serialNumber: index + 1,
                  name: rawi.name,
                  biography: about,
                  sectionLabel:
                      'تراجم الرواة',
                  onShare: () {
                    Share.share(copyText, subject: rawi.name);
                  },
                  onCopy: () async {
                    await Clipboard.setData(ClipboardData(text: copyText));

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'تم نسخ النص إلى الحافظة',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          error: (error, stack) => Center(
            child: Text(
              'خطأ في تحميل السير',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}



import 'package:ahadith/core/presentation/widgets/core_actions_widget.dart';
import 'package:ahadith/core/presentation/widgets/golden_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/presentation/widgets/hadith_card_widget.dart';
import '../../../../router.dart';
import '../../../books/domain/models/book.dart';
import '../../../books/presentation/providers/admin_book_future_provider.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../../fake_ahadith/presentation/widgets/fake_hadith_card_widget.dart';
import '../../domain/models/hadith.dart';
import '../models/sub_valid_screen_args.dart';
import '../providers/hadith_by_id_provider.dart';

class SubValidHadithScreen extends ConsumerWidget {
  const SubValidHadithScreen({super.key, required this.args});

  final SubValidScreenArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final subValidId = args.subValidId;
    final subValidAsync = subValidId == null || subValidId.isEmpty
        ? null
        : ref.watch(hadithByIdProvider(subValidId));

    return Scaffold(
      endDrawer: const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: const [CoreActionsWidget()],
        title: const Text(
          'الصحيح البديل',
        ),
        centerTitle: true,
        backgroundColor: cs.surface,
        foregroundColor: cs.primary,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            children: [
              _buildSectionTitle(
                context,
                args.isHadith
                    ? 'الحديث :'
                    : 'حديث منتشر لا يصح :',
              ),
              const SizedBox(height: 8),
              _buildOriginalCard(ref),
              const SizedBox(height: 12),
              _buildSectionTitle(
                context,
                'الحديث الصحيح البديل :',
              ),
              const SizedBox(height: 8),
              if (subValidId == null || subValidId.isEmpty)
                _buildMissingSubValidCard(context)
              else
                _buildSubValidHadithCard(context, ref, subValidAsync!),
              const SizedBox(height: 12),
              _buildPageActionButtons(context, subValidAsync?.valueOrNull),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
    );
  }

  Widget _buildOriginalCard(WidgetRef ref) {
    final books = ref.watch(allBooksFutureProvider).value ?? const <Book>[];
    final booksById = {
      for (final book in books)
        if (book.id != null) book.id!: book,
    };

    if (args.isHadith && args.hadith != null) {
      final hadith = args.hadith!;
      return HadithCard(
        hadith: hadith,
        muhaddithName: booksById[hadith.sourceId]?.muhaddithName,
        showActionButtons: false,
      );
    }

    if (!args.isHadith && args.fakeHadith != null) {
      return FakeHadithCard(
        fakeHadith: args.fakeHadith!,
        serialNumber: 1,
        showActionButtons: true,
        showSubValidAction: false,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSubValidHadithCard(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<Hadith> subValidAsync,
  ) {
    final books = ref.watch(allBooksFutureProvider).value ?? const <Book>[];
    final booksById = {
      for (final book in books)
        if (book.id != null) book.id!: book,
    };
    final favoritesAsync = ref.watch(userFavoritesStreamProvider);
    final favoriteHadithIds = <String>{
      for (final fav in favoritesAsync.value ?? const [])
        if (fav.hadithId != null) fav.hadithId!,
    };

    return subValidAsync.when(
      data: (subValidHadith) {
        return HadithCard(
          hadith: subValidHadith,
          muhaddithName: booksById[subValidHadith.sourceId]?.muhaddithName,
          isFavorite:
              subValidHadith.id != null &&
              favoriteHadithIds.contains(subValidHadith.id),
          onTap: () {
            context.pushNamed(
              AppRouteNames.hadithDetail,
              extra: subValidHadith,
            );
          },
          onInfo: () {
            context.pushNamed(
              AppRouteNames.hadithDetail,
              extra: subValidHadith,
            );
          },
          onFavorite: () async {
            final hadithId = subValidHadith.id;
            if (hadithId == null) return;

            final isFav = favoriteHadithIds.contains(hadithId);
            try {
              await ref
                  .read(toggleFavoriteProvider.notifier)
                  .toggleFavorite(hadithId, isFav);

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFav
                        ? 'تمت إزالة الحديث من المفضلة'
                        : 'تمت إضافة الحديث إلى المفضلة',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            } catch (_) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'تعذر تحديث المفضلة، حاول مرة أخرى',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Theme.of(context).colorScheme.surface, border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      error: (error, _) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Theme.of(context).colorScheme.surface, border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
        child: Text(
          'تعذر تحميل بطاقة الصحيح البديل',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }

  Widget _buildPageActionButtons(BuildContext context, Hadith? subValidHadith) {
    final cs = Theme.of(context).colorScheme;

    Future<void> copyPage() async {
      await Clipboard.setData(
        ClipboardData(text: _buildPageContent(subValidHadith)),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'تم نسخ محتوى الصفحة بالكامل',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    void sharePage() {
      Share.share(
        _buildPageContent(subValidHadith),
        subject: 'الصحيح البديل',
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: copyPage,
            icon: const Icon(Icons.content_copy_rounded),
            label: const Text('نسخ الصفحة'),
            style: OutlinedButton.styleFrom(
              foregroundColor: cs.primary,
              side: BorderSide(color: cs.primary.withValues(alpha: 0.35)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: sharePage,
            icon: const Icon(Icons.ios_share_rounded),
            label: const Text(
              'مشاركة الصفحة',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: cs.primary,
              side: BorderSide(color: cs.primary.withValues(alpha: 0.35)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _buildPageContent(Hadith? subValidHadith) {
    final buffer = StringBuffer();

    if (args.isHadith && args.hadith != null) {
      final hadith = args.hadith!;
      buffer.writeln('الحديث:');
      buffer.writeln(hadith.text);
      buffer.writeln('');
      buffer.writeln('الرقم: ${hadith.hadithNumber}');
      buffer.writeln(
        'خلاصة حكم المحدث: ${hadith.muhaddithRulingName ?? '-'}',
      );
      buffer.writeln('الراوي: ${hadith.rawiName ?? '-'}');
      buffer.writeln('المصدر: ${hadith.sourceName ?? '-'}');
    } else if (!args.isHadith && args.fakeHadith != null) {
      final fakeHadith = args.fakeHadith!;
      buffer.writeln(
        'حديث منتشر لا يصح:',
      );
      buffer.writeln(fakeHadith.text);
      buffer.writeln('');
      buffer.writeln('رقم التسلسل: 1');
      buffer.writeln(
        'الدرجة: ${fakeHadith.rulingName ?? 'غير محدد'}',
      );
    }

    buffer.writeln('');
    buffer.writeln(
      'الحديث الصحيح البديل:',
    );
    if (subValidHadith != null) {
      buffer.writeln(subValidHadith.text);
      buffer.writeln('');
      buffer.writeln('الرقم: ${subValidHadith.hadithNumber}');
      buffer.writeln(
        'خلاصة حكم المحدث: ${subValidHadith.muhaddithRulingName ?? '-'}',
      );
      buffer.writeln(
        'الراوي: ${subValidHadith.rawiName ?? '-'}',
      );
      buffer.writeln(
        'المصدر: ${subValidHadith.sourceName ?? '-'}',
      );
    } else {
      buffer.writeln(
        args.subValidText?.trim().isNotEmpty == true
            ? args.subValidText!.trim()
            : 'لا يوجد حديث صحيح بديل مرتبط بهذا النص.',
      );
    }

    return buffer.toString().trim();
  }

  Widget _buildMissingSubValidCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Theme.of(context).colorScheme.surface, border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
      child: Text(
        'لا يوجد حديث صحيح بديل مرتبط بهذا النص.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }
}





import 'package:ahadith/core/presentation/widgets/core_actions_widget.dart';
import 'package:flutter/material.dart';
import 'package:ahadith/core/presentation/widgets/golden_drawer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../favorites/presentation/providers/favorites_provider.dart';
import '../../../settings/presentation/widgets/app_reading_preferences_scope.dart';
import '../../domain/models/hadith.dart';

class HadithDetailScreen extends ConsumerWidget {
  final Hadith hadith;
  final String? appBarTitle;

  const HadithDetailScreen({super.key, required this.hadith, this.appBarTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayText = AppReadingPreferencesScope.resolveDisplayText(
      context,
      text: hadith.text,
      normalText: hadith.normalText,
    );
    final hadithId = hadith.id ?? '';
    final isFavoriteAsync = hadithId.isEmpty
        ? const AsyncValue<bool>.data(false)
        : ref.watch(isFavoriteProvider(hadithId));
    final toggleFavorite = ref.read(toggleFavoriteProvider.notifier);

    return Scaffold(
      endDrawer: const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
        title: Text(
          appBarTitle ?? 'عرض التفاصيل',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.primary),
          onPressed: () => context.pop(),
        ),
        actions: const [CoreActionsWidget()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              isFavoriteAsync.when(
                data: (isFavorite) {
                  return _buildHadithCard(
                    context,
                    displayText: displayText,
                    actions: _buildActionsRow(
                      context,
                      isFavorite: isFavorite,
                      onToggleFavorite: hadithId.isEmpty
                          ? null
                          : () async {
                              await toggleFavorite.toggleFavorite(
                                hadithId,
                                isFavorite,
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isFavorite
                                        ? 'تمت إزالة الحديث من المفضلة'
                                        : 'تمت إضافة الحديث إلى المفضلة',
                                  ),
                                ),
                              );
                            },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => Center(
                  child: Text(
                    'تعذر تحميل حالة المفضلة',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if ((hadith.explainingText ?? '').trim().isNotEmpty) ...[
                _buildSectionCard(
                  context,
                  title: 'شرح الحديث :',
                  icon: Icons.menu_book_outlined,
                  content: hadith.explainingText!,
                  actions: _buildSectionActions(
                    context,
                    onCopy: () => _copySectionText(
                      context,
                      title: 'شرح الحديث',
                      content: hadith.explainingText!,
                    ),
                    onShare: () => _shareSectionText(
                      title: 'شرح الحديث',
                      content: hadith.explainingText!,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              _buildPageActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHadithCard(
    BuildContext context, {
    required String displayText,
    required Widget actions,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasTopics =
        hadith.relatedTopics != null && hadith.relatedTopics!.isNotEmpty;

    return Card(
      color: colorScheme.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.8),
        ),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: 0.12),
                      ),
                      child: Icon(
                        Icons.article_outlined,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'بيانات الحديث :',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.start,
                  runSpacing: 8,
                  spacing: 8,
                  children: [
                    _buildTopBadge(
                      context,
                      icon: Icons.format_list_numbered_rounded,
                      text:
                          'رقم الحديث ${hadith.hadithNumber}',
                    ),
                    _buildTopBadge(
                      context,
                      icon: Icons.menu_book_rounded,
                      text: _displayValue(hadith.sourceName),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.28,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Text(
                    displayText,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
                const SizedBox(height: 14),
                _buildDivider(context),
                const SizedBox(height: 14),
                _buildMetadataRow(
                  context,
                  label:
                      'خلاصة حكم المحدث',
                  value: hadith.muhaddithRulingName,
                ),
                const SizedBox(height: 6),
                _buildMetadataRow(
                  context,
                  label:
                      'الحكم النهائي',
                  value: hadith.finalRulingName,
                ),
                const SizedBox(height: 6),
                _buildMetadataRow(
                  context,
                  label: 'الراوي',
                  value: hadith.rawiName,
                ),
                const SizedBox(height: 14),
                _buildSubsectionHeader(
                  context,
                  icon: Icons.topic_outlined,
                  title:
                      'التصنيف الموضوعي :',
                ),
                const SizedBox(height: 10),
                if (hasTopics) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: hadith.relatedTopics!
                        .map((topic) => _buildTopicChip(context, topic))
                        .toList(),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.18,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.35,
                        ),
                      ),
                    ),
                    child: Text(
                      'لا توجد موضوعات مرتبطة',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                _buildDivider(context),
                const SizedBox(height: 10),
                actions,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBadge(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSubsectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: Icon(icon, size: 16, color: colorScheme.primary),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildTopicChip(BuildContext context, String topic) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.65),
        ),
      ),
      child: Text(
        topic,
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 1,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.5),
    );
  }

  Widget _buildMetadataRow(
    BuildContext context, {
    required String label,
    required String? value,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: RichText(
        textDirection: TextDirection.rtl,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            TextSpan(
              text: _displayValue(value),
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsRow(
    BuildContext context, {
    required bool isFavorite,
    required VoidCallback? onToggleFavorite,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          _buildActionChip(
            context,
            label: 'نسخ',
            icon: Icons.content_copy,
            onPressed: () => _copyHadith(context),
          ),
          _buildActionChip(
            context,
            label: isFavorite
                ? 'إزالة'
                : 'مفضلة',
            icon: isFavorite ? Icons.bookmark : Icons.bookmark_border,
            onPressed: onToggleFavorite,
          ),
          _buildActionChip(
            context,
            label: 'مشاركة',
            icon: Icons.share_rounded,
            onPressed: _shareHadith,
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ActionChip(
        onPressed: onPressed,
        avatar: Icon(
          icon,
          size: 16,
          color: enabled
              ? colorScheme.primary
              : colorScheme.primary.withValues(alpha: 0.35),
        ),
        label: Text(
          label,
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: colorScheme.surface,
        side: BorderSide(
          color: enabled
              ? colorScheme.primary.withValues(alpha: 0.35)
              : colorScheme.outline.withValues(alpha: 0.35),
          width: 0.9,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
    );
  }

  Widget _buildSectionActions(
    BuildContext context, {
    required VoidCallback onCopy,
    required VoidCallback onShare,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          _buildActionChip(
            context,
            label: 'نسخ',
            icon: Icons.content_copy,
            onPressed: onCopy,
          ),
          _buildActionChip(
            context,
            label: 'مشاركة',
            icon: Icons.share_rounded,
            onPressed: onShare,
          ),
        ],
      ),
    );
  }

  Widget _buildPageActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildWideActionButton(
            context,
            label: 'نسخ الصفحة',
            icon: Icons.content_copy_rounded,
            onPressed: () => _copyHadith(context),
            expand: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildWideActionButton(
            context,
            label: 'مشاركة الصفحة',
            icon: Icons.share_rounded,
            onPressed: _shareHadith,
            expand: true,
          ),
        ),
      ],
    );
  }

  Widget _buildWideActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool expand = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.16),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String content,
    Widget? actions,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.8),
        ),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(icon, color: colorScheme.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.22,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.45),
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Text(
                content,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            if (actions != null) ...[const SizedBox(height: 12), actions],
          ],
        ),
      ),
    );
  }

  Future<void> _copyHadith(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _buildShareText()));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم نسخ الحديث بنجاح',
        ),
      ),
    );
  }

  void _shareHadith() {
    Share.share(
      _buildShareText(),
      subject:
          'حديث من الموسوعة الحديثية',
    );
  }

  Future<void> _copySectionText(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    await Clipboard.setData(ClipboardData(text: '$title:\n$content'));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ $title بنجاح'),
      ),
    );
  }

  void _shareSectionText({required String title, required String content}) {
    Share.share('$title:\n$content', subject: title);
  }

  String _buildShareText() {
    final buffer = StringBuffer()
      ..writeln('نص الحديث:')
      ..writeln(hadith.text)
      ..writeln()
      ..writeln(
        'خلاصة حكم المحدث: ${_displayValue(hadith.muhaddithRulingName)}',
      )
      ..writeln(
        'الحكم النهائي: ${_displayValue(hadith.finalRulingName)}',
      )
      ..writeln('الراوي: ${_displayValue(hadith.rawiName)}')
      ..writeln(
        'المصدر: ${_displayValue(hadith.sourceName)}',
      )
      ..writeln(
        'الصفحة أو الرقم: ${hadith.hadithNumber}',
      );

    if (hadith.relatedTopics != null && hadith.relatedTopics!.isNotEmpty) {
      buffer.writeln(
        'الموضوعات: ${hadith.relatedTopics!.join(' - ')}',
      );
    }

    if ((hadith.explainingText ?? '').trim().isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('شرح الحديث:')
        ..writeln(hadith.explainingText);
    }

    return buffer.toString();
  }

  String _displayValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }
    return value;
  }
}



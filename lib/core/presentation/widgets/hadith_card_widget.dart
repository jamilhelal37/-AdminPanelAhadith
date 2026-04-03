import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';

import '../../../features/ahadith/domain/models/hadith.dart';
import '../../../features/ahadith/presentation/models/sub_valid_screen_args.dart';
import '../../../features/ahadith/presentation/screens/hadith_origin_screen.dart';
import '../../../features/ahadith/presentation/screens/sub_valid_hadith_screen.dart';
import '../../../features/auth/domain/models/app_user.dart';
import '../../../features/auth/presentation/providers/auth_notifier_provider.dart';
import '../../../features/comment/data/repositories/comment_repository_provider.dart';
import '../../../features/comment/domain/models/comment.dart';
import '../../../features/comment/presentation/providers/comment_feed_provider.dart';
import '../../../features/similar_ahadith/domain/models/similar_ahadith.dart';
import '../../../router.dart';
import '../../../features/settings/presentation/widgets/app_reading_preferences_scope.dart';

class HadithCard extends ConsumerStatefulWidget {
  const HadithCard({
    super.key,
    required this.hadith,
    this.serialNumber,
    this.muhaddithName,
    this.onTap,
    this.onInfo,
    this.onFavorite,
    this.similarAhadiths = const <SimilarAhadith>[],
    this.isFavorite = false,
    this.showActionButtons = true,
    this.margin = const EdgeInsets.only(bottom: 16),
  });

  final Hadith hadith;
  final int? serialNumber;
  final String? muhaddithName;
  final VoidCallback? onTap;
  final VoidCallback? onInfo;
  final VoidCallback? onFavorite;
  final List<SimilarAhadith> similarAhadiths;
  final bool isFavorite;
  final bool showActionButtons;
  final EdgeInsetsGeometry margin;

  @override
  ConsumerState<HadithCard> createState() => _HadithCardState();
}

class _HadithCardState extends ConsumerState<HadithCard> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hadithId = widget.hadith.id?.trim();
    final hasHadithId = hadithId != null && hadithId.isNotEmpty;
    final resolvedHadithId = hadithId ?? '';
    final currentUser = ref.watch(authNotifierProvider).valueOrNull;
    final isScholar = currentUser?.type == UserType.scholar;
    final hadithComments = hasHadithId
        ? ref.watch(commentsByHadithProvider(resolvedHadithId))
        : const <Comment>[];
    final scholarOwnComment = (isScholar && hasHadithId)
        ? ref.watch(ownScholarCommentByHadithProvider(resolvedHadithId))
        : null;
    final displayText = AppReadingPreferencesScope.resolveDisplayText(
      context,
      text: widget.hadith.text,
      normalText: widget.hadith.normalText,
    );

    return Card(
      color: cs.surface,
      elevation: 0,
      margin: widget.margin,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.8)),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(14.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMetadata(displayText),
              if (widget.showActionButtons)
                _buildActionButtons(
                  commentCount: hadithComments.length,
                  canScholarComment: isScholar && hasHadithId,
                  ownComment: scholarOwnComment,
                  currentUserId: currentUser?.id,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetadata(String displayText) {
    final hadith = widget.hadith;
    final muhaddithName = widget.muhaddithName ?? '-';
    final serialPrefix = widget.serialNumber != null
        ? '${widget.serialNumber}- '
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReadMoreText(
            '$serialPrefix$displayText',
            textDirection: TextDirection.rtl,
            trimMode: TrimMode.Line,
            trimLines: 4,
            trimCollapsedText: '\nعرض المزيد ...',
            trimExpandedText: '\nعرض أقل',
            moreStyle: TextStyle(fontSize: 14),
            lessStyle: TextStyle(fontSize: 14),
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 10),
          _buildMetadataRow(
            label:
                'خلاصة حكم المحدث',
            value: hadith.muhaddithRulingName ?? '-',
          ),
          const SizedBox(height: 4),
          _buildMetadataRow(
            label: 'الراوي',
            value: hadith.rawiName ?? '-',
          ),
          const SizedBox(height: 4),
          _buildMetadataRow(
            label: 'المحدث',
            value: muhaddithName,
          ),
          const SizedBox(height: 4),
          _buildMetadataRow(
            label: 'المصدر',
            value: hadith.sourceName ?? '-',
          ),
          const SizedBox(height: 4),
          _buildMetadataRow(
            label: 'الرقم',
            value: hadith.hadithNumber.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow({
    required String label,
    required String value,
    double fontSize = 15,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: RichText(
        textDirection: TextDirection.rtl,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                fontSize: fontSize,
                color: Colors.green[700],
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                fontSize: fontSize,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTextDialog({required String title, required String content}) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, textDirection: TextDirection.rtl),
          content: SingleChildScrollView(
            child: Text(
              content,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }

  void _openSubValidScreen() {
    final subValidId = widget.hadith.subValid;
    final subValidText = widget.hadith.subValidText?.trim();

    if ((subValidId == null || subValidId.isEmpty) &&
        (subValidText == null || subValidText.isEmpty)) {
      _showTextDialog(
        title: 'الصحيح البديل',
        content:
            'لا توجد بيانات للحديث البديل لهذا الحديث.',
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SubValidHadithScreen(
          args: SubValidScreenArgs(isHadith: true, hadith: widget.hadith),
        ),
      ),
    );
  }

  void _openSimilarAhadithScreen() {
    context.pushNamed(
      AppRouteNames.similarAhadith,
      extra: {
        'mainHadith': widget.hadith,
        'similarAhadiths': widget.similarAhadiths,
      },
    );
  }

  void _openHadithOriginScreen() {
    final sanad = widget.hadith.sanad?.trim();

    if (sanad == null || sanad.isEmpty) {
      _showTextDialog(
        title: 'أصل الحديث',
        content:
            'لا يوجد سند متاح لهذا الحديث.',
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => HadithOriginScreen(originText: sanad),
      ),
    );
  }

  void _openHadithInfo() {
    if (widget.onInfo != null) {
      widget.onInfo!();
      return;
    }
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }
    _showTextDialog(
      title: 'معلومات الحديث',
      content: AppReadingPreferencesScope.resolveDisplayText(
        context,
        text: widget.hadith.text,
        normalText: widget.hadith.normalText,
      ),
    );
  }

  Future<void> _copyToClipboard() async {
    final hadith = widget.hadith;
    final muhaddithName = widget.muhaddithName ?? '-';

    final StringBuffer buffer = StringBuffer()
      ..writeln('نص الحديث:')
      ..writeln(hadith.text)
      ..writeln()
      ..writeln(
        'خلاصة حكم المحدث: ${hadith.muhaddithRulingName ?? '-'}',
      )
      ..writeln('الراوي: ${hadith.rawiName ?? '-'}')
      ..writeln('المحدث: $muhaddithName')
      ..writeln('المصدر: ${hadith.sourceName ?? '-'}')
      ..writeln('الرقم: ${hadith.hadithNumber}');

    await Clipboard.setData(ClipboardData(text: buffer.toString()));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم نسخ الحديث بنجاح',
        ),
      ),
    );
  }

  void _shareHadith() {
    final hadith = widget.hadith;
    final muhaddithName = widget.muhaddithName ?? '-';

    final StringBuffer buffer = StringBuffer()
      ..writeln('نص الحديث:')
      ..writeln(hadith.text)
      ..writeln()
      ..writeln(
        'خلاصة حكم المحدث: ${hadith.muhaddithRulingName ?? '-'}',
      )
      ..writeln('الراوي: ${hadith.rawiName ?? '-'}')
      ..writeln('المحدث: $muhaddithName')
      ..writeln('المصدر: ${hadith.sourceName ?? '-'}')
      ..writeln('الرقم: ${hadith.hadithNumber}');

    Share.share(
      buffer.toString(),
      subject:
          'حديث من الموسوعة الحديثية',
    );
  }

  Widget _buildActionChip({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    bool enabled = true,
  }) {
    final cs = Theme.of(context).colorScheme;
    final iconColor = enabled ? cs.primary : cs.primary.withValues(alpha: 0.35);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ActionChip(
        onPressed: enabled ? onPressed : null,
        avatar: Icon(icon, color: iconColor, size: 16),
        label: Text(
          label,
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: cs.surface,
        side: BorderSide(
          color: enabled
              ? cs.primary.withValues(alpha: 0.35)
              : cs.outline.withValues(alpha: 0.35),
          width: 0.9,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
    );
  }

  Widget _buildActionButtons({
    required int commentCount,
    required bool canScholarComment,
    required Comment? ownComment,
    required String? currentUserId,
  }) {
    final hasSubValid =
        widget.hadith.subValidText != null &&
        widget.hadith.subValidText!.trim().isNotEmpty;
    final hasSimilar = widget.similarAhadiths.isNotEmpty;
    final hadithId = widget.hadith.id?.trim();
    final resolvedHadithId = hadithId ?? '';
    final hasHadithId = hadithId != null && hadithId.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            _buildActionChip(
              label: 'نسخ',
              icon: Icons.content_copy,
              onPressed: _copyToClipboard,
            ),
            if (widget.onFavorite != null)
              _buildActionChip(
                label: widget.isFavorite
                    ? 'إزالة'
                    : 'مفضلة',
                icon: widget.isFavorite
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                onPressed: widget.onFavorite,
              ),
            _buildActionChip(
              label: 'مشاركة',
              icon: Icons.share_rounded,
              onPressed: _shareHadith,
            ),
            _buildActionChip(
              label: 'عرض التفاصيل',
              icon: Icons.info_outline_rounded,
              onPressed: _openHadithInfo,
            ),
            if (hasSimilar)
              _buildActionChip(
                label: 'أحاديث مشابهة',
                icon: Icons.link_rounded,
                onPressed: _openSimilarAhadithScreen,
              ),
            if ((widget.hadith.sanad ?? '').trim().isNotEmpty)
              _buildActionChip(
                label: 'أصل الحديث',
                icon: Icons.account_tree_outlined,
                onPressed: _openHadithOriginScreen,
              ),
            if (hasSubValid)
              _buildActionChip(
                label: 'الصحيح البديل',
                icon: Icons.verified_outlined,
                onPressed: _openSubValidScreen,
              ),
            if (commentCount > 0 && hasHadithId)
              _buildActionChip(
                label:
                    'التعليقات ($commentCount)',
                icon: Icons.forum_outlined,
                onPressed: _openCommentsScreen,
              ),
            if (canScholarComment &&
                currentUserId != null &&
                currentUserId.isNotEmpty &&
                hasHadithId &&
                ownComment == null)
              _buildActionChip(
                label: 'إضافة تعليق',
                icon: Icons.mode_comment_outlined,
                onPressed: () => _openScholarCommentEditor(
                  currentUserId: currentUserId,
                  hadithId: resolvedHadithId,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openCommentsScreen() {
    context.pushNamed(AppRouteNames.hadithComments, extra: widget.hadith);
  }

  Future<void> _openScholarCommentEditor({
    required String currentUserId,
    required String hadithId,
    Comment? existingComment,
  }) async {
    final text = await showDialog<String>(
      context: context,
      builder: (_) => _ScholarCommentEditorDialog(
        title: existingComment == null
            ? 'إضافة تعليق'
            : 'تعديل التعليق',
        initialText: existingComment?.text ?? '',
      ),
    );

    if (text == null || text.trim().isEmpty) {
      return;
    }

    try {
      final repo = ref.read(commentRepositoryProvider);
      final now = DateTime.now().toIso8601String();

      if (existingComment == null || existingComment.id == null) {
        await repo.createComment(
          Comment(
            text: text.trim(),
            userId: currentUserId,
            hadithId: hadithId,
            createdAt: now,
            updatedAt: now,
          ),
        );
      } else {
        await repo.updateComment(
          existingComment.copyWith(text: text.trim(), updatedAt: now),
        );
      }

      ref.invalidate(allCommentsStreamProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            existingComment == null
                ? 'تمت إضافة التعليق بنجاح'
                : 'تم تحديث التعليق بنجاح',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تعذر حفظ التعليق: $error',
          ),
        ),
      );
    }
  }
}

class _ScholarCommentEditorDialog extends StatefulWidget {
  const _ScholarCommentEditorDialog({
    required this.title,
    required this.initialText,
  });

  final String title;
  final String initialText;

  @override
  State<_ScholarCommentEditorDialog> createState() =>
      _ScholarCommentEditorDialogState();
}

class _ScholarCommentEditorDialogState
    extends State<_ScholarCommentEditorDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialText,
  );
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title, textDirection: TextDirection.rtl),
      content: SizedBox(
        width: 420,
        child: TextField(
          controller: _controller,
          maxLines: 5,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            labelText: 'نص التعليق',
            hintText:
                'اكتب تعليقك هنا...',
            errorText: _errorText,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            final text = _controller.text.trim();
            if (text.isEmpty) {
              setState(() {
                _errorText =
                    'التعليق مطلوب';
              });
              return;
            }
            Navigator.of(context).pop(text);
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}

class HadithListTile extends StatelessWidget {
  const HadithListTile({
    super.key,
    required this.hadith,
    this.onTap,
    this.maxLines = 2,
  });

  final Hadith hadith;
  final VoidCallback? onTap;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final displayText = AppReadingPreferencesScope.resolveDisplayText(
      context,
      text: hadith.text,
      normalText: hadith.normalText,
    );
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            displayText,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
        subtitle: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'رقم ${hadith.hadithNumber} • ${hadith.sourceName ?? ""}',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}




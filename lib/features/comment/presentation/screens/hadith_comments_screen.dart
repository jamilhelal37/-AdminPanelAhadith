import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widgets/hadith_card_widget.dart';
import '../../../ahadith/domain/models/hadith.dart';
import '../../../auth/presentation/providers/auth_notifier_provider.dart';
import '../../data/repositories/comment_repository_provider.dart';
import '../../domain/models/comment.dart';
import '../providers/comment_feed_provider.dart';
import '../widgets/hadith_comment_card.dart';

class HadithCommentsScreen extends ConsumerWidget {
  const HadithCommentsScreen({super.key, required this.hadith});

  final Hadith hadith;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authNotifierProvider).valueOrNull;
    final currentUserId = currentUser?.id?.trim();
    final hadithId = hadith.id;
    final comments = hadithId == null
        ? const <Comment>[]
        : ref.watch(commentsByHadithProvider(hadithId));

    final authorIdsKey =
        comments
            .map((comment) => comment.userId?.trim())
            .whereType<String>()
            .where((id) => id.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    final authorsAsync = ref.watch(
      commentAuthorsByIdsProvider(authorIdsKey.join(',')),
    );
    final authorsMap = authorsAsync.valueOrNull ?? const {};
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
        title: const Text(
          'تعليقات الحديث',
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          children: [
            HadithCard(
              hadith: hadith,
              showActionButtons: false,
              margin: EdgeInsets.zero,
            ),
            const SizedBox(height: 14),
            _buildSummaryCard(context, comments.length),
            const SizedBox(height: 14),
            if (comments.isEmpty)
              _buildNoCommentsCard(context)
            else
              ...comments.map((comment) {
                final authorId = comment.userId?.trim();
                final profile = (authorId == null || authorId.isEmpty)
                    ? null
                    : authorsMap[authorId];
                final isOwnComment =
                    currentUserId != null &&
                    currentUserId.isNotEmpty &&
                    authorId == currentUserId;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: HadithCommentCard(
                    comment: comment,
                    scholarName: profile?.name ?? 'عالم',
                    scholarAvatarUrl: profile?.avatarUrl,
                    onEdit: isOwnComment
                        ? () => _editComment(context, ref, comment)
                        : null,
                    onDelete: isOwnComment
                        ? () => _deleteComment(context, ref, comment)
                        : null,
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Future<void> _editComment(
    BuildContext context,
    WidgetRef ref,
    Comment comment,
  ) async {
    final updatedText = await _showCommentEditorDialog(
      context,
      initialText: comment.text,
    );
    if (updatedText == null || updatedText.trim().isEmpty) {
      return;
    }

    try {
      final repo = ref.read(commentRepositoryProvider);
      await repo.updateComment(
        comment.copyWith(
          text: updatedText.trim(),
          updatedAt: DateTime.now().toIso8601String(),
        ),
      );
      if (!context.mounted) return;
      ref.invalidate(allCommentsStreamProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم تحديث التعليق بنجاح',
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تعذر تحديث التعليق: $error',
          ),
        ),
      );
    }
  }

  Future<void> _deleteComment(
    BuildContext context,
    WidgetRef ref,
    Comment comment,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'حذف التعليق',
            textDirection: TextDirection.rtl,
          ),
          content: const Text(
            'هل تريد حذف هذا التعليق؟',
            textDirection: TextDirection.rtl,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    final commentId = comment.id;
    if (commentId == null || commentId.isEmpty) return;

    try {
      final repo = ref.read(commentRepositoryProvider);
      await repo.deleteComment(commentId);
      if (!context.mounted) return;
      ref.invalidate(allCommentsStreamProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم حذف التعليق',
          ),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تعذر حذف التعليق: $error',
          ),
        ),
      );
    }
  }

  Future<String?> _showCommentEditorDialog(
    BuildContext context, {
    required String initialText,
  }) async {
    final controller = TextEditingController(text: initialText);
    String? errorText;

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'تعديل التعليق',
                textDirection: TextDirection.rtl,
              ),
              content: SizedBox(
                width: 420,
                child: TextField(
                  controller: controller,
                  maxLines: 5,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    labelText: 'نص التعليق',
                    hintText:
                        'اكتب تعليقك هنا...',
                    errorText: errorText,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isEmpty) {
                      setState(() {
                        errorText =
                            'التعليق مطلوب';
                      });
                      return;
                    }
                    Navigator.of(dialogContext).pop(text);
                  },
                  child: const Text('حفظ'),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();
    return result;
  }

  Widget _buildSummaryCard(BuildContext context, int count) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Theme.of(context).colorScheme.surface, border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withValues(alpha: 0.12),
            ),
            child: Icon(
              Icons.forum_outlined,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'إجمالي التعليقات',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: colorScheme.primary.withValues(alpha: 0.12),
            ),
            child: Text(
              '$count',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCommentsCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Theme.of(context).colorScheme.surface, border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            color: colorScheme.primary,
            size: 30,
          ),
          const SizedBox(height: 8),
          Text(
            'لا توجد تعليقات على هذا الحديث بعد',
            style: TextStyle(fontSize: 16, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}




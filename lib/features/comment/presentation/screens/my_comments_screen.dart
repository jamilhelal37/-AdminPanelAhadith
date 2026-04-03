import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../../../../core/presentation/widgets/hadith_card_widget.dart';
import '../../../auth/domain/models/app_user.dart';
import '../../../auth/presentation/providers/auth_notifier_provider.dart';
import '../../data/repositories/comment_repository_provider.dart';
import '../../domain/models/comment.dart';
import '../providers/comment_feed_provider.dart';
import '../widgets/hadith_comment_card.dart';
import '../widgets/my_comments_empty_state.dart';

class MyCommentsScreen extends ConsumerWidget {
  const MyCommentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authNotifierProvider).valueOrNull;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
        title: const Text('تعليقاتي'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _buildBody(context, ref, currentUser),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, AppUser? currentUser) {
    if (currentUser?.type != UserType.scholar) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'هذه الواجهة متاحة للحسابات من نوع عالم فقط.',
            style: TextStyle(fontSize: 16, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final allCommentsAsync = ref.watch(allCommentsStreamProvider);
    final myComments = ref.watch(myScholarCommentsProvider);

    return allCommentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'حدث خطأ أثناء تحميل التعليقات:\n$error',
            style: TextStyle(fontSize: 16, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      data: (_) {
        if (myComments.isEmpty) {
          return const MyCommentsEmptyState();
        }

        final hadithIds =
            myComments
                .map((comment) => comment.hadithId?.trim())
                .whereType<String>()
                .where((id) => id.isNotEmpty)
                .toSet()
                .toList()
              ..sort();

        final hadithMapAsync = ref.watch(
          hadithMapByIdsProvider(hadithIds.join(',')),
        );
        return hadithMapAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'تعذر تحميل الأحاديث المرتبطة بالتعليقات:\n$error',
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (hadithMap) {
            final grouped = _groupByHadith(myComments);
            final entries = grouped.entries.toList();

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final hadithId = entries[index].key;
                final comments = entries[index].value;
                final hadith = hadithMap[hadithId];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Theme.of(context).colorScheme.surface, border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
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
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.12),
                                ),
                                child: Icon(
                                  Icons.menu_book_outlined,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'الحديث ${index + 1}',
                                  style: TextStyle(fontSize: 16, height: 1.5),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.12),
                                ),
                                child: Text(
                                  '${comments.length} تعليق',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (hadith != null)
                            HadithCard(
                              hadith: hadith,
                              showActionButtons: false,
                              margin: EdgeInsets.zero,
                            )
                          else
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1), color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)),
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                'تعذر تحميل بيانات الحديث',
                                style: TextStyle(fontSize: 16, height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          const SizedBox(height: 12),
                          ...comments.asMap().entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: HadithCommentCard(
                                comment: entry.value,
                                scholarName:
                                    (currentUser?.name?.trim().isNotEmpty ??
                                        false)
                                    ? currentUser!.name!.trim()
                                    : 'أنا',
                                scholarAvatarUrl: currentUser?.avatarUrl,
                                onEdit: () =>
                                    _editComment(context, ref, entry.value),
                                onDelete: () =>
                                    _deleteComment(context, ref, entry.value),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Map<String, List<Comment>> _groupByHadith(List<Comment> comments) {
    final grouped = <String, List<Comment>>{};
    for (final comment in comments) {
      final hadithId = comment.hadithId?.trim();
      if (hadithId == null || hadithId.isEmpty) continue;
      grouped.putIfAbsent(hadithId, () => <Comment>[]).add(comment);
    }
    return grouped;
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
    await showDialog<void>(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'حذف التعليق',
        content:
            'هل تريد حذف هذا التعليق من واجهة تعليقاتي؟',
        confirmText: 'حذف',
        onConfirm: () async {
          final commentId = comment.id;
          if (commentId == null || commentId.isEmpty) return;

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
        },
      ),
    );
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
}




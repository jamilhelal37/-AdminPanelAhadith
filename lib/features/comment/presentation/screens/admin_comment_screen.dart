import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';

import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../../../../core/presentation/widgets/admin_pagination.dart';
import '../../../../core/presentation/widgets/empty_state_widget.dart';
import '../../../../core/presentation/widgets/search_field_widget.dart';

import '../../data/repositories/comment_repository_provider.dart';
import '../../domain/models/comment.dart';
import '../providers/admin_comment_future_provider.dart';
import '../providers/search_provider.dart';
import '../widgets/admin_comments_table.dart';
import '../widgets/comment_dialog.dart';

class AdminCommentScreen extends ConsumerStatefulWidget {
  const AdminCommentScreen({super.key});

  @override
  ConsumerState<AdminCommentScreen> createState() => _AdminCommentScreenState();
}

class _AdminCommentScreenState extends ConsumerState<AdminCommentScreen> {
  late final TextEditingController ctr;

  @override
  void initState() {
    super.initState();
    ctr = TextEditingController();
  }

  @override
  void dispose() {
    ctr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSearch = ref.watch(searchProvider);
    if (ctr.text != currentSearch) {
      ctr.value = ctr.value.copyWith(
        text: currentSearch,
        selection: TextSelection.collapsed(offset: currentSearch.length),
      );
    }

    final commentsAsync = ref.watch(adminCommentsFutureProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Row(
            children: [
              Expanded(
                child: SearchFieldWidget(
                  controller: ctr,
                  compact: true,
                  hintText: 'ابحث',
                  onChanged: (value) {
                    ref.read(searchProvider.notifier).state = value;
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => CommentDialog(
                      onSave: (comment) async {
                        try {
                          final repo = ref.read(commentRepositoryProvider);
                          await repo.createComment(comment);

                          ref.invalidate(adminCommentsFutureProvider);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم إنشاء التعليق بنجاح')),
                            );
                          }
                        } catch (e, st) {
                          debugPrint("CREATE COMMENT ERROR: $e");
                          debugPrint("$st");
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                          rethrow;
                        }
                      },
                    ),
                  );
                },
                label: Text('إنشاء تعليق'),
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: commentsAsync.when(
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            data: (data) {
              if (data.isEmpty) return EmptyStateWidget();

              return AdminPaginatedDataView<Comment>(
                items: data,
                stateKey: currentSearch.trim(),
                itemBuilder: (context, pageItems) => AdminCommentsTable(
                  comments: pageItems,
                  onDelete: (comment) =>
                      _showDeleteConfirmationDialog(context, comment),
                  onEdit: (comment) {
                    showDialog(
                      context: context,
                      builder: (_) => CommentDialog(
                        comment: comment,
                        onSave: (commentData) async {
                          try {
                            final repo = ref.read(commentRepositoryProvider);
                            await repo.updateComment(commentData);

                            ref.invalidate(adminCommentsFutureProvider);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('تم تحديث التعليق بنجاح'),
                                ),
                              );
                            }
                          } catch (e, st) {
                            debugPrint("UPDATE COMMENT ERROR: $e");
                            debugPrint("$st");
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                            rethrow;
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            },
            error: (error, stackTrace) =>
                EmptyStateWidget(message: 'خطأ في تحميل التعليقات'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Comment comment) {
    showDialog(
      context: context,
      builder: (dialogCtx) => ConfirmationDialog(
        title: 'حذف التعليق',
        content: 'هل أنت متأكد من حذف هذا التعليق؟',
        onConfirm: () async {
          try {
            if (comment.id == null) {
              throw AppFailure.validation('معرّف التعليق غير موجود.');
            }

            final repo = ref.read(commentRepositoryProvider);
            await repo.deleteComment(comment.id!);

            ref.invalidate(adminCommentsFutureProvider);

            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('تم حذف التعليق بنجاح')));
            }
          } catch (e, st) {
            debugPrint("DELETE COMMENT ERROR: $e");
            debugPrint("$st");
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(e.toString())));
            }
          }
        },
      ),
    );
  }
}

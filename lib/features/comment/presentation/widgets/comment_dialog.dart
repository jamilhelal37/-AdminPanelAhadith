import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/presentation/providers/loading_provider.dart';
import '../../domain/models/comment.dart';
import '../providers/comment_form_provider.dart';

const _commentDialogLoadingScope = 'comment-dialog';

class CommentDialog extends ConsumerStatefulWidget {
  const CommentDialog({super.key, this.comment, required this.onSave});
  final Comment? comment;
  final Future<void> Function(Comment) onSave;

  @override
  ConsumerState<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends ConsumerState<CommentDialog> {
  bool _hasTriggeredValidation = false;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.comment != null;
    final form = ref.watch(commentFormProvider(widget.comment));
    final colorScheme = Theme.of(context).colorScheme;

    if (!_hasTriggeredValidation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        form.markAllAsTouched();
        setState(() => _hasTriggeredValidation = true);
      });
    }

    return ReactiveForm(
      formGroup: form,
      child: AlertDialog(
        title: Text(isEditing ? 'تعديل تعليق' : 'إنشاء تعليق'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReactiveTextField<String>(
                  formControlName: "text",
                  decoration: InputDecoration(
                    labelText: 'النص',
                    errorStyle: TextStyle(color: colorScheme.error),
                  ),
                  maxLines: 3,
                  validationMessages: {
                    ValidationMessage.required: (_) => 'النص مطلوب',
                  },
                ),
                const SizedBox(height: 10),
                ReactiveTextField<String>(
                  formControlName: "userId",
                  decoration: InputDecoration(
                    labelText: 'معرّف المستخدم',
                    errorStyle: TextStyle(color: colorScheme.error),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (_) => 'معرّف المستخدم مطلوب',
                  },
                ),
                const SizedBox(height: 10),
                ReactiveTextField<String>(
                  formControlName: "hadithId",
                  decoration: InputDecoration(
                    labelText: 'معرّف الحديث',
                    errorStyle: TextStyle(color: colorScheme.error),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (_) => 'معرّف الحديث مطلوب',
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text('إلغاء')),
          ReactiveFormConsumer(
            builder: (context, formGroup, child) {
              final isLoading = ref.watch(
                scopedLoadingProvider(_commentDialogLoadingScope),
              );

              return ElevatedButton(
                onPressed: (!formGroup.valid || isLoading)
                    ? null
                    : () async {
                        ref
                                .read(
                                  scopedLoadingProvider(
                                    _commentDialogLoadingScope,
                                  ).notifier,
                                )
                                .state =
                            true;
                        try {
                          final now = DateTime.now().toIso8601String();

                          final text =
                              (formGroup.control('text').value as String?)
                                  ?.trim() ??
                              '';
                          final userId =
                              (formGroup.control('userId').value as String?)
                                  ?.trim() ??
                              '';
                          final hadithId =
                              (formGroup.control('hadithId').value as String?)
                                  ?.trim() ??
                              '';

                          final comment = Comment(
                            id: widget.comment?.id,
                            text: text,
                            userId: userId,
                            hadithId: hadithId,
                            createdAt: widget.comment?.createdAt ?? now,
                            updatedAt: now,
                          );

                          debugPrint("COMMENT SAVE START id=${comment.id}");
                          await widget.onSave(comment);
                          debugPrint("COMMENT SAVE DONE");

                          if (!mounted) return;
                          // ignore: use_build_context_synchronously
                          context.pop();
                        } catch (e, st) {
                          debugPrint("COMMENT SAVE ERROR: $e");
                          debugPrint("$st");
                          if (!mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        } finally {
                          if (mounted) {
                            ref
                                    .read(
                                      scopedLoadingProvider(
                                        _commentDialogLoadingScope,
                                      ).notifier,
                                    )
                                    .state =
                                false;
                          }
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('حفظ'),
              );
            },
          ),
        ],
      ),
    );
  }
}

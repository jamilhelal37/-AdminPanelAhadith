import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/presentation/providers/loading_provider.dart';
import '../../domain/models/topic_class.dart';
import '../providers/topic_class_form_provider.dart';

const _topicClassDialogLoadingScope = 'topic-class-dialog';

class TopicClassDialog extends ConsumerStatefulWidget {
  const TopicClassDialog({super.key, this.topicClass, required this.onSave});
  final TopicClass? topicClass;
  final Future<void> Function(TopicClass) onSave;

  @override
  ConsumerState<TopicClassDialog> createState() => _TopicClassDialogState();
}

class _TopicClassDialogState extends ConsumerState<TopicClassDialog> {
  bool _hasTriggeredValidation = false;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.topicClass != null;
    final form = ref.watch(topicClassFormProvider(widget.topicClass));
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
        title: Text(isEditing ? 'تعديل تصنيف موضوع' : 'إنشاء تصنيف موضوع'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReactiveTextField<String>(
                  formControlName: "topicId",
                  decoration: InputDecoration(
                    labelText: 'معرّف الموضوع',
                    errorStyle: TextStyle(color: colorScheme.error),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (_) => 'معرّف الموضوع مطلوب',
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
                scopedLoadingProvider(_topicClassDialogLoadingScope),
              );

              return ElevatedButton(
                onPressed: (!formGroup.valid || isLoading)
                    ? null
                    : () async {
                        ref
                                .read(
                                  scopedLoadingProvider(
                                    _topicClassDialogLoadingScope,
                                  ).notifier,
                                )
                                .state =
                            true;
                        try {
                          final now = DateTime.now().toIso8601String();

                          final topicId =
                              (formGroup.control('topicId').value as String?)
                                  ?.trim() ??
                              '';
                          final hadithId =
                              (formGroup.control('hadithId').value as String?)
                                  ?.trim() ??
                              '';

                          final topicClass = TopicClass(
                            id: widget.topicClass?.id,
                            topicId: topicId,
                            hadithId: hadithId,
                            createdAt: widget.topicClass?.createdAt ?? now,
                            updatedAt: now,
                          );

                          debugPrint(
                            "TOPIC CLASS SAVE START id=${topicClass.id}",
                          );
                          await widget.onSave(topicClass);
                          debugPrint("TOPIC CLASS SAVE DONE");

                          if (!mounted) return;
                          context.pop();
                        } catch (e, st) {
                          debugPrint("TOPIC CLASS SAVE ERROR: $e");
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
                                        _topicClassDialogLoadingScope,
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

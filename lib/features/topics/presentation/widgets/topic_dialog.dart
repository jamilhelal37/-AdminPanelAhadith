import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/presentation/providers/loading_provider.dart';
import '../../domain/models/topic.dart';
import '../providers/topic_form_provider.dart';

const _topicDialogLoadingScope = 'topic-dialog';

class TopicDialog extends ConsumerStatefulWidget {
  const TopicDialog({super.key, this.topic, required this.onSave});
  final Topic? topic;
  final Function(Topic?) onSave;

  @override
  ConsumerState<TopicDialog> createState() => _TopicDialogState();
}

class _TopicDialogState extends ConsumerState<TopicDialog> {
  bool _hasTriggeredValidation = false;

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.topic != null;
    final form = ref.watch(topicFormProvider(widget.topic));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    if (!_hasTriggeredValidation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          form.markAllAsTouched();
          setState(() {
            _hasTriggeredValidation = true;
          });
        }
      });
    }

    return ReactiveForm(
      formGroup: form,
      child: AlertDialog(
        title: Text('الموضوع'),
        content: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              ReactiveTextField(
                formControlName: "name",
                decoration: InputDecoration(
                  labelText: 'العنوان',
                  errorStyle: TextStyle(color: colorScheme.error),
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'الاسم مطلوب',
                },
              ),
              // ReactiveDropdownField<District>(
              //   formControlName: "district",
              //   items: District.values
              //       .map(
              //         (e) => DropdownMenuItem(
              //           value: e,
              //           child: Text(
              //             (e.name[0].toUpperCase() + e.name.substring(1)),
              //           ),
              //         ),
              //       )
              //       .toList(),
              //   decoration: InputDecoration(
              //     labelText: 'المنطقة',
              //     errorStyle: TextStyle(color: colorScheme.error),
              //   ),
              //   validationMessages: {
              //     ValidationMessage.required: (_) =>
              //         'المنطقة مطلوب',
              //   },
              // ),
              //       ReactiveTextField(
              //         formControlName: "description",
              //         decoration: InputDecoration(
              //           labelText: 'الوصف',
              //           errorStyle: TextStyle(color: colorScheme.error),
              //         ),
              //         maxLines: 3,
              //         validationMessages: {
              //           ValidationMessage.required: (_) =>
              //               'الوصف مطلوب',
              //         },
              //       ),
              //       ReactiveSwitchListTile(
              //         title: Text('منشور'),
              //         formControlName: "isPublished",
              //       ),
            ],
          ),
        ),

        actions: [
          TextButton(onPressed: () => context.pop(), child: Text('إلغاء')),
          ReactiveFormConsumer(
            builder: (context, formGroup, child) {
              final isLoading = ref.watch(
                scopedLoadingProvider(_topicDialogLoadingScope),
              );
              return ElevatedButton(
                onPressed: formGroup.valid && !isLoading
                    ? () async {
                        ref
                                .read(
                                  scopedLoadingProvider(
                                    _topicDialogLoadingScope,
                                  ).notifier,
                                )
                                .state =
                            true;
                        var topic = Topic(
                          name: (formGroup.value["name"] ?? "") as String,
                          // district:
                          //     (formGroup.value["district"] ?? District.aleppo)
                          //         as District,
                          // description:
                          //     (formGroup.value["description"] ?? "") as String,
                          // isPublished:
                          //     (formGroup.value["isPublished"] ?? false) as bool,
                          createdAt: '',
                          updatedAt: '',
                        );
                        if (isEditing) {
                          topic = topic.copyWith(
                            id: widget.topic!.id,
                            createdAt: widget.topic!.createdAt,
                            updatedAt: DateTime.now().toIso8601String(),
                          );
                        }
                        await widget.onSave(topic);
                        ref
                                .read(
                                  scopedLoadingProvider(
                                    _topicDialogLoadingScope,
                                  ).notifier,
                                )
                                .state =
                            false;
                        context.pop();
                      }
                    : null,
                child: isLoading
                    ? SizedBox(
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

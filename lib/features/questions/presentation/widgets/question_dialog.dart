import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/presentation/providers/loading_provider.dart';
import '../../domain/models/question.dart';
import '../providers/question_form_provider.dart';
import '../providers/asker_options_provider.dart';

const _questionDialogLoadingScope = 'question-dialog';

class QuestionDialog extends ConsumerStatefulWidget {
  const QuestionDialog({super.key, this.question, required this.onSave});

  final Question? question;
  final Future<void> Function(Question) onSave;

  @override
  ConsumerState<QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends ConsumerState<QuestionDialog> {
  bool _hasTriggeredValidation = false;
  bool _didSetupEditMode = false;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.question != null;
    final form = ref.watch(questionFormProvider(widget.question));
    final colorScheme = Theme.of(context).colorScheme;

    // عند التعديل نعطل الحقول الثابتة ونبقي حقل الإجابة فقط قابلًا للتحرير.
    if (isEditing && !_didSetupEditMode) {
      _didSetupEditMode = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        form.control('askerId').markAsDisabled();
        form.control('askerText').markAsDisabled();
      });
    }

    // نفعّل إظهار الأخطاء مرة واحدة بعد أول بناء.
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
        title: Text(isEditing ? "تعديل الإجابة" : "إنشاء سؤال"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final askersAsync = ref.watch(askerOptionsFutureProvider);

                  return askersAsync.when(
                    data: (askers) {
                      final available = askers
                          .where((a) => a.id.trim().isNotEmpty)
                          .toList();

                      if (!isEditing && available.isNotEmpty) {
                        final ctrl = form.control('askerId');
                        if (ctrl.value == null ||
                            (ctrl.value is String &&
                                (ctrl.value as String).isEmpty)) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!mounted) return;
                            ctrl.value = available.first.id;
                          });
                        }
                      }

                      return ReactiveDropdownField<String>(
                        formControlName: 'askerId',
                        items: available
                            .map(
                              (a) => DropdownMenuItem<String>(
                                value: a.id,
                                child: Text(a.name),
                              ),
                            )
                            .toList(),
                        decoration: InputDecoration(
                          labelText: "السائل",
                          errorStyle: TextStyle(color: colorScheme.error),
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) => "السائل مطلوب",
                        },
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "${"خطأ في تحميل السائلين"}: $e",
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),

              if (!isEditing) ...[
                ReactiveTextField<String>(
                  formControlName: 'askerText',
                  minLines: 3,
                  maxLines: 8,
                  decoration: InputDecoration(
                    labelText: "نص السؤال",
                    alignLabelWithHint: true,
                    errorStyle: TextStyle(color: colorScheme.error),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (_) => "نص السؤال مطلوب",
                  },
                ),
                const SizedBox(height: 10),
              ] else ...[
                TextField(
                  controller: TextEditingController(
                    text: widget.question!.askerText,
                  ),
                  readOnly: true,
                  minLines: 3,
                  maxLines: 8,
                  decoration: InputDecoration(
                    labelText: "نص السؤال",
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 10),
              ],

              ReactiveSwitchListTile(
                formControlName: 'isActive',
                title: Text('نشط'),
              ),
              const SizedBox(height: 10),

              // الجواب يظهر دائمًا، وعند التعديل يكون هو الحقل الوحيد القابل للتحرير.
              ReactiveTextField<String>(
                formControlName: 'answerText',
                minLines: 3,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: "الإجابة",
                  alignLabelWithHint: true,
                  errorStyle: TextStyle(color: colorScheme.error),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text('إلغاء')),
          ReactiveFormConsumer(
            builder: (context, formGroup, child) {
              final isLoading = ref.watch(
                scopedLoadingProvider(_questionDialogLoadingScope),
              );

              final canSave = isEditing
                  ? !isLoading // عند التعديل لا نعتمد form.valid لأن الحقول الثابتة معطلة.
                  : (formGroup.valid && !isLoading);

              return ElevatedButton(
                onPressed: !canSave
                    ? null
                    : () async {
                        ref
                                .read(
                                  scopedLoadingProvider(
                                    _questionDialogLoadingScope,
                                  ).notifier,
                                )
                                .state =
                            true;
                        try {
                          final now = DateTime.now().toIso8601String();

                          final answer =
                              (formGroup.control('answerText').value as String?)
                                  ?.trim() ??
                              '';

                          if (!isEditing) {
                            // إنشاء سؤال جديد مع كامل الحقول.
                            final askerId =
                                (formGroup.control('askerId').value as String)
                                    .trim();
                            final askerText =
                                (formGroup.control('askerText').value as String)
                                    .trim();
                            final isActive =
                                (formGroup.control('isActive').value
                                    as bool?) ??
                                false;

                            final q = Question(
                              id: null,
                              askerId: askerId,
                              askerText: askerText,
                              isActive: isActive,
                              answerText: answer.isEmpty ? null : answer,
                              createdAt: now,
                              updatedAt: now,
                            );

                            await widget.onSave(q);
                          } else {
                            // عند التعديل نحدث الإجابة فقط.
                            final updated = widget.question!.copyWith(
                              answerText: answer.isEmpty ? null : answer,
                              isActive:
                                  (formGroup.control('isActive').value
                                      as bool?) ??
                                  widget.question!.isActive,
                              updatedAt: now,
                            );

                            await widget.onSave(updated);
                          }

                          if (context.mounted) context.pop();
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        } finally {
                          ref
                                  .read(
                                    scopedLoadingProvider(
                                      _questionDialogLoadingScope,
                                    ).notifier,
                                  )
                                  .state =
                              false;
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

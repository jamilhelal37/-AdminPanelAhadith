import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/presentation/providers/loading_provider.dart';
import '../../domain/models/explaining.dart';
import '../providers/explaining_form_provider.dart';

const _explainingDialogLoadingScope = 'explaining-dialog';

class ExplainingDialog extends ConsumerStatefulWidget {
  const ExplainingDialog({super.key, this.explaining, required this.onSave});

  final Explaining? explaining;
  final Future<void> Function(Explaining) onSave;

  @override
  ConsumerState<ExplainingDialog> createState() => _ExplainingDialogState();
}

class _ExplainingDialogState extends ConsumerState<ExplainingDialog> {
  bool _hasTriggeredValidation = false;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.explaining != null;
    final form = ref.watch(explainingFormProvider(widget.explaining));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        title: Text(isEditing ? 'تعديل الشرح' : 'إنشاء شرح'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              ReactiveTextField<String>(
                formControlName: "text",
                minLines: 3, // يبدأ متعدد الأسطر
                maxLines: 8, // ✅ أقصى 8 أسطر
                decoration: InputDecoration(
                  labelText: 'النص',
                  alignLabelWithHint: true,
                  errorStyle: TextStyle(color: colorScheme.error),
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'النص مطلوب',
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text('إلغاء')),
          ReactiveFormConsumer(
            builder: (context, formGroup, child) {
              final isLoading = ref.watch(
                scopedLoadingProvider(_explainingDialogLoadingScope),
              );

              return ElevatedButton(
                onPressed: (!formGroup.valid || isLoading)
                    ? null
                    : () async {
                        ref
                                .read(
                                  scopedLoadingProvider(
                                    _explainingDialogLoadingScope,
                                  ).notifier,
                                )
                                .state =
                            true;
                        try {
                          final now = DateTime.now().toIso8601String();
                          final text =
                              (formGroup.control('text').value as String)
                                  .trim();

                          var explaining = Explaining(
                            id: widget.explaining?.id,
                            text: text,
                            createdAt: widget.explaining?.createdAt ?? now,
                            updatedAt: now,
                          );

                          await widget.onSave(explaining);

                          if (context.mounted) context.pop();
                        } finally {
                          ref
                                  .read(
                                    scopedLoadingProvider(
                                      _explainingDialogLoadingScope,
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


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/presentation/providers/loading_provider.dart';
import '../../domain/models/muhaddith.dart';
import '../providers/muhaddith_form_provider.dart';

const _muhaddithDialogLoadingScope = 'muhaddith-dialog';

class MuhaddithDialog extends ConsumerStatefulWidget {
  const MuhaddithDialog({super.key, this.muhaddith, required this.onSave});
  final Muhaddith? muhaddith;
  final Future<void> Function(Muhaddith) onSave;

  @override
  ConsumerState<MuhaddithDialog> createState() => _MuhaddithDialogState();
}

class _MuhaddithDialogState extends ConsumerState<MuhaddithDialog> {
  bool _hasTriggeredValidation = false;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.muhaddith != null;
    final form = ref.watch(muhaddithFormProvider(widget.muhaddith));
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
        title: Text(isEditing ? 'تعديل المحدث' : 'إنشاء محدث'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReactiveTextField<String>(
                formControlName: "name",
                decoration: InputDecoration(
                  labelText: 'الاسم',
                  errorStyle: TextStyle(color: colorScheme.error),
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'الاسم مطلوب',
                },
              ),
              const SizedBox(height: 10),

              ReactiveDropdownField<Gender>(
                formControlName: "gender",
                items: Gender.values
                    .map(
                      (g) => DropdownMenuItem(
                        value: g,
                        child: Text(g == Gender.male ? 'ذكر' : 'أنثى'),
                      ),
                    )
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'الجنس',
                  errorStyle: TextStyle(color: colorScheme.error),
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'الجنس مطلوب',
                },
              ),
              const SizedBox(height: 10),

              ReactiveTextField<String>(
                formControlName: "about",
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'نبذة عن',
                  alignLabelWithHint: true,
                  errorStyle: TextStyle(color: colorScheme.error),
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'النبذة مطلوبة',
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
                scopedLoadingProvider(_muhaddithDialogLoadingScope),
              );

              return ElevatedButton(
                onPressed: (!formGroup.valid || isLoading)
                    ? null
                    : () async {
                        ref
                                .read(
                                  scopedLoadingProvider(
                                    _muhaddithDialogLoadingScope,
                                  ).notifier,
                                )
                                .state =
                            true;

                        try {
                          final now = DateTime.now().toIso8601String();

                          var muhaddith = Muhaddith(
                            id: widget.muhaddith?.id,
                            name: (formGroup.control('name').value as String)
                                .trim(),
                            gender: formGroup.control('gender').value as Gender,
                            about: (formGroup.control('about').value as String)
                                .trim(),
                            createdAt: widget.muhaddith?.createdAt ?? now,
                            updatedAt: isEditing
                                ? now
                                : (widget.muhaddith?.updatedAt ?? now),
                          );

                          await widget.onSave(muhaddith);

                          if (context.mounted) context.pop();
                        } finally {
                          ref
                                  .read(
                                    scopedLoadingProvider(
                                      _muhaddithDialogLoadingScope,
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

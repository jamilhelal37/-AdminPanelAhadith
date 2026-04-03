import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/presentation/providers/loading_provider.dart';
import '../../domain/models/rawi.dart';
import '../providers/rawi_form_provider.dart';

const _rawiDialogLoadingScope = 'rawi-dialog';

class RawiDialog extends ConsumerStatefulWidget {
  const RawiDialog({super.key, this.rawi, required this.onSave});
  final Rawi? rawi;
  final Future<void> Function(Rawi) onSave;

  @override
  ConsumerState<RawiDialog> createState() => _RawiDialogState();
}

class _RawiDialogState extends ConsumerState<RawiDialog> {
  bool _hasTriggeredValidation = false;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.rawi != null;
    final form = ref.watch(rawiFormProvider(widget.rawi));
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
        title: Text(isEditing ? 'تعديل الراوي' : 'إنشاء راوي'),
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
                scopedLoadingProvider(_rawiDialogLoadingScope),
              );

              return ElevatedButton(
                onPressed: (!formGroup.valid || isLoading)
                    ? null
                    : () async {
                        ref
                                .read(
                                  scopedLoadingProvider(
                                    _rawiDialogLoadingScope,
                                  ).notifier,
                                )
                                .state =
                            true;

                        try {
                          final now = DateTime.now().toIso8601String();

                          var rawi = Rawi(
                            id: widget.rawi?.id,
                            name: (formGroup.control('name').value as String)
                                .trim(),
                            gender: formGroup.control('gender').value as Gender,
                            about: (formGroup.control('about').value as String)
                                .trim(),
                            createdAt: widget.rawi?.createdAt ?? now,
                            updatedAt: isEditing
                                ? now
                                : (widget.rawi?.updatedAt ?? now),
                          );

                          await widget.onSave(rawi);

                          if (context.mounted) context.pop();
                        } finally {
                          ref
                                  .read(
                                    scopedLoadingProvider(
                                      _rawiDialogLoadingScope,
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

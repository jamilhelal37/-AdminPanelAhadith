import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/presentation/providers/loading_provider.dart';
import '../../domain/models/ruling.dart';
import '../providers/ruling_form_provider.dart';

const _rulingDialogLoadingScope = 'ruling-dialog';

class RulingDialog extends ConsumerStatefulWidget {
  const RulingDialog({super.key, this.ruling, required this.onSave});
  final Ruling? ruling;
  final Function(Ruling?) onSave;

  @override
  ConsumerState<RulingDialog> createState() => _RulingDialogState();
}

class _RulingDialogState extends ConsumerState<RulingDialog> {
  bool _hasTriggeredValidation = false;

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.ruling != null;
    final form = ref.watch(rulingFormProvider(widget.ruling));
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
        title: Text('الحكم'),
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
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              
            ],
          ),
        ),

        actions: [
          TextButton(onPressed: () => context.pop(), child: Text('إلغاء')),
          ReactiveFormConsumer(
            builder: (context, formGroup, child) {
              final isLoading = ref.watch(
                scopedLoadingProvider(_rulingDialogLoadingScope),
              );
              return ElevatedButton(
                onPressed: (!formGroup.valid || isLoading)
                    ? null
                    : () async {
                        ref
                                .read(
                                  scopedLoadingProvider(
                                    _rulingDialogLoadingScope,
                                  ).notifier,
                                )
                                .state =
                            true;
                        try {
                          var ruling = Ruling(
                            name: (formGroup.value["name"] ?? "") as String,
                            
                            
                            
                            
                            
                            
                            
                            createdAt: '',
                            updatedAt: '',
                          );
                          if (isEditing) {
                            ruling = ruling.copyWith(
                              id: widget.ruling!.id,
                              createdAt: widget.ruling!.createdAt,
                              updatedAt: DateTime.now().toIso8601String(),
                            );
                          }
                          await widget.onSave(ruling);
                          if (context.mounted) {
                            context.pop();
                          }
                        } finally {
                          ref
                                  .read(
                                    scopedLoadingProvider(
                                      _rulingDialogLoadingScope,
                                    ).notifier,
                                  )
                                  .state =
                              false;
                        }
                      },
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

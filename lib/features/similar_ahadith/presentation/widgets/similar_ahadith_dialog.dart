import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/presentation/providers/loading_provider.dart';
import '../../domain/models/similar_ahadith.dart';
import '../providers/similar_ahadith_form_provider.dart';

const _similarAhadithDialogLoadingScope = 'similar-ahadith-dialog';

class SimilarAhadithDialog extends ConsumerStatefulWidget {
  const SimilarAhadithDialog({
    super.key,
    this.similarAhadith,
    required this.onSave,
  });
  final SimilarAhadith? similarAhadith;
  final Future<void> Function(SimilarAhadith) onSave;

  @override
  ConsumerState<SimilarAhadithDialog> createState() =>
      _SimilarAhadithDialogState();
}

class _SimilarAhadithDialogState extends ConsumerState<SimilarAhadithDialog> {
  bool _hasTriggeredValidation = false;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.similarAhadith != null;
    final form = ref.watch(similarAhadithFormProvider(widget.similarAhadith));
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
        title: Text(
          isEditing ? 'تعديل أحاديث متشابهة' : 'إنشاء أحاديث متشابهة',
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReactiveTextField<String>(
                  formControlName: "mainHadithId",
                  decoration: InputDecoration(
                    labelText: 'معرّف الحديث الرئيسي',
                    errorStyle: TextStyle(color: colorScheme.error),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (_) =>
                        'معرّف الحديث الرئيسي مطلوب',
                  },
                ),
                const SizedBox(height: 10),
                ReactiveTextField<String>(
                  formControlName: "simHadithId",
                  decoration: InputDecoration(
                    labelText: 'معرّف الحديث المشابه',
                    errorStyle: TextStyle(color: colorScheme.error),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (_) =>
                        'معرّف الحديث المشابه مطلوب',
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
                scopedLoadingProvider(_similarAhadithDialogLoadingScope),
              );

              return ElevatedButton(
                onPressed: (!formGroup.valid || isLoading)
                    ? null
                    : () async {
                        ref
                                .read(
                                  scopedLoadingProvider(
                                    _similarAhadithDialogLoadingScope,
                                  ).notifier,
                                )
                                .state =
                            true;
                        try {
                          final now = DateTime.now().toIso8601String();

                          final mainHadithId =
                              (formGroup.control('mainHadithId').value
                                      as String?)
                                  ?.trim() ??
                              '';
                          final simHadithId =
                              (formGroup.control('simHadithId').value
                                      as String?)
                                  ?.trim() ??
                              '';

                          final similarAhadith = SimilarAhadith(
                            id: widget.similarAhadith?.id,
                            mainHadithId: mainHadithId,
                            simHadithId: simHadithId,
                            createdAt: widget.similarAhadith?.createdAt ?? now,
                            updatedAt: now,
                          );

                          debugPrint(
                            "SIMILAR AHADITH SAVE START id=${similarAhadith.id}",
                          );
                          await widget.onSave(similarAhadith);
                          debugPrint("SIMILAR AHADITH SAVE DONE");

                          if (!mounted) return;
                          context.pop();
                        } catch (e, st) {
                          debugPrint("SIMILAR AHADITH SAVE ERROR: $e");
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
                                        _similarAhadithDialogLoadingScope,
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

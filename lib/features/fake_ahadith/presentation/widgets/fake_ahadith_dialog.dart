import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../ruling/domain/models/ruling.dart';
import '../../../ruling/presentation/providers/ruling_future_provider.dart';
import '../../domain/models/fake_ahadith.dart';
import '../providers/fakeahadith_form_provider.dart';

class FakeAhadithDialog extends ConsumerStatefulWidget {
  const FakeAhadithDialog({super.key, this.fakeAhadith, required this.onSave});

  final FakeAhadith? fakeAhadith;
  final Future<void> Function(FakeAhadith) onSave;

  @override
  ConsumerState<FakeAhadithDialog> createState() => _FakeAhadithDialogState();
}

class _FakeAhadithDialogState extends ConsumerState<FakeAhadithDialog> {
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.fakeAhadith != null;
    final form = ref.watch(fakeAhadithFormProvider(widget.fakeAhadith));
    final colorScheme = Theme.of(context).colorScheme;
    final rulingsAsync = ref.watch(adminRulingsFutureProvider);
    final screenSize = MediaQuery.sizeOf(context);
    final maxDialogWidth = screenSize.width >= 1600
        ? 920.0
        : screenSize.width >= 1200
        ? 820.0
        : 680.0;

    return ReactiveForm(
      formGroup: form,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxDialogWidth,
            maxHeight: screenSize.height * 0.82,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isEditing ? 'تعديل حديث مكذوب' : 'إنشاء حديث مكذوب',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReactiveTextField<String>(
                          formControlName: 'text',
                          decoration: InputDecoration(
                            labelText: 'النص',
                            alignLabelWithHint: true,
                            errorStyle: TextStyle(color: colorScheme.error),
                          ),
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          minLines: 6,
                          maxLines: 12,
                          validationMessages: {
                            ValidationMessage.required: (_) => 'النص مطلوب',
                          },
                        ),
                        const SizedBox(height: 14),
                        rulingsAsync.when(
                          loading: () => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (e, _) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'خطأ في تحميل الأحكام: $e',
                              style: TextStyle(color: colorScheme.error),
                            ),
                          ),
                          data: (List<Ruling> rulings) {
                            final available = rulings
                                .where((r) => r.id != null)
                                .toList();
                            if (available.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text(
                                  'لا توجد أحكام متاحة',
                                  style: TextStyle(color: colorScheme.error),
                                ),
                              );
                            }

                            final rulingCtrl = form.control('ruling');

                            if (rulingCtrl.value == null ||
                                (rulingCtrl.value is String &&
                                    (rulingCtrl.value as String).isEmpty)) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!mounted) return;
                                rulingCtrl.value = available.first.id!;
                              });
                            }

                            return ReactiveDropdownField<String>(
                              formControlName: 'ruling',
                              items: available
                                  .map(
                                    (r) => DropdownMenuItem<String>(
                                      value: r.id!,
                                      child: Text(r.name),
                                    ),
                                  )
                                  .toList(),
                              decoration: InputDecoration(
                                labelText: 'الحكم',
                                errorStyle: TextStyle(color: colorScheme.error),
                              ),
                              validationMessages: {
                                ValidationMessage.required: (_) =>
                                    'الحكم مطلوب',
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ReactiveFormConsumer(
                      builder: (context, formGroup, child) {
                        return ElevatedButton(
                          onPressed: _isSaving
                              ? null
                              : () async {
                                  if (formGroup.invalid) {
                                    formGroup.markAllAsTouched();
                                    return;
                                  }

                                  setState(() => _isSaving = true);
                                  try {
                                    final now = DateTime.now()
                                        .toIso8601String();

                                    final text =
                                        (formGroup.control('text').value
                                                as String?)
                                            ?.trim() ??
                                        '';
                                    final ruling =
                                        (formGroup.control('ruling').value
                                                as String?)
                                            ?.trim() ??
                                        '';

                                    final fakeAhadith = FakeAhadith(
                                      id: widget.fakeAhadith?.id,
                                      text: text,
                                      ruling: ruling,
                                      subValid: widget.fakeAhadith?.subValid,
                                      createdAt:
                                          widget.fakeAhadith?.createdAt ?? now,
                                      updatedAt: now,
                                    );

                                    debugPrint(
                                      'FAKE AHADITH SAVE START id=${fakeAhadith.id} text=${fakeAhadith.text}',
                                    );
                                    await widget.onSave(fakeAhadith);
                                    debugPrint('FAKE AHADITH SAVE DONE');

                                    if (!mounted) return;
                                    context.pop();
                                  } catch (e, st) {
                                    debugPrint('FAKE AHADITH SAVE ERROR: $e');
                                    debugPrint('$st');
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  } finally {
                                    if (mounted) {
                                      setState(() => _isSaving = false);
                                    }
                                  }
                                },
                          child: _isSaving
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('حفظ'),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('إلغاء'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

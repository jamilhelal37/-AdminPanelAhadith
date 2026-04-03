import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/presentation/providers/loading_provider.dart';

import '../../../rawis/domain/models/rawi.dart';
import '../../../rawis/presentation/providers/admin_rawi_future_provider.dart';

import '../../../books/domain/models/book.dart';
import '../../../books/presentation/providers/admin_book_future_provider.dart';

import '../../../ruling/domain/models/ruling.dart';

import '../../../ruling/presentation/providers/ruling_future_provider.dart';
import '../../domain/models/hadith.dart';
import '../providers/hadith_form_provider.dart';

const _hadithDialogLoadingScope = 'hadith-dialog';

class HadithDialog extends ConsumerStatefulWidget {
  const HadithDialog({super.key, this.hadith, required this.onSave});

  final Hadith? hadith;
  final Future<void> Function(Hadith) onSave;

  @override
  ConsumerState<HadithDialog> createState() => _HadithDialogState();
}

class _HadithDialogState extends ConsumerState<HadithDialog> {
  bool _hasTriggeredValidation = false;

  String? _nullableUuid(dynamic value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _typeLabel(HadithType t) {
    switch (t) {
      case HadithType.marfu:
        return "مرفوع";
      case HadithType.mawquf:
        return "موقوف";
      case HadithType.qudsi:
        return "قدسي";
      case HadithType.atharSahaba:
        return "آثار الصحابة";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.hadith != null;
    final form = ref.watch(hadithFormProvider(widget.hadith));
    final colorScheme = Theme.of(context).colorScheme;

    if (!_hasTriggeredValidation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        form.markAllAsTouched();
        setState(() => _hasTriggeredValidation = true);
      });
    }

    final rawisAsync = ref.watch(adminRawisFutureProvider);
    final booksAsync = ref.watch(adminBooksFutureProvider);
    final rulingsAsync = ref.watch(adminRulingsFutureProvider);

    return ReactiveForm(
      formGroup: form,
      child: AlertDialog(
        title: Text(isEditing ? "تعديل حديث" : "إنشاء حديث"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Hadith Number (required)
              ReactiveTextField<int>(
                formControlName: 'hadithNumber',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'رقم الحديث',
                  errorStyle: TextStyle(color: colorScheme.error),
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'مطلوب',
                },
                valueAccessor: IntValueAccessor(),
              ),
              const SizedBox(height: 10),

              // ✅ Type (required)
              ReactiveDropdownField<HadithType>(
                formControlName: 'type',
                items: HadithType.values
                    .map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Text(_typeLabel(t)),
                      ),
                    )
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'النوع',
                  errorStyle: TextStyle(color: colorScheme.error),
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'مطلوب',
                },
              ),
              const SizedBox(height: 10),

              // ✅ Text (required) max 8 lines
              ReactiveTextField<String>(
                formControlName: 'text',
                minLines: 3,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: 'النص',
                  alignLabelWithHint: true,
                  errorStyle: TextStyle(color: colorScheme.error),
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'مطلوب',
                },
              ),
              const SizedBox(height: 10),

              ReactiveTextField<String>(
                formControlName: 'sanad',
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'السند',
                  alignLabelWithHint: true,
                  errorStyle: TextStyle(color: colorScheme.error),
                ),
              ),
              const SizedBox(height: 10),

              // ✅ Rawi (required)
              rawisAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "${'خطأ في تحميل الرواة'}: $e",
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
                data: (List<Rawi> rawis) {
                  final available = rawis.where((r) => r.id != null).toList();
                  if (available.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "لا يوجد رواة",
                        style: TextStyle(color: colorScheme.error),
                      ),
                    );
                  }

                  final ctrl = form.control('rawiId');

                  if (ctrl.value == null ||
                      (ctrl.value is String &&
                          (ctrl.value as String).isEmpty)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      ctrl.value = available.first.id!;
                    });
                  }

                  return ReactiveDropdownField<String>(
                    formControlName: 'rawiId',
                    items: available
                        .map(
                          (r) => DropdownMenuItem<String>(
                            value: r.id!,
                            child: Text(r.name),
                          ),
                        )
                        .toList(),
                    decoration: InputDecoration(
                      labelText: 'الراوي',
                      errorStyle: TextStyle(color: colorScheme.error),
                    ),
                    validationMessages: {
                      ValidationMessage.required: (_) => 'مطلوب',
                    },
                  );
                },
              ),
              const SizedBox(height: 10),

              // ✅ Source / Book (required)
              booksAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "${'خطأ في تحميل الكتب'}: $e",
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
                data: (List<Book> books) {
                  final available = books.where((b) => b.id != null).toList();
                  if (available.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "لا توجد كتب",
                        style: TextStyle(color: colorScheme.error),
                      ),
                    );
                  }

                  final ctrl = form.control('sourceId');

                  if (ctrl.value == null ||
                      (ctrl.value is String &&
                          (ctrl.value as String).isEmpty)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      ctrl.value = available.first.id!;
                    });
                  }

                  return ReactiveDropdownField<String>(
                    formControlName: 'sourceId',
                    items: available
                        .map(
                          (b) => DropdownMenuItem<String>(
                            value: b.id!,
                            child: Text(b.name),
                          ),
                        )
                        .toList(),
                    decoration: InputDecoration(
                      labelText: 'الكتاب',
                      errorStyle: TextStyle(color: colorScheme.error),
                    ),
                    validationMessages: {
                      ValidationMessage.required: (_) => 'مطلوب',
                    },
                  );
                },
              ),
              const SizedBox(height: 10),

              // ✅ Muhaddith Ruling (required) + Final Ruling (optional)
              rulingsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "${'خطأ في تحميل الأحكام'}: $e",
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
                data: (List<Ruling> rulings) {
                  final available = rulings.where((r) => r.id != null).toList();
                  if (available.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "لا توجد أحكام متاحة",
                        style: TextStyle(color: colorScheme.error),
                      ),
                    );
                  }

                  final muhCtrl = form.control('muhaddithRulingId');

                  if (muhCtrl.value == null ||
                      (muhCtrl.value is String &&
                          (muhCtrl.value as String).isEmpty)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      muhCtrl.value = available.first.id!;
                    });
                  }

                  return Column(
                    children: [
                      ReactiveDropdownField<String>(
                        formControlName: 'muhaddithRulingId',
                        items: available
                            .map(
                              (r) => DropdownMenuItem<String>(
                                value: r.id!,
                                child: Text(r.name),
                              ),
                            )
                            .toList(),
                        decoration: InputDecoration(
                          labelText: 'حكم المحدث',
                          errorStyle: TextStyle(color: colorScheme.error),
                        ),
                        validationMessages: {
                          ValidationMessage.required: (_) => 'مطلوب',
                        },
                      ),
                      const SizedBox(height: 10),
                      ReactiveDropdownField<String?>(
                        formControlName: 'finalRulingId',
                        items: available
                            .map(
                              (r) => DropdownMenuItem<String?>(
                                value: r.id!,
                                child: Text(r.name),
                              ),
                            )
                            .toList(),
                        decoration: InputDecoration(
                          labelText: "الحكم النهائي",
                          errorStyle: TextStyle(color: colorScheme.error),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text('إلغاء')),
          ReactiveFormConsumer(
            builder: (context, formGroup, child) {
              final isLoading = ref.watch(
                scopedLoadingProvider(_hadithDialogLoadingScope),
              );

              return ElevatedButton(
                onPressed: (!formGroup.valid || isLoading)
                    ? null
                    : () async {
                        ref
                                .read(
                                  scopedLoadingProvider(
                                    _hadithDialogLoadingScope,
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
                          final rawiId =
                              formGroup.control('rawiId').value as String?;
                          final sourceId =
                              formGroup.control('sourceId').value as String?;
                          final muhRulingId =
                              formGroup.control('muhaddithRulingId').value
                                  as String?;

                          if (rawiId == null || rawiId.isEmpty) {
                            throw AppFailure.validation('الراوي مطلوب.');
                          }
                          if (sourceId == null || sourceId.isEmpty) {
                            throw AppFailure.validation('الكتاب مطلوب.');
                          }
                          if (muhRulingId == null || muhRulingId.isEmpty) {
                            throw AppFailure.validation('حكم المحدث مطلوب.');
                          }

                          final hadith = Hadith(
                            id: widget.hadith?.id,
                            subValid: _nullableUuid(
                              formGroup.control('subValid').value,
                            ),
                            explainingId: isEditing
                                ? _nullableUuid(
                                    formGroup.control('explainingId').value,
                                  )
                                : null,
                            type: formGroup.control('type').value as HadithType,
                            text: text,
                            normalText: widget.hadith?.normalText,
                            searchText: widget.hadith?.searchText,
                            hadithNumber:
                                formGroup.control('hadithNumber').value as int,
                            muhaddithRulingId: muhRulingId,
                            finalRulingId: _nullableUuid(
                              formGroup.control('finalRulingId').value,
                            ),
                            rawiId: rawiId,
                            sourceId: sourceId,
                            sanad: formGroup.control('sanad').value as String?,
                            createdAt: widget.hadith?.createdAt ?? now,
                            updatedAt: now,
                          );

                          debugPrint(
                            "HADITH SAVE START id=${hadith.id} num=${hadith.hadithNumber} rawiId=${hadith.rawiId} sourceId=${hadith.sourceId}",
                          );
                          await widget.onSave(hadith);
                          debugPrint("HADITH SAVE DONE");

                          if (!mounted) return;
                        } catch (e, st) {
                          debugPrint("HADITH SAVE ERROR: $e");
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
                                        _hadithDialogLoadingScope,
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

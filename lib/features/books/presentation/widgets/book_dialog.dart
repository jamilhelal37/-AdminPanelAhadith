import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/presentation/providers/loading_provider.dart';
import '../../../muhaddiths/domain/models/muhaddith.dart';
import '../../../muhaddiths/presentation/providers/muhaddith_future_provider.dart';
import '../../domain/models/book.dart';
import '../providers/book_form_provider.dart';

const _bookDialogLoadingScope = 'book-dialog';

class BookDialog extends ConsumerStatefulWidget {
  const BookDialog({super.key, this.book, required this.onSave});
  final Book? book;
  final Future<void> Function(Book) onSave;

  @override
  ConsumerState<BookDialog> createState() => _BookDialogState();
}

class _BookDialogState extends ConsumerState<BookDialog> {
  bool _hasTriggeredValidation = false;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;
    final form = ref.watch(bookFormProvider(widget.book));
    final colorScheme = Theme.of(context).colorScheme;

    if (!_hasTriggeredValidation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        form.markAllAsTouched();
        setState(() => _hasTriggeredValidation = true);
      });
    }

    final muhaddithsAsync = ref.watch(adminMuhaddithFutureProvider);

    return ReactiveForm(
      formGroup: form,
      child: AlertDialog(
        title: Text(isEditing ? 'تعديل كتاب' : 'إنشاء كتاب'),
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

              muhaddithsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "${'خطأ في تحميل المحدثين'}: $e",
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
                data: (List<Muhaddith> muhaddiths) {
                  final available = muhaddiths
                      .where((m) => m.id != null)
                      .toList();

                  if (available.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'لا يوجد محدثون',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    );
                  }

                  final ctrl = form.control('muhaddithId');

                  
                  if (ctrl.value == null ||
                      (ctrl.value is String &&
                          (ctrl.value as String).isEmpty)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      ctrl.value = available.first.id!;
                    });
                  }

                  return ReactiveDropdownField<String>(
                    formControlName: "muhaddithId",
                    items: available
                        .map(
                          (m) => DropdownMenuItem<String>(
                            value: m.id!, 
                            child: Text(m.name),
                          ),
                        )
                        .toList(),
                    decoration: InputDecoration(
                      labelText: 'المحدث',
                      errorStyle: TextStyle(color: colorScheme.error),
                    ),
                    validationMessages: {
                      ValidationMessage.required: (_) => 'المحدث مطلوب',
                    },
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(), 
            child: Text('إلغاء'),
          ),
          ReactiveFormConsumer(
            builder: (context, formGroup, child) {
              final isLoading = ref.watch(
                scopedLoadingProvider(_bookDialogLoadingScope),
              );

              return ElevatedButton(
                onPressed: (!formGroup.valid || isLoading)
                    ? null
                    : () async {
                        ref
                                .read(
                                  scopedLoadingProvider(
                                    _bookDialogLoadingScope,
                                  ).notifier,
                                )
                                .state =
                            true;
                        try {
                          final now = DateTime.now().toIso8601String();

                          final name =
                              (formGroup.control('name').value as String?)
                                  ?.trim() ??
                              '';
                          final muhId =
                              formGroup.control('muhaddithId').value as String?;

                          if (muhId == null || muhId.isEmpty) {
                            throw AppFailure.validation(
                              'لم يتم اختيار المحدث.',
                            );
                          }

                          final book = Book(
                            id: widget.book?.id,
                            name: name,
                            muhaddithId: muhId,
                            createdAt: widget.book?.createdAt ?? now,
                            updatedAt: now,
                          );

                          debugPrint(
                            'بدء حفظ الكتاب id=${book.id} name=${book.name} muhaddithId=${book.muhaddithId}',
                          );
                          await widget.onSave(book);
                          debugPrint('تم حفظ الكتاب');

                          if (!mounted) return;
                          context.pop(); 
                        } catch (e, st) {
                          debugPrint('خطأ في حفظ الكتاب: $e');
                          debugPrint('$st');
                          if (!mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        } finally {
                          if (mounted) {
                            ref
                                    .read(
                                      scopedLoadingProvider(
                                        _bookDialogLoadingScope,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_failure.dart';

import '../../../../core/presentation/widgets/admin_pagination.dart';
import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../../../../core/presentation/widgets/empty_state_widget.dart';
import '../../../../core/presentation/widgets/search_field_widget.dart';

import '../../data/repositories/hadith_repository_provider.dart';
import '../../domain/models/hadith.dart';
import '../providers/admin_hadith_future_provider.dart';
import '../providers/search_provider.dart';

import '../widgets/admin_hadith_table.dart';
import '../widgets/hadith_dialog.dart';
import '../widgets/hadith_picker_dialog.dart';
import '../../../explaining/presentation/widgets/explaining_picker_dialog.dart';








class AdminHadithScreen extends ConsumerStatefulWidget {
  const AdminHadithScreen({super.key});

  @override
  ConsumerState<AdminHadithScreen> createState() => _AdminHadithScreenState();
}

class _AdminHadithScreenState extends ConsumerState<AdminHadithScreen> {
  late final TextEditingController ctr;

  @override
  void initState() {
    super.initState();
    ctr = TextEditingController();
  }

  @override
  void dispose() {
    ctr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final currentSearch = ref.watch(searchProvider);
    if (ctr.text != currentSearch) {
      ctr.value = ctr.value.copyWith(
        text: currentSearch,
        selection: TextSelection.collapsed(offset: currentSearch.length),
      );
    }

    final ahadithAsync = ref.watch(adminHadithsFutureProvider);

    return Column(
      children: [
        
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Row(
            children: [
              Expanded(
                child: SearchFieldWidget(
                  controller: ctr,
                  compact: true,
                  hintText: 'ابحث',
                  onChanged: (value) {
                    ref.read(searchProvider.notifier).state = value;
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogCtx) => HadithDialog(
                      onSave: (hadith) async {
                        try {
                          final repo = ref.read(hadithRepositoryProvider);
                          await repo.createHadith(hadith);

                          
                          if (dialogCtx.mounted) {
                            dialogCtx.pop();
                          }

                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم إنشاء الحديث بنجاح'),
                            ),
                          );

                          ref.invalidate(adminHadithsFutureProvider);
                        } catch (e, st) {
                          debugPrint("CREATE HADITH ERROR: $e");
                          debugPrint("$st");

                          if (!context.mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                    ),
                  );
                },
                label: const Text('إنشاء حديث'),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),

        
        Expanded(
          child: ahadithAsync.when(
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            data: (data) {
              if (data.isEmpty) {
                return EmptyStateWidget(
                  message: currentSearch.trim().isEmpty
                      ? 'لا توجد أحاديث لعرضها'
                      : 'لا توجد نتائج مطابقة للبحث',
                );
              }

              return AdminPaginatedDataView<Hadith>(
                items: data,
                stateKey: currentSearch.replaceAll(RegExp(r'\s+'), ' ').trim(),
                itemBuilder: (context, pageItems) => AdminAhadithTable(
                  ahadith: pageItems,
                  onDelete: (h) => _showDeleteConfirmationDialog(context, h),
                  onLinkExplaining: (h) =>
                      _showExplainingPickerDialog(context, h),
                  onLinkSubValid: (h) => _showSubValidPickerDialog(context, h),
                  onEdit: (h) {
                    showDialog(
                      context: context,
                      builder: (dialogCtx) => HadithDialog(
                        hadith: h,
                        onSave: (updated) async {
                          try {
                            final repo = ref.read(hadithRepositoryProvider);
                            await repo.updateHadith(updated);

                            if (dialogCtx.mounted) {
                              dialogCtx.pop();
                            }

                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم تحديث الحديث بنجاح'),
                              ),
                            );

                            ref.invalidate(adminHadithsFutureProvider);
                          } catch (e, st) {
                            debugPrint("UPDATE HADITH ERROR: $e");
                            debugPrint("$st");

                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            },
            error: (e, _) => EmptyStateWidget(message: 'خطأ في تحميل الأحاديث'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  void _showExplainingPickerDialog(BuildContext context, Hadith hadith) async {
    final result = await showDialog<String?>(
      context: context,
      builder: (dialogCtx) =>
          ExplainingPickerDialog(currentExplainingId: hadith.explainingId),
    );

    
    if (result == null) return;

    
    try {
      
      final newExplainingId = result.isEmpty ? null : result;
      final updatedHadith = hadith.copyWith(explainingId: newExplainingId);
      final repo = ref.read(hadithRepositoryProvider);
      await repo.updateHadith(updatedHadith);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.isNotEmpty ? 'تم ربط الشرح بنجاح' : 'تم إزالة الشرح بنجاح',
          ),
        ),
      );

      ref.invalidate(adminHadithsFutureProvider);
    } catch (e, st) {
      debugPrint("LINK EXPLAINING ERROR: $e");
      debugPrint("$st");

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _showSubValidPickerDialog(BuildContext context, Hadith hadith) async {
    final result = await showDialog<String?>(
      context: context,
      builder: (dialogCtx) =>
          HadithPickerDialog(currentHadithId: hadith.subValid),
    );

    
    if (result == null) return;

    
    try {
      
      final newSubValidId = result.isEmpty ? null : result;
      final updatedHadith = hadith.copyWith(subValid: newSubValidId);
      final repo = ref.read(hadithRepositoryProvider);
      await repo.updateHadith(updatedHadith);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.isNotEmpty
                ? 'تم ربط الحديث الصحيح بنجاح'
                : 'تم إزالة الحديث الصحيح بنجاح',
          ),
        ),
      );

      ref.invalidate(adminHadithsFutureProvider);
    } catch (e, st) {
      debugPrint("LINK SUB VALID ERROR: $e");
      debugPrint("$st");

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, Hadith hadith) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'حذف الحديث',
        content: 'هل أنت متأكد أنك تريد حذف هذا الحديث؟',
        onConfirm: () async {
          try {
            if (hadith.id == null) {
              throw AppFailure.validation('معرّف الحديث غير موجود.');
            }

            final repo = ref.read(hadithRepositoryProvider);
            await repo.deleteHadith(hadith.id!);

            ref.invalidate(adminHadithsFutureProvider);

            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم حذف الحديث بنجاح')),
            );
          } catch (e, st) {
            debugPrint("DELETE HADITH ERROR: $e");
            debugPrint("$st");

            if (!context.mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';

import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../../../../core/presentation/widgets/admin_pagination.dart';
import '../../../../core/presentation/widgets/empty_state_widget.dart';
import '../../../../core/presentation/widgets/search_field_widget.dart';

import '../../data/repositories/fakeahadith_repositories_provider.dart';
import '../../domain/models/fake_ahadith.dart';
import '../providers/admin_fakeahadith_future_provider.dart';
import '../providers/search_provider.dart';
import '../widgets/admin_fake_ahadiths_table.dart';
import '../widgets/fake_ahadith_dialog.dart';
import '../../../../../../features/ahadith/presentation/widgets/hadith_picker_dialog.dart';

class AdminFakeAhadithScreen extends ConsumerStatefulWidget {
  const AdminFakeAhadithScreen({super.key});

  @override
  ConsumerState<AdminFakeAhadithScreen> createState() =>
      _AdminFakeAhadithScreenState();
}

class _AdminFakeAhadithScreenState
    extends ConsumerState<AdminFakeAhadithScreen> {
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

    final fakeAhadithsAsync = ref.watch(adminFakeAhadithsFutureProvider);

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
                    builder: (_) => FakeAhadithDialog(
                      onSave: (fakeAhadith) async {
                        try {
                          final repo = ref.read(fakeAhadithRepositoryProvider);
                          await repo.createFakeAhadith(fakeAhadith);

                          ref.invalidate(adminFakeAhadithsFutureProvider);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('تم إنشاء الحديث المكذوب بنجاح'),
                              ),
                            );
                          }
                        } catch (e, st) {
                          debugPrint("CREATE FAKE AHADITH ERROR: $e");
                          debugPrint("$st");
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                          rethrow;
                        }
                      },
                    ),
                  );
                },
                label: Text('إنشاء حديث مكذوب'),
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: fakeAhadithsAsync.when(
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            data: (data) {
              if (data.isEmpty) return EmptyStateWidget();

              return AdminPaginatedDataView<FakeAhadith>(
                items: data,
                stateKey: currentSearch.replaceAll(RegExp(r'\s+'), ' ').trim(),
                itemBuilder: (context, pageItems) => AdminFakeAhadithsTable(
                  fakeAhadiths: pageItems,
                  onDelete: _showDeleteConfirmationDialog,
                  onEdit: (fa) {
                    showDialog(
                      context: context,
                      builder: (_) => FakeAhadithDialog(
                        fakeAhadith: fa,
                        onSave: (fakeAhadith) async {
                          try {
                            final repo = ref.read(
                              fakeAhadithRepositoryProvider,
                            );
                            await repo.updateFakeAhadith(fakeAhadith);

                            ref.invalidate(adminFakeAhadithsFutureProvider);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'تم تحديث الحديث المكذوب بنجاح',
                                  ),
                                ),
                              );
                            }
                          } catch (e, st) {
                            debugPrint("UPDATE FAKE AHADITH ERROR: $e");
                            debugPrint("$st");
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                            rethrow;
                          }
                        },
                      ),
                    );
                  },
                  onLinkSubValid: (fa) =>
                      _showSubValidPickerDialog(context, fa),
                ),
              );
            },
            error: (error, stackTrace) =>
                EmptyStateWidget(message: 'خطأ في تحميل الأحاديث المكذوبة'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(FakeAhadith fakeAhadith) {
    showDialog(
      context: context,
      builder: (dialogCtx) => ConfirmationDialog(
        title: 'حذف حديث منتشر لا يصح',
        content: 'هل أنت متأكد من حذف هذا الحديث المنتشر لا يصح؟',
        onConfirm: () async {
          try {
            if (fakeAhadith.id == null) {
              throw AppFailure.validation(
                'معرّف الحديث المنتشر لا يصح غير موجود.',
              );
            }

            final repo = ref.read(fakeAhadithRepositoryProvider);
            await repo.deleteFakeAhadith(fakeAhadith.id!);

            ref.invalidate(adminFakeAhadithsFutureProvider);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم حذف الحديث المنتشر لا يصح بنجاح')),
              );
            }
          } catch (e, st) {
            debugPrint("DELETE FAKE AHADITH ERROR: $e");
            debugPrint("$st");
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(e.toString())));
            }
          }
        },
      ),
    );
  }

  void _showSubValidPickerDialog(
    BuildContext context,
    FakeAhadith fakeAhadith,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) =>
          HadithPickerDialog(currentHadithId: fakeAhadith.subValid),
    ).then((selectedId) async {
      if (selectedId == null) {
        return;
      }

      try {
        if (fakeAhadith.id == null) {
          throw AppFailure.validation('معرّف الحديث المنتشر لا يصح غير موجود.');
        }

        final repo = ref.read(fakeAhadithRepositoryProvider);
        await repo.updateFakeAhadith(
          fakeAhadith.copyWith(
            subValid: selectedId.isEmpty ? null : selectedId,
          ),
        );

        ref.invalidate(adminFakeAhadithsFutureProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم تحديث الحديث الصحيح بنجاح')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    });
  }
}

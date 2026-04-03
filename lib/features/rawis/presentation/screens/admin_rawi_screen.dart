import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../../../../core/presentation/widgets/admin_pagination.dart';
import '../../../../core/presentation/widgets/empty_state_widget.dart';
import '../../../../core/presentation/widgets/search_field_widget.dart';
import '../../data/repositories/rawi_repositories_provider.dart';
import '../../domain/models/rawi.dart';
import '../providers/admin_rawi_future_provider.dart';
import '../providers/search_provider.dart';
import '../widgets/admin_rawis_table.dart';
import '../widgets/rawi_dialog.dart';

class AdminRawiScreen extends StatelessWidget {
  const AdminRawiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var ctr = TextEditingController();

    return Column(
      children: [
        Consumer(
          builder: (context, ref, child) {
            final currentSearch = ref.watch(searchProvider);
            if (ctr.text != currentSearch) {
              ctr.text = currentSearch;
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                children: [
                  Row(
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
                      // DropdownButton<bool?>(
                      //   value: ref.watch(publishedFilterProvider),
                      //   items: [
                      //     DropdownMenuItem(
                      //       value: null,
                      //       child: Text('الكل'),
                      //     ),
                      //     DropdownMenuItem(
                      //       value: true,
                      //       child: Text('منشور'),
                      //     ),
                      //     DropdownMenuItem(
                      //       value: false,
                      //       child: Text('غير منشور'),
                      //     ),
                      //   ],
                      //   onChanged: (value) {
                      //     ref.read(publishedFilterProvider.notifier).state =
                      //         value;
                      //   },
                      // ),
                      //   ],
                      // ),
                      // SizedBox(height: 16),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => RawiDialog(
                                onSave: (rawi) async {
                                  try {
                                    final repo = ref.read(
                                      rawiRepositoryProvider,
                                    );
                                    await repo.createRawi(rawi);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('تم إنشاء الراوي بنجاح'),
                                      ),
                                    );
                                    ref.invalidate(adminRawisFutureProvider);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('خطأ')),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                          label: Text('إنشاء راوي'),
                          icon: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        Consumer(
          builder: (context, ref, child) {
            final currentSearch = ref.watch(searchProvider).trim();
            var rawis = ref.watch(adminRawisFutureProvider);
            return rawis.when(
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
              data: (data) {
                if (data.isEmpty) {
                  return Expanded(child: EmptyStateWidget());
                }
                return Expanded(
                  child: AdminPaginatedDataView<Rawi>(
                    items: data,
                    stateKey: currentSearch,
                    itemBuilder: (context, pageItems) => AdminRawisTable(
                      rawis: pageItems,
                      onDelete: (Rawi r1) {
                        _showDeleteConfirmationDialog(context, ref, r1);
                      },
                      onEdit: (Rawi r1) {
                        showDialog(
                          context: context,
                          builder: (context) => RawiDialog(
                            rawi: r1,
                            onSave: (Rawi? r1) async {
                              try {
                                final repo = ref.read(rawiRepositoryProvider);
                                await repo.updateRawi(r1!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('تم تحديث الراوي بنجاح'),
                                  ),
                                );
                                ref.invalidate(adminRawisFutureProvider);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('حدث خطأ أثناء تحديث الراوي'),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              error: (error, stackTrace) => Expanded(
                child: EmptyStateWidget(message: 'خطأ في تحميل الرواة'),
              ),
              loading: () =>
                  Expanded(child: Center(child: CircularProgressIndicator())),
            );
          },
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    Rawi rawi,
  ) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'حذف الراوي',
        content: 'هل أنت متأكد من حذف هذا الراوي؟',
        onConfirm: () async {
          final repo = ref.read(rawiRepositoryProvider);
          await repo.deleteRawi(rawi.id!);
          ref.invalidate(adminRawisFutureProvider);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('تم حذف الراوي بنجاح')));
          }
        },
      ),
    );
  }
}

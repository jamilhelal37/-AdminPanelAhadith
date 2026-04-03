import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/admin_pagination.dart';
import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../../../../core/presentation/widgets/empty_state_widget.dart';
import '../../../../core/presentation/widgets/search_field_widget.dart';
import '../../data/repositories/muhaddith_repositories_provider.dart';
import '../../domain/models/muhaddith.dart';
import '../providers/muhaddith_future_provider.dart';
import '../providers/search_provider.dart';
import '../widgets/admin_muhaddiths_table.dart';
import '../widgets/muhaddith_dialog.dart';

class AdminMuhaddithScreen extends StatelessWidget {
  const AdminMuhaddithScreen({super.key});

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
                              builder: (context) => MuhaddithDialog(
                                onSave: (muhaddith) async {
                                  try {
                                    final repo = ref.read(
                                      muhaddithRepositoryProvider,
                                    );
                                    await repo.createMuhaddith(muhaddith);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('تم إنشاء المحدث بنجاح'),
                                      ),
                                    );
                                    ref.invalidate(
                                      adminMuhaddithFutureProvider,
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('خطأ')),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                          label: Text('إنشاء محدث'),
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
            var muhaddiths = ref.watch(adminMuhaddithFutureProvider);
            return muhaddiths.when(
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
              data: (data) {
                if (data.isEmpty) {
                  return Expanded(child: EmptyStateWidget());
                }
                return Expanded(
                  child: AdminPaginatedDataView<Muhaddith>(
                    items: data,
                    stateKey: currentSearch,
                    itemBuilder: (context, pageItems) => AdminMuhaddithsTable(
                      muhaddiths: pageItems,
                      onDelete: (Muhaddith m1) {
                        _showDeleteConfirmationDialog(context, ref, m1);
                      },
                      onEdit: (Muhaddith m1) {
                        showDialog(
                          context: context,
                          builder: (context) => MuhaddithDialog(
                            muhaddith: m1,
                            onSave: (Muhaddith? m1) async {
                              try {
                                final repo = ref.read(
                                  muhaddithRepositoryProvider,
                                );
                                await repo.updateMuhaddith(m1!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('تم تحديث المحدث بنجاح'),
                                  ),
                                );
                                ref.invalidate(adminMuhaddithFutureProvider);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('حدث خطأ أثناء تحديث المحدث'),
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
                child: EmptyStateWidget(message: 'خطأ في تحميل المحدثين'),
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
    Muhaddith muhaddith,
  ) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'حذف المحدث',
        content: 'هل أنت متأكد من حذف هذا المحدث؟',
        onConfirm: () async {
          final repo = ref.read(muhaddithRepositoryProvider);
          await repo.deleteMuhaddith(muhaddith.id!);
          ref.invalidate(adminMuhaddithFutureProvider);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('تم حذف المحدث بنجاح')));
          }
        },
      ),
    );
  }
}

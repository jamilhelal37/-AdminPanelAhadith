import 'package:flutter/material.dart';
import 'package:ahadith/features/explaining/domain/models/explaining.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/admin_pagination.dart';
import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../../../../core/presentation/widgets/empty_state_widget.dart';
import '../../../../core/presentation/widgets/search_field_widget.dart';
import '../../data/repositories/explaining_repositories_provider.dart';
import '../providers/admin_explaining_future_provider.dart';
import '../../../explaining/presentation/providers/search_provider.dart';
import '../widgets/admin_explainings_table.dart';
import '../widgets/explaining_dialog.dart';

class AdminExplainingScreen extends StatelessWidget {
  const AdminExplainingScreen({super.key});

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

                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => ExplainingDialog(
                                onSave: (explaining) async {
                                  try {
                                    final repo = ref.read(
                                      explainingRepositoryProvider,
                                    );
                                    await repo.createExplaining(explaining);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('تم إنشاء الشرح بنجاح'),
                                      ),
                                    );
                                    ref.invalidate(
                                      adminExplainingsFutureProvider,
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
                          label: Text('إنشاء شرح'),
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
            var explainings = ref.watch(adminExplainingsFutureProvider);
            return explainings.when(
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
              data: (data) {
                if (data.isEmpty) {
                  return Expanded(child: EmptyStateWidget());
                }
                return Expanded(
                  child: AdminPaginatedDataView<Explaining>(
                    items: data,
                    stateKey: currentSearch,
                    itemBuilder: (context, pageItems) => AdminExplainingsTable(
                      explainings: pageItems,
                      onDelete: (Explaining explaining) {
                        _showDeleteConfirmationDialog(context, ref, explaining);
                      },
                      onEdit: (Explaining explaining) {
                        showDialog(
                          context: context,
                          builder: (context) => ExplainingDialog(
                            explaining: explaining,
                            onSave: (Explaining? explaining) async {
                              try {
                                final repo = ref.read(
                                  explainingRepositoryProvider,
                                );
                                await repo.updateExplaining(explaining!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('تم تحديث الشرح بنجاح'),
                                  ),
                                );
                                ref.invalidate(adminExplainingsFutureProvider);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
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
                child: EmptyStateWidget(message: 'خطأ في تحميل الشروحات'),
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
    Explaining explaining,
  ) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'حذف الشرح',
        content: 'هل أنت متأكد من حذف هذا الشرح؟',
        onConfirm: () async {
          final repo = ref.read(explainingRepositoryProvider);
          await repo.deleteExplaining(explaining.id!);
          ref.invalidate(adminExplainingsFutureProvider);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('تم حذف الشرح بنجاح')));
          }
        },
      ),
    );
  }
}

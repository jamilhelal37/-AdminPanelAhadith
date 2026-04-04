import 'package:flutter/material.dart';
import 'package:ahadith/features/ruling/domain/models/ruling.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widgets/admin_pagination.dart';
import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../../../../core/presentation/widgets/empty_state_widget.dart';
import '../../../../core/presentation/widgets/search_field_widget.dart';
import '../../data/repositories/ruling_repositories_provider.dart';
import '../providers/search_provider.dart';
import '../providers/ruling_future_provider.dart';
import '../widgets/admin_rulings_table.dart';
import '../widgets/ruling_dialog.dart';

class AdminRulingScreen extends StatelessWidget {
  const AdminRulingScreen({super.key});

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
                              builder: (context) => RulingDialog(
                                onSave: (ruling) async {
                                  try {
                                    final repo = ref.read(
                                      rulingRepositoryProvider,
                                    );
                                    await repo.createRuling(ruling!);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('تم إنشاء الحكم بنجاح'),
                                      ),
                                    );
                                    ref.invalidate(adminRulingsFutureProvider);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                          label: Text('إنشاء حكم'),
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
            var rulings = ref.watch(adminRulingsFutureProvider);
            return rulings.when(
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
              data: (data) {
                if (data.isEmpty) {
                  return Expanded(child: EmptyStateWidget());
                }
                return Expanded(
                  child: AdminPaginatedDataView<Ruling>(
                    items: data,
                    stateKey: currentSearch,
                    itemBuilder: (context, pageItems) => AdminRulingsTable(
                      rulings: pageItems,
                      onDelete: (Ruling r1) {
                        _showDeleteConfirmationDialog(context, ref, r1);
                      },
                      onEdit: (Ruling r1) {
                        showDialog(
                          context: context,
                          builder: (context) => RulingDialog(
                            ruling: r1,
                            onSave: (Ruling? r1) async {
                              try {
                                final repo = ref.read(rulingRepositoryProvider);
                                await repo.updateRuling(r1!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('تم تحديث الحكم بنجاح'),
                                  ),
                                );
                                ref.invalidate(adminRulingsFutureProvider);
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
                child: EmptyStateWidget(message: 'خطأ في تحميل الأحكام'),
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
    Ruling ruling,
  ) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'حذف الحكم',
        content: 'هل أنت متأكد من حذف هذا الحكم؟',
        onConfirm: () async {
          final repo = ref.read(rulingRepositoryProvider);
          await repo.deleteRuling(ruling.id!);
          ref.invalidate(adminRulingsFutureProvider);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('تم حذف الحكم بنجاح')));
          }
        },
      ),
    );
  }
}

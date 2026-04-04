import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widgets/admin_pagination.dart';
import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../../../../core/presentation/widgets/empty_state_widget.dart';
import '../../../../core/presentation/widgets/search_field_widget.dart';
import '../../data/repositories/topic_repositories_provider.dart';
import '../providers/search_provider.dart';
import '../../domain/models/topic.dart';
import '../providers/topic_future_provider.dart';
import '../widgets/admin_topics_table.dart';
import '../widgets/topic_dialog.dart';

class AdminTopicScreen extends StatelessWidget {
  const AdminTopicScreen({super.key});

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
                              builder: (context) => TopicDialog(
                                onSave: (topic) async {
                                  try {
                                    final repo = ref.read(
                                      topicRepositoryProvider,
                                    );
                                    await repo.createTopic(topic!);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('تم إنشاء الموضوع بنجاح'),
                                      ),
                                    );
                                    ref.invalidate(adminTopicsFutureProvider);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('خطأ')),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                          label: Text('إنشاء موضوع'),
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
            var topics = ref.watch(adminTopicsFutureProvider);
            return topics.when(
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
              data: (data) {
                if (data.isEmpty) {
                  return Expanded(child: EmptyStateWidget());
                }
                return Expanded(
                  child: AdminPaginatedDataView<Topic>(
                    items: data,
                    stateKey: currentSearch,
                    itemBuilder: (context, pageItems) => AdminTopicsTable(
                      topics: pageItems,
                      onDelete: (Topic t1) {
                        _showDeleteConfirmationDialog(context, ref, t1);
                      },
                      onEdit: (Topic t1) {
                        showDialog(
                          context: context,
                          builder: (context) => TopicDialog(
                            topic: t1,
                            onSave: (Topic? t1) async {
                              try {
                                final repo = ref.read(topicRepositoryProvider);
                                await repo.updateTopic(t1!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('تم تحديث الموضوع بنجاح'),
                                  ),
                                );
                                ref.invalidate(adminTopicsFutureProvider);
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
                child: EmptyStateWidget(message: 'خطأ في تحميل المواضيع'),
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
    Topic topic,
  ) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'حذف الموضوع',
        content: 'هل أنت متأكد من حذف هذا الموضوع؟',
        onConfirm: () async {
          final repo = ref.read(topicRepositoryProvider);
          await repo.deleteTopic(topic.id!);
          ref.invalidate(adminTopicsFutureProvider);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('تم حذف الموضوع بنجاح')));
          }
        },
      ),
    );
  }
}

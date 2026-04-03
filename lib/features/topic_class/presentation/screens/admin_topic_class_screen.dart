import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';

import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../../../../core/presentation/widgets/admin_pagination.dart';
import '../../../../core/presentation/widgets/empty_state_widget.dart';
import '../../../../core/presentation/widgets/search_field_widget.dart';

import '../../data/repositories/topic_class_repositories_provider.dart';
import '../../domain/models/topic_class.dart';
import '../providers/admin_topic_class_future_provider.dart';
import '../providers/search_provider.dart';
import '../widgets/admin_topic_classes_table.dart';
import '../widgets/topic_classification_dialog.dart';

class AdminTopicClassScreen extends ConsumerStatefulWidget {
  const AdminTopicClassScreen({super.key});

  @override
  ConsumerState<AdminTopicClassScreen> createState() =>
      _AdminTopicClassScreenState();
}

class _AdminTopicClassScreenState extends ConsumerState<AdminTopicClassScreen> {
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

    final topicClassesAsync = ref.watch(adminTopicClassesFutureProvider);

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
                    builder: (_) => TopicClassificationDialog(
                      onSaved: () {
                        ref.invalidate(adminTopicClassesFutureProvider);
                      },
                    ),
                  );
                },
                label: Text('تصنيف المواضيع'),
                icon: Icon(Icons.label),
              ),
            ],
          ),
        ),
        Expanded(
          child: topicClassesAsync.when(
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            data: (data) {
              if (data.isEmpty) return EmptyStateWidget();

              return AdminPaginatedDataView<TopicClass>(
                items: data,
                stateKey: currentSearch.trim(),
                itemBuilder: (context, pageItems) => AdminTopicClassesTable(
                  topicClasses: pageItems,
                  onDelete: (tc) => _showDeleteConfirmationDialog(context, tc),
                  onEdit: (tc) {
                    showDialog(
                      context: context,
                      builder: (_) => TopicClassificationDialog(
                        topicClass: tc,
                        onSaved: () {
                          ref.invalidate(adminTopicClassesFutureProvider);
                        },
                      ),
                    );
                  },
                ),
              );
            },
            error: (error, stackTrace) =>
                EmptyStateWidget(message: 'خطأ في تحميل تصنيفات المواضيع'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    TopicClass topicClass,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) => ConfirmationDialog(
        title: 'حذف تصنيف الموضوع',
        content: 'هل أنت متأكد من حذف تصنيف الموضوع؟',
        onConfirm: () async {
          try {
            if (topicClass.id == null) {
              throw AppFailure.validation('معرّف التصنيف الموضوعي غير موجود.');
            }

            final repo = ref.read(topicClassRepositoryProvider);
            await repo.deleteTopicClass(topicClass.id!);

            ref.invalidate(adminTopicClassesFutureProvider);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم حذف تصنيف الموضوع بنجاح')),
              );
            }
          } catch (e, st) {
            debugPrint("DELETE TOPIC CLASS ERROR: $e");
            debugPrint("$st");
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(e.toString())));
            }
          }
        },
      ),
    );
  }
}

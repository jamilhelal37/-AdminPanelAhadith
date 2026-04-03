import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';

import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../../../../core/presentation/widgets/admin_pagination.dart';
import '../../../../core/presentation/widgets/empty_state_widget.dart';
import '../../../../core/presentation/widgets/search_field_widget.dart';

import '../../data/repositories/question_repository_provider.dart';
import '../../domain/models/question.dart';

import '../providers/question_future_provider.dart';
import '../providers/search_provider.dart';
import '../providers/status_filter_provider.dart';
import '../providers/asker_options_provider.dart';
import '../widgets/admin_questions_table.dart';
import '../widgets/question_dialog.dart';

class AdminQuestionScreen extends StatelessWidget {
  const AdminQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctr = TextEditingController();

    return Column(
      children: [
        Consumer(
          builder: (context, ref, child) {
            final currentSearch = ref.watch(searchProvider);
            if (ctr.text != currentSearch) {
              ctr.text = currentSearch;
              ctr.selection = TextSelection.collapsed(
                offset: currentSearch.length,
              );
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: DropdownButtonFormField<QuestionStatusFilter>(
                      initialValue: ref.watch(questionStatusFilterProvider),
                      decoration: InputDecoration(
                        labelText: 'الحالة',
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: QuestionStatusFilter.all,
                          child: Text('الكل'),
                        ),
                        DropdownMenuItem(
                          value: QuestionStatusFilter.active,
                          child: Text('نشط'),
                        ),
                        DropdownMenuItem(
                          value: QuestionStatusFilter.inactive,
                          child: Text('غير نشط'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        ref.read(questionStatusFilterProvider.notifier).state =
                            value;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
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
                ],
              ),
            );
          },
        ),
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final questionsAsync = ref.watch(adminQuestionsFutureProvider);
              final askersAsync = ref.watch(askerOptionsFutureProvider);
              final currentSearch = ref.watch(searchProvider).trim();
              final statusFilter = ref.watch(questionStatusFilterProvider);

              return questionsAsync.when(
                skipLoadingOnRefresh: true,
                skipLoadingOnReload: true,
                data: (data) {
                  if (data.isEmpty) {
                    return EmptyStateWidget();
                  }
                  return AdminPaginatedDataView<Question>(
                    items: data,
                    stateKey: '$currentSearch|${statusFilter.name}',
                    itemBuilder: (context, pageItems) => askersAsync.when(
                      data: (askers) {
                        final askerNameById = {
                          for (final a in askers) a.id: a.name,
                        };
                        return AdminQuestionsTable(
                          questions: pageItems,
                          askerNameById: askerNameById,
                          onDelete: (q) =>
                              _showDeleteConfirmationDialog(context, ref, q),
                          // ? ????? ?????? ???
                          onEditAnswer: (q) {
                            showDialog(
                              context: context,
                              builder: (_) => QuestionDialog(
                                question: q,
                                onSave: (Question updated) async {
                                  try {
                                    final repo = ref.read(
                                      questionRepositoryProvider,
                                    );
                                    await repo.updateQuestion(updated);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('تم تحديث الإجابة بنجاح'),
                                      ),
                                    );
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, _) => AdminQuestionsTable(
                        questions: pageItems,
                        askerNameById: const {},
                        onDelete: (q) =>
                            _showDeleteConfirmationDialog(context, ref, q),
                        onEditAnswer: (q) {
                          showDialog(
                            context: context,
                            builder: (_) => QuestionDialog(
                              question: q,
                              onSave: (Question updated) async {
                                try {
                                  final repo = ref.read(
                                    questionRepositoryProvider,
                                  );
                                  await repo.updateQuestion(updated);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("تم تحديث الإجابة بنجاح"),
                                    ),
                                  );
                                } catch (e) {
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
                    ),
                  );
                },
                error: (error, stackTrace) =>
                    EmptyStateWidget(message: 'تعذر تحميل الأسئلة'),
                loading: () => const Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    Question question,
  ) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'حذف السؤال',
        content: 'هل أنت متأكد أنك تريد حذف هذا السؤال؟',
        onConfirm: () async {
          try {
            if (question.id == null) {
              throw AppFailure.validation('معرّف السؤال غير موجود.');
            }

            final repo = ref.read(questionRepositoryProvider);
            await repo.deleteQuestion(question.id!);

            if (context.mounted) context.pop();

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف السؤال بنجاح')),
              );
            }
          } catch (e) {
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

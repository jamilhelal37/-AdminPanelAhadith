import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../../data/repositories/question_repository_provider.dart';
import '../providers/my_questions_provider.dart';
import '../widgets/ask_question_dialog.dart';
import '../widgets/ask_question_floating_button.dart';
import '../widgets/questions_empty_state.dart';

class MyQuestionsScreen extends ConsumerWidget {
  const MyQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(myQuestionsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
        title: Text('أسئلتي'),
        centerTitle: true,
      ),
      floatingActionButton: AskQuestionFloatingButton(
        label: 'اطرح سؤالك',
        onPressed: () async {
          await showDialog<void>(
            context: context,
            builder: (_) => const AskQuestionDialog(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: questionsAsync.when(
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '${'حدث خطأ ما'}: $e',
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (questions) {
            if (questions.isEmpty) {
              return _buildEmptyState(context);
            }

            final answeredCount = questions
                .where(
                  (question) => (question.answerText ?? '').trim().isNotEmpty,
                )
                .length;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                _buildSummaryCard(
                  context,
                  total: questions.length,
                  answered: answeredCount,
                ),
                const SizedBox(height: 16),
                ...questions.asMap().entries.map((entry) {
                  final question = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _buildQuestionCard(
                      context,
                      ref: ref,
                      index: entry.key + 1,
                      questionId: question.id,
                      questionText: question.askerText,
                      answerText: question.answerText,
                      createdAt: question.createdAt,
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required int total,
    required int answered,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.65),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.14),
                  ),
                ),
                child: Icon(
                  Icons.question_answer_outlined,
                  color: colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'حالة الأسئلة :',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'ملخص سريع لحالة الأسئلة والإجابات',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  context,
                  label:
                      'إجمالي الأسئلة',
                  value: '$total',
                  icon: Icons.format_list_numbered_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatBox(
                  context,
                  label: 'تمت الإجابة',
                  value: '$answered',
                  icon: Icons.mark_chat_read_outlined,
                  highlighted: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(
    BuildContext context, {
    required String label,
    required String value,
    IconData? icon,
    bool highlighted = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: highlighted
            ? colorScheme.primaryContainer.withValues(alpha: 0.28)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: highlighted
              ? colorScheme.primary.withValues(alpha: 0.28)
              : colorScheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: colorScheme.primary),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context, {
    required WidgetRef ref,
    required int index,
    required String? questionId,
    required String questionText,
    required String? answerText,
    required String createdAt,
  }) {
    final answer = (answerText ?? '').trim();
    final hasAnswer = answer.isNotEmpty;

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Theme.of(context).colorScheme.surface, border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'السؤال $index :',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
                if (questionId != null) ...[
                  _buildDeleteButton(
                    context,
                    onTap: () =>
                        _showDeleteConfirmationDialog(context, ref, questionId),
                  ),
                  const SizedBox(width: 8),
                ],
                _buildStatusChip(context, hasAnswer: hasAnswer),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(createdAt),
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 14),
            _buildTextSection(
              context,
              title: 'السؤال :',
              content: questionText,
              icon: Icons.help_outline_rounded,
            ),
            const SizedBox(height: 12),
            _buildTextSection(
              context,
              title: hasAnswer
                  ? 'الإجابة :'
                  : 'حالة الإجابة :',
              content: hasAnswer
                  ? answer
                  : 'بانتظار الإجابة على سؤالك',
              icon: hasAnswer
                  ? Icons.mark_chat_read_outlined
                  : Icons.hourglass_bottom_rounded,
              highlighted: hasAnswer,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSection(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    bool highlighted = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1), color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, {required bool hasAnswer}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: hasAnswer
            ? colorScheme.primaryContainer.withValues(alpha: 0.75)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: hasAnswer ? colorScheme.primary : colorScheme.outlineVariant,
        ),
      ),
      child: Text(
        hasAnswer
            ? 'تمت الإجابة'
            : 'بانتظار الإجابة',
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildDeleteButton(
    BuildContext context, {
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: colorScheme.primary.withValues(alpha: 0.12),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.16),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete_outline_rounded,
              size: 18,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              'حذف',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    String questionId,
  ) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'حذف السؤال',
        content:
            'هل تريد حذف هذا السؤال؟',
        onConfirm: () async {
          final repo = ref.read(questionRepositoryProvider);
          await repo.deleteQuestion(questionId);

          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'تم حذف السؤال بنجاح',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const QuestionsEmptyState(
      title: 'لم تطرح أي أسئلة',
      subtitle:
          'اطرح سؤالك الأول وسيظهر هنا مع حالته والإجابة عليه.',
    );
  }

  String _formatDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    final month = parsed.month.toString().padLeft(2, '0');
    final day = parsed.day.toString().padLeft(2, '0');
    return '${parsed.year}/$month/$day';
  }
}




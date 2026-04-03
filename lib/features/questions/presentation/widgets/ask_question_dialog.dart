import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/presentation/providers/loading_provider.dart';
import '../../../auth/presentation/providers/auth_notifier_provider.dart';
import '../providers/ask_question_provider.dart';

const _askQuestionLoadingScope = 'ask-question-dialog';

class AskQuestionDialog extends ConsumerStatefulWidget {
  const AskQuestionDialog({super.key});

  @override
  ConsumerState<AskQuestionDialog> createState() => _AskQuestionDialogState();
}

class _AskQuestionDialogState extends ConsumerState<AskQuestionDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = ref.watch(
      scopedLoadingProvider(_askQuestionLoadingScope),
    );

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      contentPadding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.16),
                    ),
                  ),
                  child: Icon(
                    Icons.edit_note_rounded,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'اكتب سؤالك',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
                IconButton(
                  onPressed: isLoading ? null : () => context.pop(),
                  icon: Icon(Icons.close_rounded, color: colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'اكتب سؤالك بوضوح ليتمكن المختص من الإجابة عليه بشكل أدق.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                maxLines: 5,
                minLines: 4,
                textDirection: TextDirection.rtl,
                cursorColor: colorScheme.primary,
                style: TextStyle(fontSize: 16, height: 1.5),
                decoration: InputDecoration(
                  hintText: 'اكتب سؤالك هنا',
                  hintStyle: TextStyle(fontSize: 14),
                  alignLabelWithHint: true,
                  contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  filled: true,
                  fillColor: colorScheme.primaryContainer.withValues(
                    alpha: 0.08,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(
                      color: colorScheme.primary.withValues(alpha: 0.72),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : _submitQuestion,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 48,
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
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.primary,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.send_rounded,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'إرسال',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitQuestion() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    try {
      ref.read(scopedLoadingProvider(_askQuestionLoadingScope).notifier).state =
          true;

      final userId = ref.read(authNotifierProvider).valueOrNull?.id ?? '';
      if (userId.isEmpty) {
        throw AppFailure.unauthorized(
          'يجب تسجيل الدخول أولًا.',
        );
      }

      await ref.read(
        askQuestionProvider(
          AskQuestionParams(askerId: userId, questionText: question),
        ).future,
      );

      if (!mounted) return;
      ref.read(scopedLoadingProvider(_askQuestionLoadingScope).notifier).state =
          false;
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إضافة السؤال بنجاح')),
      );
    } catch (_) {
      ref.read(scopedLoadingProvider(_askQuestionLoadingScope).notifier).state =
          false;
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ ما')));
    }
  }
}



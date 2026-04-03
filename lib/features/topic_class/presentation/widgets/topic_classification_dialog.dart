import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/presentation/providers/loading_provider.dart';
import '../../../../core/presentation/widgets/admin_web_dialog_shell.dart';
import '../../../ahadith/domain/models/hadith.dart';
import '../../../ahadith/presentation/providers/hadith_by_id_provider.dart';
import '../../../ahadith/presentation/widgets/hadith_picker_dialog.dart';
import '../../data/repositories/topic_class_repositories_provider.dart';
import '../../domain/models/topic_class.dart';
import '../providers/topic_classes_by_hadith_provider.dart';
import '../providers/topic_classification_form_provider.dart';
import 'hadith_selection_card.dart';
import 'topics_multi_select.dart';

const _topicClassificationDialogLoadingScope = 'topic-classification-dialog';

class TopicClassificationDialog extends ConsumerStatefulWidget {
  const TopicClassificationDialog({
    super.key,
    this.topicClass,
    required this.onSaved,
  });

  final TopicClass? topicClass;
  final VoidCallback onSaved;

  @override
  ConsumerState<TopicClassificationDialog> createState() =>
      _TopicClassificationDialogState();
}

class _TopicClassificationDialogState
    extends ConsumerState<TopicClassificationDialog> {
  bool _hasTriggeredValidation = false;
  Hadith? _selectedHadith;
  List<String> _selectedTopicIds = [];
  bool _isLoadingInitialData = false;

  @override
  void initState() {
    super.initState();
    if (widget.topicClass != null) {
      _loadEditData();
    }
  }

  Future<void> _loadEditData() async {
    setState(() => _isLoadingInitialData = true);

    try {
      final topicClass = widget.topicClass!;
      final hadithId = topicClass.hadithId;
      if (hadithId == null || hadithId.isEmpty) {
        throw AppFailure.validation('معرّف الحديث مفقود.');
      }

      final hadith = await ref.read(hadithByIdProvider(hadithId).future);
      final relatedTopicClasses = await ref.read(
        topicClassesByHadithIdProvider(hadithId).future,
      );
      final topicIds = relatedTopicClasses
          .map((tc) => tc.topicId)
          .whereType<String>()
          .toList();

      if (mounted) {
        setState(() {
          _selectedHadith = hadith;
          _selectedTopicIds = topicIds;
          _isLoadingInitialData = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ في تحميل بيانات التعديل: $e');
      if (!mounted) return;
      setState(() => _isLoadingInitialData = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في تحميل البيانات: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final maxDialogWidth = (screenSize.width - 56).clamp(920.0, 1500.0);
    final form = ref.watch(
      topicClassificationFormProvider((_selectedHadith, _selectedTopicIds)),
    );

    if (!_hasTriggeredValidation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        form.markAllAsTouched();
        setState(() => _hasTriggeredValidation = true);
      });
    }

    if (_isLoadingInitialData) {
      return AdminWebDialogShell(
        icon: Icons.account_tree_outlined,
        title: 'ربط الحديث بالموضوع',
        subtitle: 'جاري تحميل بيانات الربط الحالية...',
        maxWidth: maxDialogWidth.toDouble(),
        onClose: () => context.pop(),
        badges: const [
          AdminWebDialogBadge(
            label: 'تهيئة البيانات',
            icon: Icons.sync_rounded,
            highlighted: true,
          ),
        ],
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return ReactiveForm(
      formGroup: form,
      child: AdminWebDialogShell(
        icon: Icons.account_tree_outlined,
        title: 'ربط الحديث بالموضوع',
        subtitle:
            'اختر الحديث أولًا، ثم حدّد الموضوعات المرتبطة به من خلال تدفق مخصص للويب.',
        maxWidth: maxDialogWidth.toDouble(),
        maxHeightFactor: 0.9,
        onClose: () => context.pop(),
        badges: [
          AdminWebDialogBadge(
            label: _selectedHadith == null
                ? 'لم يتم اختيار حديث'
                : 'تم اختيار حديث',
            icon: Icons.auto_stories_rounded,
          ),
          AdminWebDialogBadge(
            label: '${_selectedTopicIds.length} موضوع',
            icon: Icons.category_outlined,
          ),
        ],
        footer: ReactiveFormConsumer(
          builder: (context, formGroup, child) {
            final isLoading = ref.watch(
              scopedLoadingProvider(_topicClassificationDialogLoadingScope),
            );

            return Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close_rounded, size: 18),
                    label: const Text('إلغاء'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed:
                        (_selectedHadith == null ||
                            _selectedTopicIds.isEmpty ||
                            isLoading)
                        ? null
                        : () => _handleSave(context),
                    icon: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_rounded, size: 18),
                    label: Text(
                      isLoading
                          ? 'جارٍ الحفظ...'
                          : widget.topicClass != null
                          ? 'تحديث الربط'
                          : 'حفظ الربط',
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdminWebDialogSection(
                title: '1. اختيار الحديث',
                subtitle:
                    'اختر الحديث الذي تريد ربطه بواحد أو أكثر من الموضوعات.',
                child: HadithSelectionCard(
                  selectedHadith: _selectedHadith,
                  onAddHadith: () => _showHadithPickerDialog(context),
                ),
              ),
              const SizedBox(height: 18),
              AdminWebDialogSection(
                title: '2. اختيار الموضوعات',
                subtitle:
                    'ابحث داخل قائمة الموضوعات وحدد كل ما ينطبق على الحديث المختار.',
                child: TopicsMultiSelect(
                  selectedTopicIds: _selectedTopicIds,
                  onSelectionChanged: (topicIds) {
                    setState(() => _selectedTopicIds = topicIds);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHadithPickerDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (dialogCtx) => HadithPickerDialog(
        currentHadithId: _selectedHadith?.id,
        title: 'اختر حديثًا',
        allowEmptySelection: false,
      ),
    ).then((selectedId) async {
      if (selectedId == null || selectedId.isEmpty) return;

      try {
        final hadith = await ref.read(hadithByIdProvider(selectedId).future);

        if (mounted) {
          setState(() {
            _selectedHadith = hadith;
            _selectedTopicIds = [];
          });
        }

        try {
          final relatedTopicClasses = await ref.read(
            topicClassesByHadithIdProvider(selectedId).future,
          );
          final topicIds = relatedTopicClasses
              .map((tc) => tc.topicId)
              .whereType<String>()
              .toList();

          if (mounted) {
            setState(() {
              _selectedTopicIds = topicIds;
            });
          }
        } catch (e) {
          debugPrint('خطأ في تحميل الموضوعات المرتبطة: $e');
          if (mounted) {
            setState(() {
              _selectedTopicIds = [];
            });
          }
        }
      } catch (e) {
        debugPrint('خطأ في جلب الحديث: $e');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('خطأ في تحميل تفاصيل الحديث')),
        );
      }
    });
  }

  Future<void> _handleSave(BuildContext context) async {
    ref
            .read(
              scopedLoadingProvider(
                _topicClassificationDialogLoadingScope,
              ).notifier,
            )
            .state =
        true;

    try {
      final repo = ref.read(topicClassRepositoryProvider);
      final now = DateTime.now().toIso8601String();
      final hadithId = _selectedHadith!.id!;
      final uniqueTopicIds = _selectedTopicIds.toSet().toList();

      final oldTopicClasses = await ref.read(
        topicClassesByHadithIdProvider(hadithId).future,
      );

      for (final tc in oldTopicClasses) {
        if (tc.id != null) {
          await repo.deleteTopicClass(tc.id!);
        }
      }

      for (final topicId in uniqueTopicIds) {
        final topicClass = TopicClass(
          id: null,
          topicId: topicId,
          hadithId: hadithId,
          createdAt: now,
          updatedAt: now,
        );
        await repo.createTopicClass(topicClass);
      }

      if (!mounted) return;

      ref.invalidate(topicClassesByHadithIdProvider(hadithId));
      widget.onSaved();
      context.pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.topicClass != null
                ? 'تم تحديث تصنيفات المواضيع بنجاح'
                : 'تم إنشاء تصنيفات المواضيع بنجاح',
          ),
        ),
      );
    } catch (e, st) {
      debugPrint('خطأ في حفظ تصنيف المواضيع: $e');
      debugPrint('$st');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        ref
                .read(
                  scopedLoadingProvider(
                    _topicClassificationDialogLoadingScope,
                  ).notifier,
                )
                .state =
            false;
      }
    }
  }
}

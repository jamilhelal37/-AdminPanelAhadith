import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/presentation/providers/loading_provider.dart';
import '../../../../core/presentation/widgets/admin_web_dialog_shell.dart';
import '../../../ahadith/domain/models/hadith.dart';
import '../../../ahadith/presentation/providers/hadith_by_id_provider.dart';
import '../../../ahadith/presentation/widgets/hadith_picker_dialog.dart';
import '../../data/repositories/similar_ahadith_repositories_provider.dart';
import '../../domain/models/similar_ahadith.dart';
import '../providers/similar_ahadiths_by_main_hadith_provider.dart';
import 'ahadith_multi_select.dart';

const _similarAhadithClassificationDialogLoadingScope =
    'similar-ahadith-classification-dialog';

class SimilarAhadithClassificationDialog extends ConsumerStatefulWidget {
  const SimilarAhadithClassificationDialog({
    super.key,
    this.similarAhadith,
    required this.onSaved,
  });

  final SimilarAhadith? similarAhadith;
  final VoidCallback onSaved;

  @override
  ConsumerState<SimilarAhadithClassificationDialog> createState() =>
      _SimilarAhadithClassificationDialogState();
}

class _SimilarAhadithClassificationDialogState
    extends ConsumerState<SimilarAhadithClassificationDialog> {
  Hadith? _mainHadith;
  List<String> _selectedSimilarHadithIds = [];
  bool _isLoadingInitialData = false;

  @override
  void initState() {
    super.initState();
    if (widget.similarAhadith != null) {
      _loadEditData();
    }
  }

  Future<void> _loadEditData() async {
    setState(() => _isLoadingInitialData = true);

    try {
      final similarAhadith = widget.similarAhadith!;
      final mainHadithId = similarAhadith.mainHadithId;
      if (mainHadithId == null || mainHadithId.isEmpty) {
        throw AppFailure.validation('معرّف الحديث الرئيسي مفقود.');
      }

      final mainHadith = await ref.read(
        hadithByIdProvider(mainHadithId).future,
      );
      final relatedSimilarAhadiths = await ref.read(
        similarAhadithsByMainHadithProvider(mainHadithId).future,
      );

      final simHadithIds = relatedSimilarAhadiths
          .map((sa) => sa.simHadithId)
          .whereType<String>()
          .toList();

      if (mounted) {
        setState(() {
          _mainHadith = mainHadith;
          _selectedSimilarHadithIds = simHadithIds;
          _isLoadingInitialData = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ في تحميل بيانات التعديل: $e');
      if (mounted) {
        setState(() => _isLoadingInitialData = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في تحميل البيانات: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;
    final maxDialogWidth = (screenSize.width - 56).clamp(980.0, 1500.0);

    if (_isLoadingInitialData) {
      return AdminWebDialogShell(
        icon: Icons.compare_arrows_rounded,
        title: 'تصنيف الأحاديث المتشابهة',
        subtitle: 'جاري تحميل الربط الحالي بين الأحاديث المتشابهة...',
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

    return AdminWebDialogShell(
      icon: Icons.compare_arrows_rounded,
      title: 'تصنيف الأحاديث المتشابهة',
      subtitle:
          'اختر الحديث الرئيسي أولًا، ثم حدّد الأحاديث القريبة منه في المعنى أو اللفظ داخل تدفق إداري مخصص للويب.',
      maxWidth: maxDialogWidth.toDouble(),
      maxHeightFactor: 0.9,
      onClose: () => context.pop(),
      badges: [
        AdminWebDialogBadge(
          label: _mainHadith == null
              ? 'لم يتم اختيار الحديث الرئيسي'
              : 'تم اختيار الحديث الرئيسي',
          icon: Icons.auto_stories_rounded,
        ),
        AdminWebDialogBadge(
          label: '${_selectedSimilarHadithIds.length} حديث مشابه',
          icon: Icons.alt_route_rounded,
        ),
      ],
      footer: Consumer(
        builder: (context, ref, child) {
          final isLoading = ref.watch(
            scopedLoadingProvider(
              _similarAhadithClassificationDialogLoadingScope,
            ),
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
                      (_mainHadith == null ||
                          _selectedSimilarHadithIds.isEmpty ||
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
                        : widget.similarAhadith != null
                        ? 'تحديث التصنيف'
                        : 'حفظ التصنيف',
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 52),
                    textStyle: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
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
              title: '1. اختيار الحديث الرئيسي',
              subtitle:
                  'حدّد الحديث الذي ستُبنى عليه مجموعة التشابه، ويمكنك تغييره قبل الحفظ متى شئت.',
              child: _MainHadithCard(
                mainHadith: _mainHadith,
                onSelectHadith: () => _showMainHadithPickerDialog(context),
              ),
            ),
            const SizedBox(height: 18),
            AdminWebDialogSection(
              title: '2. اختيار الأحاديث المشابهة',
              subtitle:
                  'ابحث داخل الأحاديث ثم اختر كل الأحاديث المشابهة للحديث الرئيسي المحدد.',
              child: AhadithMultiSelect(
                selectedHadithIds: _selectedSimilarHadithIds,
                excludeHadithId: _mainHadith?.id,
                onSelectionChanged: (hadithIds) {
                  setState(() => _selectedSimilarHadithIds = hadithIds);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMainHadithPickerDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (dialogCtx) => HadithPickerDialog(
        currentHadithId: _mainHadith?.id,
        title: 'اختر الحديث الرئيسي',
        allowEmptySelection: false,
      ),
    ).then((selectedId) async {
      if (selectedId == null || selectedId.isEmpty) return;

      try {
        final hadith = await ref.read(hadithByIdProvider(selectedId).future);

        if (mounted) {
          setState(() {
            _mainHadith = hadith;
            _selectedSimilarHadithIds = [];
          });
        }

        try {
          final relatedSimilarAhadiths = await ref.read(
            similarAhadithsByMainHadithProvider(selectedId).future,
          );

          final simHadithIds = relatedSimilarAhadiths
              .map((sa) => sa.simHadithId)
              .whereType<String>()
              .toList();

          if (mounted) {
            setState(() {
              _selectedSimilarHadithIds = simHadithIds;
            });
          }
        } catch (e) {
          debugPrint('خطأ في تحميل الأحاديث المشابهة المرتبطة: $e');
          if (mounted) {
            setState(() {
              _selectedSimilarHadithIds = [];
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
                _similarAhadithClassificationDialogLoadingScope,
              ).notifier,
            )
            .state =
        true;
    try {
      final repo = ref.read(similarAhadithRepositoryProvider);
      final now = DateTime.now().toIso8601String();
      final mainHadithId = _mainHadith!.id!;
      final uniqueSimHadithIds = _selectedSimilarHadithIds.toSet().toList();

      final oldSimilarAhadiths = await ref.read(
        similarAhadithsByMainHadithProvider(mainHadithId).future,
      );

      for (final sa in oldSimilarAhadiths) {
        if (sa.id != null) {
          await repo.deleteSimilarAhadith(sa.id!);
        }
      }

      for (final simHadithId in uniqueSimHadithIds) {
        final similarAhadith = SimilarAhadith(
          id: null,
          mainHadithId: mainHadithId,
          simHadithId: simHadithId,
          createdAt: now,
          updatedAt: now,
        );
        await repo.createSimilarAhadith(similarAhadith);
      }

      if (!mounted) return;

      ref.invalidate(similarAhadithsByMainHadithProvider(mainHadithId));
      widget.onSaved();
      context.pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.similarAhadith != null
                ? 'تم تحديث الأحاديث المتشابهة بنجاح'
                : 'تم إنشاء الأحاديث المتشابهة بنجاح',
          ),
        ),
      );
    } catch (e, st) {
      debugPrint('خطأ في حفظ الأحاديث المشابهة: $e');
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
                    _similarAhadithClassificationDialogLoadingScope,
                  ).notifier,
                )
                .state =
            false;
      }
    }
  }
}

class _MainHadithCard extends StatelessWidget {
  const _MainHadithCard({
    required this.mainHadith,
    required this.onSelectHadith,
  });

  final Hadith? mainHadith;
  final VoidCallback onSelectHadith;

  String _short(String? text, {int max = 220}) {
    if (text == null) return 'غير محدد';
    final value = text.trim();
    if (value.isEmpty) return 'غير محدد';
    if (value.length <= max) return value;
    return '${value.substring(0, max)}...';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (mainHadith == null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelectHadith,
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                cs.primaryContainer.withValues(alpha: 0.14),
                cs.surface,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.28),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    Icons.add_link_rounded,
                    size: 32,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'لم يتم اختيار الحديث الرئيسي بعد',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ابدأ باختيار الحديث الذي ستقارن به بقية الأحاديث المشابهة.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: onSelectHadith,
                  icon: const Icon(Icons.auto_stories_rounded),
                  label: const Text('اختيار الحديث الرئيسي'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final hadith = mainHadith!;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'الحديث الرئيسي المحدد',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onSelectHadith,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('تغيير الحديث'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.tag_rounded,
                label: 'رقم ${hadith.hadithNumber}',
              ),
              _InfoChip(
                icon: Icons.menu_book_outlined,
                label: hadith.sourceName ?? 'كتاب غير محدد',
              ),
              _InfoChip(
                icon: Icons.person_outline_rounded,
                label: hadith.rawiName ?? 'راوٍ غير محدد',
              ),
              _InfoChip(
                icon: Icons.sell_outlined,
                label: _getTypeName(hadith.type),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              _short(hadith.text),
              style: textTheme.bodyMedium?.copyWith(
                height: 1.7,
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeName(HadithType type) {
    switch (type) {
      case HadithType.marfu:
        return 'مرفوع';
      case HadithType.mawquf:
        return 'موقوف';
      case HadithType.qudsi:
        return 'قدسي';
      case HadithType.atharSahaba:
        return 'آثار الصحابة';
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: cs.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

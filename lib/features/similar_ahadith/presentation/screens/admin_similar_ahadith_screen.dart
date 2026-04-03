import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';

import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../../../../core/presentation/widgets/admin_pagination.dart';
import '../../../../core/presentation/widgets/empty_state_widget.dart';
import '../../../../core/presentation/widgets/search_field_widget.dart';

import '../../data/repositories/similar_ahadith_repositories_provider.dart';
import '../../domain/models/similar_ahadith.dart';
import '../providers/admin_similar_ahadith_future_provider.dart';
import '../providers/search_provider.dart';
import '../widgets/admin_similar_ahadiths_table.dart';
import '../widgets/similar_ahadith_classification_dialog.dart';

class AdminSimilarAhadithScreen extends ConsumerStatefulWidget {
  const AdminSimilarAhadithScreen({super.key});

  @override
  ConsumerState<AdminSimilarAhadithScreen> createState() =>
      _AdminSimilarAhadithScreenState();
}

class _AdminSimilarAhadithScreenState
    extends ConsumerState<AdminSimilarAhadithScreen> {
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

    final similarAhadithsAsync = ref.watch(adminSimilarAhadithsFutureProvider);

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
                    builder: (_) => SimilarAhadithClassificationDialog(
                      onSaved: () {
                        ref.invalidate(adminSimilarAhadithsFutureProvider);
                      },
                    ),
                  );
                },
                label: Text('تصنيف الأحاديث المتشابهة'),
                icon: Icon(Icons.compare_arrows),
              ),
            ],
          ),
        ),
        Expanded(
          child: similarAhadithsAsync.when(
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            data: (data) {
              if (data.isEmpty) return EmptyStateWidget();

              return AdminPaginatedDataView<SimilarAhadith>(
                items: data,
                stateKey: currentSearch.trim(),
                itemBuilder: (context, pageItems) => AdminSimilarAhadithsTable(
                  similarAhadiths: pageItems,
                  onDelete: (sa) => _showDeleteConfirmationDialog(context, sa),
                  onEdit: (sa) {
                    showDialog(
                      context: context,
                      builder: (_) => SimilarAhadithClassificationDialog(
                        similarAhadith: sa,
                        onSaved: () {
                          ref.invalidate(adminSimilarAhadithsFutureProvider);
                        },
                      ),
                    );
                  },
                ),
              );
            },
            error: (error, stackTrace) =>
                EmptyStateWidget(message: 'خطأ في تحميل الأحاديث المتشابهة'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    SimilarAhadith similarAhadith,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) => ConfirmationDialog(
        title: 'حذف الأحاديث المتشابهة',
        content: 'هل أنت متأكد من حذف هذه الأحاديث المتشابهة؟',
        onConfirm: () async {
          try {
            if (similarAhadith.id == null) {
              throw AppFailure.validation('معرّف الحديث المشابه غير موجود.');
            }

            final repo = ref.read(similarAhadithRepositoryProvider);
            await repo.deleteSimilarAhadith(similarAhadith.id!);

            ref.invalidate(adminSimilarAhadithsFutureProvider);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم حذف الأحاديث المتشابهة بنجاح')),
              );
            }
          } catch (e, st) {
            debugPrint("DELETE SIMILAR AHADITH ERROR: $e");
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

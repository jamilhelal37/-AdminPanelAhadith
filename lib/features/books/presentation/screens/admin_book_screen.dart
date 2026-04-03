import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';

import '../../../../core/presentation/widgets/confirmation_dialog.dart';
import '../../../../core/presentation/widgets/admin_pagination.dart';
import '../../../../core/presentation/widgets/empty_state_widget.dart';
import '../../../../core/presentation/widgets/search_field_widget.dart';

import '../../../muhaddiths/presentation/providers/muhaddith_future_provider.dart';
import '../../data/repositories/book_repository_provider.dart';
import '../../domain/models/book.dart';
import '../providers/admin_book_future_provider.dart';
import '../providers/search_provider.dart';
import '../widgets/admin_books_table.dart';
import '../widgets/book_dialog.dart';

class AdminBookScreen extends ConsumerStatefulWidget {
  const AdminBookScreen({super.key});

  @override
  ConsumerState<AdminBookScreen> createState() => _AdminBookScreenState();
}

class _AdminBookScreenState extends ConsumerState<AdminBookScreen> {
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

    final booksAsync = ref.watch(adminBooksFutureProvider);
    final muhaddithsAsync = ref.watch(adminMuhaddithFutureProvider);

    final muhaddithNameById = muhaddithsAsync.maybeWhen(
      data: (list) => {
        for (final m in list)
          if (m.id != null) m.id!: m.name,
      },
      orElse: () => <String, String>{},
    );

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
                    builder: (_) => BookDialog(
                      onSave: (book) async {
                        try {
                          final repo = ref.read(bookRepositoryProvider);
                          await repo.createBook(book);

                          ref.invalidate(adminBooksFutureProvider);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم إنشاء الكتاب بنجاح')),
                            );
                          }
                        } catch (e, st) {
                          debugPrint("CREATE BOOK ERROR: $e");
                          debugPrint("$st");
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                          rethrow; // ? ??? ??? BookDialog ?? ???? ??? ???
                        }
                      },
                    ),
                  );
                },
                label: Text('إنشاء كتاب'),
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: booksAsync.when(
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            data: (data) {
              if (data.isEmpty) return EmptyStateWidget();

              return AdminPaginatedDataView<Book>(
                items: data,
                stateKey: currentSearch.trim(),
                itemBuilder: (context, pageItems) => AdminBooksTable(
                  books: pageItems,
                  muhaddithNameById: muhaddithNameById,
                  onDelete: (b1) => _showDeleteConfirmationDialog(context, b1),
                  onEdit: (b1) {
                    showDialog(
                      context: context,
                      builder: (_) => BookDialog(
                        book: b1,
                        onSave: (book) async {
                          try {
                            final repo = ref.read(bookRepositoryProvider);
                            await repo.updateBook(book);

                            ref.invalidate(adminBooksFutureProvider);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('تم تحديث الكتاب بنجاح'),
                                ),
                              );
                            }
                          } catch (e, st) {
                            debugPrint("UPDATE BOOK ERROR: $e");
                            debugPrint("$st");
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                            rethrow; // ? ??? ??? BookDialog ?? ???? ??? ???
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            },
            error: (error, stackTrace) =>
                EmptyStateWidget(message: 'خطأ في تحميل الكتب'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'حذف الكتاب',
        content: 'هل أنت متأكد من حذف هذا الكتاب؟',
        onConfirm: () async {
          try {
            if (book.id == null) {
              throw AppFailure.validation('معرّف الكتاب غير موجود.');
            }

            final repo = ref.read(bookRepositoryProvider);
            await repo.deleteBook(book.id!);

            ref.invalidate(adminBooksFutureProvider);

            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('تم حذف الكتاب بنجاح')));
            }
          } catch (e, st) {
            debugPrint("DELETE BOOK ERROR: $e");
            debugPrint("$st");
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

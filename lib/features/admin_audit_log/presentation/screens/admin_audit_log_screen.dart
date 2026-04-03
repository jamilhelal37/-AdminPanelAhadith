import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/widgets/admin_pagination.dart';
import '../../../../core/presentation/widgets/empty_state_widget.dart';
import '../../../../core/presentation/widgets/search_field_widget.dart';
import '../../domain/models/admin_audit_log.dart';
import '../providers/admin_audit_log_providers.dart';
import '../widgets/admin_audit_log_table.dart';

class AdminAuditLogScreen extends ConsumerStatefulWidget {
  const AdminAuditLogScreen({super.key});

  @override
  ConsumerState<AdminAuditLogScreen> createState() =>
      _AdminAuditLogScreenState();
}

class _AdminAuditLogScreenState extends ConsumerState<AdminAuditLogScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(adminAuditLogFutureProvider);
    final currentSearch = ref.watch(adminAuditLogSearchProvider);
    final operationFilter = ref.watch(adminAuditLogOperationFilterProvider);
    final tableFilter = ref.watch(adminAuditLogTableFilterProvider);

    if (_searchController.text != currentSearch) {
      _searchController.value = _searchController.value.copyWith(
        text: currentSearch,
        selection: TextSelection.collapsed(offset: currentSearch.length),
      );
    }

    return Column(
      children: [
        Expanded(
          child: logsAsync.when(
            skipLoadingOnReload: true,
            skipLoadingOnRefresh: true,
            data: (logs) {
              final tableOptions =
                  logs
                      .map((entry) => entry.tableName)
                      .where((table) => table.trim().isNotEmpty)
                      .toSet()
                      .toList()
                    ..sort();
              final effectiveTableFilter =
                  tableFilter != null && tableOptions.contains(tableFilter)
                  ? tableFilter
                  : null;

              final filtered = _applyFilters(
                logs,
                search: currentSearch,
                operationFilter: operationFilter,
                tableFilter: effectiveTableFilter,
              );
              final paginationKey =
                  '${currentSearch.trim().toLowerCase()}|$operationFilter|${effectiveTableFilter ?? ''}';

              return Column(
                children: [
                  _FiltersBar(
                    searchController: _searchController,
                    operationFilter: operationFilter,
                    tableFilter: effectiveTableFilter,
                    tableOptions: tableOptions,
                    onSearchChanged: (value) {
                      ref.read(adminAuditLogSearchProvider.notifier).state =
                          value;
                    },
                    onOperationChanged: (value) {
                      if (value == null) return;
                      ref
                              .read(
                                adminAuditLogOperationFilterProvider.notifier,
                              )
                              .state =
                          value;
                    },
                    onTableChanged: (value) {
                      ref
                              .read(adminAuditLogTableFilterProvider.notifier)
                              .state =
                          value;
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: filtered.isEmpty
                        ? const EmptyStateWidget(
                            message: 'لا توجد نتائج مطابقة ضمن سجل النشاط.',
                          )
                        : AdminPaginatedDataView<AdminAuditLog>(
                            items: filtered,
                            stateKey: paginationKey,
                            itemBuilder: (context, pageItems) =>
                                AdminAuditLogTable(logs: pageItems),
                          ),
                  ),
                ],
              );
            },
            error: (error, _) =>
                Center(child: Text('تعذر تحميل سجل نشاط المشرفين:\n$error')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  List<AdminAuditLog> _applyFilters(
    List<AdminAuditLog> logs, {
    required String search,
    required String operationFilter,
    required String? tableFilter,
  }) {
    final query = search.trim().toLowerCase();

    return logs.where((entry) {
      if (operationFilter != 'الكل') {
        final op = entry.operation.toUpperCase();
        if (operationFilter == 'إضافة' && op != 'INSERT') return false;
        if (operationFilter == 'تحديث' && op != 'UPDATE') return false;
        if (operationFilter == 'حذف' && op != 'DELETE') return false;
      }

      if (tableFilter != null && tableFilter.trim().isNotEmpty) {
        if (entry.tableName != tableFilter) return false;
      }

      if (query.isEmpty) return true;

      final haystack = [
        entry.actorDisplay,
        entry.actorSubline,
        entry.tableName,
        entry.operationArabic,
        entry.shortRecordId,
        entry.detailsSummary,
        entry.createdAtShort,
      ].join(' ').toLowerCase();

      return haystack.contains(query);
    }).toList();
  }
}

class _FiltersBar extends StatelessWidget {
  const _FiltersBar({
    required this.searchController,
    required this.operationFilter,
    required this.tableFilter,
    required this.tableOptions,
    required this.onSearchChanged,
    required this.onOperationChanged,
    required this.onTableChanged,
  });

  final TextEditingController searchController;
  final String operationFilter;
  final String? tableFilter;
  final List<String> tableOptions;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onOperationChanged;
  final ValueChanged<String?> onTableChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      child: Row(
        children: [
          SizedBox(
            width: 170,
            child: DropdownButtonFormField<String>(
              initialValue: operationFilter,
              decoration: const InputDecoration(
                labelText: 'العملية',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: 'الكل', child: Text('الكل')),
                DropdownMenuItem(value: 'إضافة', child: Text('إضافة')),
                DropdownMenuItem(value: 'تحديث', child: Text('تحديث')),
                DropdownMenuItem(value: 'حذف', child: Text('حذف')),
              ],
              onChanged: onOperationChanged,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 220,
            child: DropdownButtonFormField<String?>(
              initialValue: tableFilter,
              decoration: const InputDecoration(
                labelText: 'الجدول',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('كل الجداول'),
                ),
                ...tableOptions.map(
                  (table) => DropdownMenuItem<String?>(
                    value: table,
                    child: Text(table),
                  ),
                ),
              ],
              onChanged: onTableChanged,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SearchFieldWidget(
              controller: searchController,
              compact: true,
              hintText: 'ابحث بالمشرف أو الجدول أو السجل أو تفاصيل العملية',
              onChanged: onSearchChanged,
            ),
          ),
        ],
      ),
    );
  }
}

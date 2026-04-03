import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/presentation/widgets/admin_pagination.dart';
import '../../../../core/presentation/widgets/search_field_widget.dart';

import '../providers/admin_users_provider.dart';
import '../screens/admin_user_detail_screen.dart';
import '../widgets/admin_users_table.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersProvider);
    final searchQuery = ref.watch(adminUsersSearchProvider);

    return usersAsync.when(
      data: (users) {
        final query = searchQuery.trim().toLowerCase();
        final filteredUsers = query.isEmpty
            ? users
            : users.where((user) {
                final name = (user.name ?? '').toLowerCase();
                final email = user.email.toLowerCase();
                return name.contains(query) || email.contains(query);
              }).toList();

        if (users.isEmpty) {
          return Center(child: Text('لا يوجد مستخدمون'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: SearchFieldWidget(
                onChanged: (value) {
                  ref.read(adminUsersSearchProvider.notifier).state = value;
                },
                hintText: 'ابحث بالاسم الكامل أو البريد الإلكتروني',
                compact: true,
              ),
            ),
            Expanded(
              child: filteredUsers.isEmpty
                  ? Center(child: Text('لا يوجد مستخدمون'))
                  : AdminPaginatedDataView(
                      items: filteredUsers,
                      stateKey: query,
                      itemBuilder: (context, pageItems) => AdminUsersTable(
                        users: pageItems,
                        onView: (user) async {
                          final result = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) => AdminUserDetailScreen(user: user),
                            ),
                          );
                          if (result == true) {
                            ref.invalidate(adminUsersProvider);
                          }
                        },
                      ),
                    ),
            ),
          ],
        );
      },
      error: (error, _) => Center(child: Text('خطأ: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

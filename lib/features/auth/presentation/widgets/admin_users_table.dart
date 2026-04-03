import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/presentation/widgets/admin_data_grid.dart';
import '../../domain/models/app_user.dart';

class AdminUsersTable extends StatelessWidget {
  const AdminUsersTable({super.key, required this.users, required this.onView});

  final List<AppUser> users;
  final void Function(AppUser user) onView;

  @override
  Widget build(BuildContext context) {
    final source = _AdminUsersGridSource(
      context: context,
      users: users,
      onView: onView,
    );

    return AdminDataGrid(
      source: source,
      rowHeight: 84,
      columnWidthMode: ColumnWidthMode.fill,
      columns: [
        GridColumn(
          columnName: 'user',
          minimumWidth: 280,
          label: const AdminGridHeaderCell('المستخدم'),
        ),
        GridColumn(
          columnName: 'gender',
          minimumWidth: 120,
          label: const AdminGridHeaderCell('الجنس'),
        ),
        GridColumn(
          columnName: 'status',
          minimumWidth: 150,
          label: const AdminGridHeaderCell('الحالة'),
        ),
        GridColumn(
          columnName: 'type',
          minimumWidth: 170,
          label: const AdminGridHeaderCell('النوع'),
        ),
        GridColumn(
          columnName: 'birthDate',
          minimumWidth: 140,
          label: const AdminGridHeaderCell('الميلاد'),
        ),
        GridColumn(
          columnName: 'createdAt',
          minimumWidth: 170,
          label: const AdminGridHeaderCell('تاريخ الإنشاء'),
        ),
        GridColumn(
          columnName: 'actions',
          minimumWidth: 140,
          label: const AdminGridHeaderCell('الإجراءات'),
        ),
      ],
    );
  }
}

class _AdminUsersGridSource extends DataGridSource {
  _AdminUsersGridSource({
    required this.context,
    required this.users,
    required this.onView,
  }) : _rows = users
           .map(
             (user) => DataGridRow(
               cells: [
                 DataGridCell<String>(columnName: 'user', value: user.email),
                 DataGridCell<String>(
                   columnName: 'gender',
                   value: _genderLabel(user.gender),
                 ),
                 DataGridCell<bool>(
                   columnName: 'status',
                   value: user.isActivated,
                 ),
                 DataGridCell<String>(
                   columnName: 'type',
                   value: _typeLabel(user.type),
                 ),
                 DataGridCell<String>(
                   columnName: 'birthDate',
                   value: _shortDate(user.birthDate),
                 ),
                 DataGridCell<String>(
                   columnName: 'createdAt',
                   value: _shortDateTime(user.createdAt),
                 ),
                 const DataGridCell<String>(columnName: 'actions', value: ''),
               ],
             ),
           )
           .toList();

  final BuildContext context;
  final List<AppUser> users;
  final void Function(AppUser user) onView;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final cs = Theme.of(context).colorScheme;
    final index = _rows.indexOf(row);
    final user = users[index];

    return DataGridRowAdapter(
      color: index.isEven ? cs.surface : cs.surface.withValues(alpha: 0.52),
      cells: [
        AdminGridCell(child: _UserCell(user: user)),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridText(_genderLabel(user.gender)),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridBadge(
            label: user.isActivated ? 'نشط' : 'غير نشط',
            backgroundColor: user.isActivated
                ? const Color(0xFFDFF5E8)
                : const Color(0xFFFFE4DE),
            foregroundColor: user.isActivated
                ? const Color(0xFF1E8E5A)
                : const Color(0xFFB3472F),
          ),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: _UserTypeBadge(type: user.type),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridText(_shortDate(user.birthDate)),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridText(_shortDateTime(user.createdAt)),
        ),
        AdminGridCell(
          alignment: Alignment.center,
          child: AdminGridActionButton(
            label: 'التفاصيل',
            icon: Icons.open_in_new_rounded,
            onPressed: () => onView(user),
          ),
        ),
      ],
    );
  }

  static String _shortDate(String? value) {
    if (value == null || value.isEmpty) return '-';
    return value.length >= 10 ? value.substring(0, 10) : value;
  }

  static String _shortDateTime(String value) {
    if (value.isEmpty) return '-';
    return value.length >= 16
        ? value.substring(0, 16).replaceFirst('T', ' ')
        : value;
  }

  static String _genderLabel(Gender? gender) {
    switch (gender) {
      case Gender.male:
        return 'ذكر';
      case Gender.female:
        return 'أنثى';
      case null:
        return '-';
    }
  }

  static String _typeLabel(UserType? type) {
    switch (type) {
      case UserType.admin:
        return 'مدير';
      case UserType.scholar:
        return 'عالم';
      case UserType.member:
        return 'عضو';
      case null:
        return '-';
    }
  }
}

class _UserTypeBadge extends StatelessWidget {
  const _UserTypeBadge({required this.type});

  final UserType? type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    late final String label;
    late final IconData icon;
    late final Color backgroundColor;
    late final Color foregroundColor;

    switch (type) {
      case UserType.admin:
        label = 'مدير';
        icon = Icons.admin_panel_settings_outlined;
        backgroundColor = const Color(0xFFFFE9CC);
        foregroundColor = const Color(0xFFB7791F);
        break;
      case UserType.scholar:
        label = 'عالم';
        icon = Icons.school_outlined;
        backgroundColor = const Color(0xFFE4EEFF);
        foregroundColor = const Color(0xFF2F6FDB);
        break;
      case UserType.member:
        label = 'عضو';
        icon = Icons.person_outline_rounded;
        backgroundColor = const Color(0xFFE9F7EF);
        foregroundColor = const Color(0xFF1E8E5A);
        break;
      case null:
        label = '-';
        icon = Icons.help_outline_rounded;
        backgroundColor = cs.surfaceContainerHighest;
        foregroundColor = cs.onSurfaceVariant;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: foregroundColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCell extends StatelessWidget {
  const _UserCell({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        _AvatarThumb(user: user),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.name?.trim().isNotEmpty == true ? user.name! : 'بدون اسم',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 3),
              AdminGridSubText(
                user.email,
                maxLines: 1,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvatarThumb extends StatelessWidget {
  const _AvatarThumb({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final url = user.avatarUrl;
    if (url == null || url.trim().isEmpty) {
      return const CircleAvatar(
        radius: 18,
        child: Icon(Icons.person, size: 18),
      );
    }

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            return Dialog(
              child: InteractiveViewer(
                maxScale: 4,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 700,
                    maxHeight: 700,
                  ),
                  child: Image.network(url, fit: BoxFit.contain),
                ),
              ),
            );
          },
        );
      },
      child: CircleAvatar(radius: 18, backgroundImage: NetworkImage(url)),
    );
  }
}

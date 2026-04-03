import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/app_user.dart';
import '../providers/admin_users_provider.dart';

class AdminUserDetailScreen extends ConsumerStatefulWidget {
  const AdminUserDetailScreen({super.key, required this.user});

  final AppUser user;

  @override
  ConsumerState<AdminUserDetailScreen> createState() =>
      _AdminUserDetailScreenState();
}

class _AdminUserDetailScreenState extends ConsumerState<AdminUserDetailScreen> {
  late UserType selectedType;
  late bool isActivated;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    selectedType = widget.user.type ?? UserType.member;
    isActivated = widget.user.isActivated;
  }

  Future<void> _saveChanges() async {
    final userId = widget.user.id;
    if (userId == null || userId.isEmpty) return;

    setState(() {
      isSaving = true;
    });

    try {
      await ref.read(
        updateAdminUserProvider(
          AdminUserUpdateParams(
            id: userId,
            type: selectedType,
            isActivated: isActivated,
          ),
        ).future,
      );

      if (!mounted) return;
      ref.invalidate(adminUsersProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث المستخدم بنجاح')),
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final displayName = _displayName(widget.user);
    final fullName = _fullName(widget.user);
    final birthDate = _readableValue(widget.user.birthDate);
    final updatedAt = widget.user.updatedAt == null
        ? 'لا يوجد'
        : _formatDateTime(widget.user.updatedAt!);

    return Scaffold(
      backgroundColor: Color.alphaBlend(
        cs.primary.withValues(alpha: 0.025),
        theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktopLayout =
                constraints.maxWidth >= 1180 && constraints.maxHeight >= 720;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktopLayout ? 1360 : 900,
                ),
                child: isDesktopLayout
                    ? _DesktopUserWorkspace(
                        user: widget.user,
                        displayName: displayName,
                        fullName: fullName,
                        birthDate: birthDate,
                        updatedAt: updatedAt,
                        selectedType: selectedType,
                        isActivated: isActivated,
                        isSaving: isSaving,
                        viewportWidth: constraints.maxWidth,
                        onTypeChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            selectedType = value;
                          });
                        },
                        onActivationChanged: (value) {
                          setState(() {
                            isActivated = value;
                          });
                        },
                        onCancel: () => Navigator.of(context).pop(),
                        onSave: _saveChanges,
                      )
                    : _CompactUserWorkspace(
                        user: widget.user,
                        displayName: displayName,
                        fullName: fullName,
                        birthDate: birthDate,
                        updatedAt: updatedAt,
                        selectedType: selectedType,
                        isActivated: isActivated,
                        isSaving: isSaving,
                        maxWidth: constraints.maxWidth,
                        onTypeChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            selectedType = value;
                          });
                        },
                        onActivationChanged: (value) {
                          setState(() {
                            isActivated = value;
                          });
                        },
                        onCancel: () => Navigator.of(context).pop(),
                        onSave: _saveChanges,
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DesktopUserWorkspace extends StatelessWidget {
  const _DesktopUserWorkspace({
    required this.user,
    required this.displayName,
    required this.fullName,
    required this.birthDate,
    required this.updatedAt,
    required this.selectedType,
    required this.isActivated,
    required this.isSaving,
    required this.viewportWidth,
    required this.onTypeChanged,
    required this.onActivationChanged,
    required this.onCancel,
    required this.onSave,
  });

  final AppUser user;
  final String displayName;
  final String fullName;
  final String birthDate;
  final String updatedAt;
  final UserType selectedType;
  final bool isActivated;
  final bool isSaving;
  final double viewportWidth;
  final ValueChanged<UserType?> onTypeChanged;
  final ValueChanged<bool> onActivationChanged;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final detailsColumns = viewportWidth >= 1280 ? 3 : 2;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _UserSummaryPanel(
            user: user,
            displayName: displayName,
            compact: true,
          ),
          const SizedBox(height: 16),
          _AdminControlsPanel(
            selectedType: selectedType,
            isActivated: isActivated,
            isSaving: isSaving,
            compact: true,
            onTypeChanged: onTypeChanged,
            onActivationChanged: onActivationChanged,
            onCancel: onCancel,
            onSave: onSave,
          ),
          const SizedBox(height: 16),
          _AccountDetailsPanel(
            user: user,
            fullName: fullName,
            birthDate: birthDate,
            updatedAt: updatedAt,
            compact: true,
            preferredColumns: detailsColumns,
          ),
        ],
      ),
    );
  }
}

class _CompactUserWorkspace extends StatelessWidget {
  const _CompactUserWorkspace({
    required this.user,
    required this.displayName,
    required this.fullName,
    required this.birthDate,
    required this.updatedAt,
    required this.selectedType,
    required this.isActivated,
    required this.isSaving,
    required this.maxWidth,
    required this.onTypeChanged,
    required this.onActivationChanged,
    required this.onCancel,
    required this.onSave,
  });

  final AppUser user;
  final String displayName;
  final String fullName;
  final String birthDate;
  final String updatedAt;
  final UserType selectedType;
  final bool isActivated;
  final bool isSaving;
  final double maxWidth;
  final ValueChanged<UserType?> onTypeChanged;
  final ValueChanged<bool> onActivationChanged;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _UserSummaryPanel(
            user: user,
            displayName: displayName,
          ),
          const SizedBox(height: 16),
          _AdminControlsPanel(
            selectedType: selectedType,
            isActivated: isActivated,
            isSaving: isSaving,
            onTypeChanged: onTypeChanged,
            onActivationChanged: onActivationChanged,
            onCancel: onCancel,
            onSave: onSave,
          ),
          const SizedBox(height: 16),
          _AccountDetailsPanel(
            user: user,
            fullName: fullName,
            birthDate: birthDate,
            updatedAt: updatedAt,
            forceSingleColumn: maxWidth < 720,
          ),
        ],
      ),
    );
  }
}

class _UserSummaryPanel extends StatelessWidget {
  const _UserSummaryPanel({
    required this.user,
    required this.displayName,
    this.compact = false,
  });

  final AppUser user;
  final String displayName;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return _AdminSurfaceCard(
      compact: compact,
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color.alphaBlend(cs.primary.withValues(alpha: 0.1), cs.surface),
          Color.alphaBlend(
            cs.primaryContainer.withValues(alpha: 0.4),
            cs.surface,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                        fontSize: compact ? 28 : null,
                      ),
                    ),
                    SizedBox(height: compact ? 6 : 8),
                    Text(
                      user.email,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontSize: compact ? 16 : null,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: compact ? 14 : 18),
              _UserAvatar(url: user.avatarUrl, compact: compact),
            ],
          ),
          SizedBox(height: compact ? 6 : 8),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.url, this.compact = false});

  final String? url;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasImage = url != null && url!.trim().isNotEmpty;
    final size = compact ? 88.0 : 106.0;
    final iconSize = compact ? 38.0 : 44.0;

    final avatar = Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.8),
        shape: BoxShape.circle,
        border: Border.all(color: cs.surface, width: 3),
      ),
      child: CircleAvatar(
        backgroundColor: cs.primaryContainer,
        backgroundImage: hasImage ? NetworkImage(url!.trim()) : null,
        child: hasImage
            ? null
            : Icon(Icons.person_rounded, size: iconSize, color: cs.primary),
      ),
    );

    if (!hasImage) {
      return avatar;
    }

    return InkWell(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (_) => Dialog(
            child: InteractiveViewer(
              maxScale: 4,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 700,
                  maxHeight: 700,
                ),
                child: Image.network(url!.trim(), fit: BoxFit.contain),
              ),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(999),
      child: avatar,
    );
  }
}

class _AdminControlsPanel extends StatelessWidget {
  const _AdminControlsPanel({
    required this.selectedType,
    required this.isActivated,
    required this.isSaving,
    required this.onTypeChanged,
    required this.onActivationChanged,
    required this.onCancel,
    required this.onSave,
    this.compact = false,
  });

  final UserType selectedType;
  final bool isActivated;
  final bool isSaving;
  final ValueChanged<UserType?> onTypeChanged;
  final ValueChanged<bool> onActivationChanged;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final typeField = _LabeledField(
      label: 'نوع المستخدم',
      compact: compact,
      child: DropdownButtonFormField<UserType>(
        initialValue: selectedType,
        items: UserType.values
            .map(
              (type) => DropdownMenuItem<UserType>(
                value: type,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_typeIcon(type), size: 18, color: cs.primary),
                    const SizedBox(width: 8),
                    Text(_typeLabel(type)),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: isSaving ? null : onTypeChanged,
        decoration: _fieldDecoration(context, compact: compact),
      ),
    );

    final activationField = _LabeledField(
      label: 'حالة الحساب',
      compact: compact,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 14 : 16,
          vertical: compact ? 12 : 14,
        ),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(compact ? 16 : 18),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.38)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isActivated ? 'الحساب مفعل' : 'الحساب غير مفعل',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isActivated
                        ? 'يمكن للمستخدم الدخول واستخدام الحساب بشكل طبيعي.'
                        : 'سيبقى الحساب معطلًا حتى يتم تفعيله من الإدارة.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Switch(
              value: isActivated,
              onChanged: isSaving ? null : onActivationChanged,
            ),
          ],
        ),
      ),
    );

    return _AdminSurfaceCard(
      compact: compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'إعدادات الإدارة',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: compact ? 14 : 18),
          if (compact)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: typeField),
                const SizedBox(width: 12),
                Expanded(child: activationField),
              ],
            )
          else ...[
            typeField,
            const SizedBox(height: 16),
            activationField,
          ],
          SizedBox(height: compact ? 16 : 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton(
                  onPressed: isSaving ? null : onCancel,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(120, compact ? 42 : 44),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                  child: const Text('إلغاء'),
                ),
                FilledButton.icon(
                  onPressed: isSaving ? null : onSave,
                  style: FilledButton.styleFrom(
                    minimumSize: Size(150, compact ? 42 : 44),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                  icon: isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    isSaving ? 'جارٍ الحفظ...' : 'حفظ التغييرات',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountDetailsPanel extends StatelessWidget {
  const _AccountDetailsPanel({
    required this.user,
    required this.fullName,
    required this.birthDate,
    required this.updatedAt,
    this.forceSingleColumn = false,
    this.preferredColumns,
    this.compact = false,
  });

  final AppUser user;
  final String fullName;
  final String birthDate;
  final String updatedAt;
  final bool forceSingleColumn;
  final int? preferredColumns;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final items = [
      _InfoItem(
        label: 'البريد الإلكتروني',
        value: user.email,
        icon: Icons.alternate_email_rounded,
      ),
      _InfoItem(
        label: 'الاسم الكامل',
        value: fullName,
        icon: Icons.badge_outlined,
      ),
      _InfoItem(
        label: 'الجنس',
        value: _genderLabel(user.gender),
        icon: Icons.wc_rounded,
      ),
      _InfoItem(
        label: 'تاريخ الميلاد',
        value: birthDate,
        icon: Icons.cake_outlined,
      ),
      _InfoItem(
        label: 'تاريخ الإنشاء',
        value: _formatDateTime(user.createdAt),
        icon: Icons.event_available_outlined,
      ),
      _InfoItem(
        label: 'آخر تحديث',
        value: updatedAt,
        icon: Icons.update_rounded,
      ),
    ];

    return _AdminSurfaceCard(
      compact: compact,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = forceSingleColumn
              ? 1
              : preferredColumns ??
                    (constraints.maxWidth >= 1180
                        ? 3
                        : constraints.maxWidth >= 760
                        ? 2
                        : 1);
          const spacing = 12.0;
          final itemWidth = columns == 1
              ? constraints.maxWidth
              : (constraints.maxWidth - (spacing * (columns - 1))) / columns;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'بيانات المستخدم',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                  fontSize: compact ? 30 : null,
                ),
              ),
              SizedBox(height: compact ? 14 : 18),
              Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: items
                    .map(
                      (item) => SizedBox(
                        width: itemWidth,
                        child: _InfoField(item: item, compact: compact),
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AdminSurfaceCard extends StatelessWidget {
  const _AdminSurfaceCard({
    required this.child,
    this.compact = false,
    this.gradient,
  });

  final Widget child;
  final bool compact;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 18 : 24),
      decoration: BoxDecoration(
        color: gradient == null ? cs.surface : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(compact ? 24 : 30),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.28)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.child,
    this.compact = false,
  });

  final String label;
  final Widget child;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 4),
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        child,
      ],
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({required this.item, this.compact = false});

  final _InfoItem item;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(compact ? 14 : 18),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(compact ? 18 : 22),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w800,
                    fontSize: compact ? 13 : null,
                  ),
                ),
              ),
              Container(
                width: compact ? 34 : 38,
                height: compact ? 34 : 38,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(compact ? 11 : 13),
                ),
                child: Icon(
                  item.icon,
                  size: compact ? 17 : 19,
                  color: cs.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 12 : 16),
          Text(
            item.value,
            maxLines: compact ? 3 : 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
              fontSize: compact ? 18 : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  const _InfoItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

InputDecoration _fieldDecoration(BuildContext context, {bool compact = false}) {
  final cs = Theme.of(context).colorScheme;

  OutlineInputBorder border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(compact ? 16 : 18),
      borderSide: BorderSide(color: color),
    );
  }

  return InputDecoration(
    filled: true,
    fillColor: cs.surfaceContainerLowest,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16,
      vertical: compact ? 14 : 18,
    ),
    border: border(cs.outlineVariant.withValues(alpha: 0.38)),
    enabledBorder: border(cs.outlineVariant.withValues(alpha: 0.38)),
    focusedBorder: border(cs.primary.withValues(alpha: 0.55)),
  );
}

String _displayName(AppUser user) {
  final name = user.name?.trim() ?? '';
  return name.isEmpty ? user.email : name;
}

String _fullName(AppUser user) {
  final name = user.name?.trim() ?? '';
  return name.isEmpty ? '-' : name;
}

String _readableValue(String? value) {
  final normalized = value?.trim() ?? '';
  return normalized.isEmpty ? '-' : normalized;
}

String _genderLabel(Gender? gender) {
  switch (gender) {
    case Gender.male:
      return 'ذكر';
    case Gender.female:
      return 'أنثى';
    case null:
      return '-';
  }
}

String _typeLabel(UserType type) {
  switch (type) {
    case UserType.admin:
      return 'مدير';
    case UserType.member:
      return 'عضو';
    case UserType.scholar:
      return 'عالم';
  }
}

IconData _typeIcon(UserType type) {
  switch (type) {
    case UserType.admin:
      return Icons.admin_panel_settings_outlined;
    case UserType.member:
      return Icons.person_outline_rounded;
    case UserType.scholar:
      return Icons.school_outlined;
  }
}

String _formatDateTime(String value) {
  if (value.isEmpty) return '-';
  return value.length >= 16
      ? value.substring(0, 16).replaceFirst('T', ' ')
      : value;
}

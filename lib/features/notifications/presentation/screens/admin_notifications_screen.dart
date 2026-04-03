import 'package:ahadith/core/errors/app_failure.dart';
import 'package:ahadith/features/auth/domain/models/app_user.dart';
import 'package:ahadith/features/auth/presentation/providers/admin_users_provider.dart';
import 'package:ahadith/features/notifications/data/repositories/admin_notifications_repository_provider.dart';
import 'package:ahadith/features/notifications/presentation/widgets/admin_notifications_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminNotificationsScreen extends ConsumerStatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  ConsumerState<AdminNotificationsScreen> createState() =>
      _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState
    extends ConsumerState<AdminNotificationsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _userSearchController = TextEditingController();

  bool _isToAllUsers = true;
  bool _isSending = false;
  AppUser? _selectedUser;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _userSearchController.dispose();
    super.dispose();
  }

  Future<void> _sendNotification() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() {
      _isSending = true;
    });

    try {
      final repo = ref.read(adminNotificationsRepositoryProvider);
      await repo.sendPush(
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        userId: _isToAllUsers ? null : _selectedUser?.id?.trim(),
      );

      if (!mounted) return;

      _titleController.clear();
      _bodyController.clear();
      _userSearchController.clear();
      setState(() {
        _isToAllUsers = true;
        _selectedUser = null;
      });
      _showMessage('تم إرسال الإشعار بنجاح');
    } on AppFailure catch (error) {
      if (!mounted) return;
      _showMessage(error.message, isError: true);
    } catch (_) {
      if (!mounted) return;
      _showMessage('تعذر إرسال الإشعار', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text(message, textAlign: TextAlign.start)),
      );
  }

  void _clearSelectedUser({bool clearSearch = true}) {
    _selectedUser = null;
    if (clearSearch) {
      _userSearchController.clear();
    }
  }

  void _handleAudienceChanged(bool value) {
    setState(() {
      _isToAllUsers = value;
      if (value) {
        _clearSelectedUser();
      }
    });
  }

  String _userDisplayLabel(AppUser user) {
    final name = user.name?.trim();
    final email = user.email.trim();
    if (name != null && name.isNotEmpty) {
      return '$name • $email';
    }
    return email;
  }

  Widget _buildTargetUserSection(
    BuildContext context,
    AsyncValue<List<AppUser>> usersAsync,
  ) {
    final cs = Theme.of(context).colorScheme;

    return usersAsync.when(
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _userSearchController,
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'المستخدم المستهدف',
              hintText: 'جارِ تحميل قائمة المستخدمين...',
            ),
          ),
          const SizedBox(height: 14),
          const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            ),
          ),
        ],
      ),
      error: (error, stackTrace) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            enabled: false,
            decoration: InputDecoration(
              labelText: 'المستخدم المستهدف',
              hintText: 'تعذر تحميل قائمة المستخدمين',
            ),
          ),
          SizedBox(height: 10),
          AdminNotificationInfoBanner(
            icon: Icons.error_outline_rounded,
            text: 'تعذر تحميل المستخدمين الآن. حدّث الصفحة ثم حاول مرة أخرى.',
          ),
        ],
      ),
      data: (users) {
        if (users.isEmpty) {
          return const AdminNotificationInfoBanner(
            icon: Icons.person_off_outlined,
            text: 'لا توجد حسابات متاحة للاختيار حاليًا.',
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Autocomplete<AppUser>(
              displayStringForOption: _userDisplayLabel,
              optionsBuilder: (textEditingValue) {
                final query = textEditingValue.text.trim().toLowerCase();
                if (query.isEmpty) {
                  return users.take(8);
                }

                return users
                    .where((user) {
                      final name = user.name?.toLowerCase() ?? '';
                      final email = user.email.toLowerCase();
                      return name.contains(query) || email.contains(query);
                    })
                    .take(8);
              },
              onSelected: (user) {
                setState(() {
                  _selectedUser = user;
                  _userSearchController.text = _userDisplayLabel(user);
                });
              },
              fieldViewBuilder:
                  (
                    context,
                    textEditingController,
                    focusNode,
                    onFieldSubmitted,
                  ) {
                    if (textEditingController.text !=
                        _userSearchController.text) {
                      textEditingController.value = _userSearchController.value;
                    }

                    return TextFormField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'اختر المستخدم',
                        hintText: 'ابحث بالاسم أو البريد الإلكتروني',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: textEditingController.text.trim().isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  textEditingController.clear();
                                  _userSearchController.clear();
                                  setState(() {
                                    _selectedUser = null;
                                  });
                                },
                                icon: const Icon(Icons.close_rounded),
                                tooltip: 'مسح الاختيار',
                              ),
                      ),
                      onFieldSubmitted: (submittedValue) => onFieldSubmitted(),
                      onChanged: (value) {
                        _userSearchController.value =
                            textEditingController.value;

                        final selectedUser = _selectedUser;
                        if (selectedUser == null) return;

                        if (value.trim() != _userDisplayLabel(selectedUser)) {
                          setState(() {
                            _clearSelectedUser(clearSearch: false);
                          });
                        }
                      },
                      validator: (value) {
                        if (_isToAllUsers) return null;
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى اختيار مستخدم من القائمة';
                        }
                        if (_selectedUser == null ||
                            _selectedUser?.id == null) {
                          return 'اختر مستخدمًا صالحًا من القائمة المقترحة';
                        }
                        return null;
                      },
                    );
                  },
              optionsViewBuilder: (context, onSelected, options) {
                final optionsList = options.toList();

                return Align(
                  alignment: Alignment.topRight,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      constraints: const BoxConstraints(
                        maxWidth: 640,
                        maxHeight: 320,
                      ),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: cs.outlineVariant.withValues(alpha: 0.45),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: cs.shadow.withValues(alpha: 0.12),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(8),
                        shrinkWrap: true,
                        itemCount: optionsList.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: cs.outlineVariant.withValues(alpha: 0.25),
                        ),
                        itemBuilder: (context, index) {
                          final user = optionsList[index];
                          final name = user.name?.trim();
                          final subtitle = [user.email].join('  •  ');

                          return ListTile(
                            dense: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: cs.primary.withValues(
                                alpha: 0.12,
                              ),
                              foregroundColor: cs.primary,
                              child: Icon(
                                Icons.person_outline_rounded,
                                color: cs.primary,
                              ),
                            ),
                            title: Text(
                              (name != null && name.isNotEmpty)
                                  ? name
                                  : user.email,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: cs.onSurface,
                                  ),
                            ),
                            subtitle: Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: cs.onSurfaceVariant),
                            ),
                            trailing: Icon(
                              Icons.arrow_outward_rounded,
                              color: cs.primary,
                              size: 18,
                            ),
                            onTap: () => onSelected(user),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersProvider);
    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 960;

          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            children: [
             
              _buildComposerCard(context, isWide, usersAsync),
            ],
          );
        },
      ),
    );
  }

  Widget _buildComposerCard(
    BuildContext context,
    bool isWide,
    AsyncValue<List<AppUser>> usersAsync,
  ) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 22 : 16,
        vertical: isWide ? 20 : 16,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.32)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 18 : 14,
                vertical: isWide ? 16 : 14,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.alphaBlend(
                      cs.primary.withValues(alpha: 0.05),
                      cs.surface,
                    ),
                    cs.surfaceContainerLowest,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.22),
                ),
              ),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'إرسال إشعار فوري',
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        _AudienceModeChip(isToAllUsers: _isToAllUsers),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إرسال إشعار فوري',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _AudienceModeChip(isToAllUsers: _isToAllUsers),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            */
            AdminNotificationAudienceToggle(
              isToAllUsers: _isToAllUsers,
              onChanged: _handleAudienceChanged,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'العنوان',
                hintText: 'مثال: تحديث جديد في التطبيق',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال عنوان الإشعار';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bodyController,
              minLines: 4,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'المحتوى',
                hintText: 'اكتب الرسالة التي ستظهر داخل الإشعار',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال محتوى الإشعار';
                }
                return null;
              },
            ),
            if (!_isToAllUsers) ...[
              const SizedBox(height: 12),
              _buildTargetUserSection(context, usersAsync),
            ],
            const SizedBox(height: 16),
            AdminNotificationInfoBanner(
              icon: _isToAllUsers
                  ? Icons.groups_rounded
                  : Icons.person_pin_circle_outlined,
              text: _isToAllUsers
                  ? 'سيتم إرسال الإشعار إلى جميع المستخدمين    .'
                  : 'سيتم إرسال الإشعار فقط إلى المستخدم الذي تختاره من القائمة.',
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                  onPressed: _isSending ? null : _sendNotification,
                  icon: _isSending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(
                    _isSending ? 'جارٍ إرسال الإشعار...' : 'إرسال الإشعار',
                  ),
                style: FilledButton.styleFrom(
                  backgroundColor: Color.alphaBlend(
                    cs.primary.withValues(alpha: 0.14),
                    cs.primaryContainer,
                  ),
                  foregroundColor: cs.onPrimaryContainer,
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
class _AudienceModeChip extends StatelessWidget {
  const _AudienceModeChip({required this.isToAllUsers});

  final bool isToAllUsers;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_active, color: cs.primary, size: 18),
          const SizedBox(width: 8),
          Text(
            isToAllUsers ? 'إرسال جماعي' : 'إرسال مخصص',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:ahadith/core/presentation/widgets/core_actions_widget.dart';
import 'package:flutter/material.dart';
import 'package:ahadith/core/presentation/widgets/golden_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/supabase_auth_repository.dart';
import '../../domain/models/app_user.dart';
import '../providers/auth_notifier_provider.dart';

final appUserFutureProvider = FutureProvider.autoDispose((ref) async {
  ref.watch(authNotifierProvider);

  final authUser = Supabase.instance.client.auth.currentUser;
  if (authUser == null) return null;

  final repo = ref.read(authRepositoryProvider);
  return repo.getAppUser();
});

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final FormGroup _form = FormGroup({
    'name': FormControl<String>(),
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'avatarUrl': FormControl<String>(),
    'gender': FormControl<String>(),
    'type': FormControl<String>(),
    'birthDate': FormControl<String>(),
  });

  String? _lastSyncedProfileFingerprint;
  bool _isUploadingAvatar = false;
  bool _isDeletingAvatar = false;
  bool _isSavingProfile = false;
  final ImagePicker _imagePicker = ImagePicker();

  String _buildProfileFingerprint(AppUser appUser) {
    return [
      appUser.id,
      appUser.updatedAt,
      appUser.name,
      appUser.email,
      appUser.avatarUrl,
      appUser.gender?.name,
      appUser.type?.name,
      appUser.birthDate,
    ].join('|');
  }

  void _syncFormFromAppUser(AppUser appUser) {
    final fingerprint = _buildProfileFingerprint(appUser);
    final shouldSync =
        _lastSyncedProfileFingerprint != fingerprint && !_form.dirty;

    if (!shouldSync) return;

    _form.patchValue({
      'name': appUser.name ?? '',
      'email': appUser.email,
      'avatarUrl': appUser.avatarUrl ?? '',
      'gender': appUser.gender?.name,
      'type': appUser.type?.name ?? 'member',
      'birthDate': appUser.birthDate ?? '',
    });

    _form.markAsPristine();
    _lastSyncedProfileFingerprint = fingerprint;
  }

  @override
  Widget build(BuildContext context) {
    final appUserAsync = ref.watch(appUserFutureProvider);
    final profileBody = Directionality(
      textDirection: TextDirection.rtl,
      child: appUserAsync.when(
        data: (appUser) {
          if (appUser == null) {
            return _buildLoadError(
              context,
              message:
                  'تعذر تحميل الملف الشخصي',
            );
          }

          _syncFormFromAppUser(appUser);

          return ReactiveForm(
            formGroup: _form,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfileCard(context, appUser),
                  const SizedBox(height: 16),
                  _buildSaveButton(context),
                ],
              ),
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        error: (error, stackTrace) => _buildLoadError(
          context,
          message:
              'خطأ في تحميل الملف الشخصي',
        ),
      ),
    );

    if (widget.embedded) {
      return profileBody;
    }

    return Scaffold(
      endDrawer: const GoldenAppDrawer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: const [CoreActionsWidget()],
        title: Text('ملفي الشخصي'),
        centerTitle: true,
      ),
      body: profileBody,
    );
  }

  Widget _buildProfileCard(BuildContext context, AppUser appUser) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.badge_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'بيانات الملف الشخصي :',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Center(
            child: ReactiveValueListenableBuilder<String>(
              formControlName: 'avatarUrl',
              builder: (context, control, child) {
                final url = (control.value ?? '').trim();

                return Container(
                  width: 106,
                  height: 106,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.18),
                    ),
                    color: colorScheme.surface.withValues(alpha: 0.8),
                  ),
                  child: CircleAvatar(
                    backgroundColor: colorScheme.primary.withValues(
                      alpha: 0.12,
                    ),
                    backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
                    child: url.isEmpty
                        ? Icon(
                            Icons.person_rounded,
                            color: colorScheme.primary,
                            size: 46,
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          Text(
            appUser.email,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 16),
          _buildAvatarActions(context),
          const SizedBox(height: 18),
          ReactiveTextField<String>(
            formControlName: 'name',
            textDirection: TextDirection.rtl,
            decoration: _fieldDecoration(
              context,
              label: 'الاسم الكامل',
              icon: Icons.person_outline_rounded,
            ),
          ),
          const SizedBox(height: 14),
          ReactiveDropdownField<String>(
            formControlName: 'gender',
            decoration: _fieldDecoration(
              context,
              label: 'الجنس',
              icon: Icons.wc_outlined,
            ),
            borderRadius: BorderRadius.circular(14.0),
            dropdownColor: colorScheme.surface,
            items: const [
              DropdownMenuItem(value: 'male', child: Text('ذكر')),
              DropdownMenuItem(
                value: 'female',
                child: Text('أنثى'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ReactiveTextField<String>(
            formControlName: 'birthDate',
            textDirection: TextDirection.ltr,
            readOnly: true,
            onTap: (_) => _pickBirthDate(),
            decoration:
                _fieldDecoration(
                  context,
                  label: 'تاريخ الميلاد',
                  icon: Icons.calendar_today_outlined,
                ).copyWith(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.date_range_outlined),
                    onPressed: _pickBirthDate,
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarActions(BuildContext context) {
    return ReactiveValueListenableBuilder<String>(
      formControlName: 'avatarUrl',
      builder: (context, control, child) {
        final hasAvatar = (control.value ?? '').trim().isNotEmpty;

        return Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                label: 'تعيين الصورة',
                icon: Icons.add_photo_alternate_rounded,
                onTap: (_isUploadingAvatar || _isDeletingAvatar)
                    ? null
                    : _pickAndUploadAvatar,
                isLoading: _isUploadingAvatar,
                expand: true,
              ),
            ),
            if (hasAvatar) ...[
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionButton(
                  context,
                  label: 'إزالة الصورة',
                  icon: Icons.delete_outline_rounded,
                  onTap: (_isUploadingAvatar || _isDeletingAvatar)
                      ? null
                      : _removeAvatar,
                  isLoading: _isDeletingAvatar,
                  expand: true,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Center(
      child: _buildActionButton(
        context,
        label: 'حفظ التغييرات',
        icon: Icons.save_outlined,
        onTap: _isSavingProfile ? null : _saveProfile,
        isLoading: _isSavingProfile,
        expand: true,
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback? onTap,
    bool isLoading = false,
    bool expand = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final buttonChild = Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: colorScheme.primary.withValues(alpha: 0.12),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.primary,
              ),
            )
          else
            Icon(icon, color: colorScheme.primary, size: 22),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );

    final content = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: buttonChild,
      ),
    );

    if (expand) {
      return SizedBox(width: double.infinity, child: content);
    }

    return content;
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    required String label,
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.24),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.0),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.3),
      ),
    );
  }

  Widget _buildLoadError(BuildContext context, {required String message}) {
    return Center(
      child: Text(
        message,
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }

  Future<void> _pickAndUploadAvatar() async {
    final file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
    );

    if (file == null) return;

    setState(() => _isUploadingAvatar = true);
    try {
      final bytes = await file.readAsBytes();
      final extension = file.name.contains('.')
          ? file.name.split('.').last
          : 'jpg';

      await ref
          .read(authNotifierProvider.notifier)
          .uploadAvatar(
            bytes: bytes,
            fileExtension: extension,
            onSuccess: (publicUrl) {
              _form.control('avatarUrl').value = publicUrl;
              ref.invalidate(appUserFutureProvider);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم رفع الصورة الشخصية بنجاح',
                  ),
                ),
              );
            },
            onError: (message) {
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
          );
    } finally {
      if (mounted) {
        setState(() => _isUploadingAvatar = false);
      }
    }
  }

  Future<void> _pickBirthDate() async {
    DateTime initialDate = DateTime(2000, 1, 1);
    final currentValue = (_form.control('birthDate').value as String?)?.trim();

    if (currentValue != null && currentValue.isNotEmpty) {
      final parsed = DateTime.tryParse(currentValue);
      if (parsed != null) {
        initialDate = parsed;
      }
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText:
          'اختر تاريخ الميلاد',
    );

    if (pickedDate == null) return;

    final formatted =
        '${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
    _form.control('birthDate').value = formatted;
  }

  Future<void> _removeAvatar() async {
    final currentUrl = (_form.control('avatarUrl').value as String?)?.trim();
    if (currentUrl == null || currentUrl.isEmpty) return;

    setState(() => _isDeletingAvatar = true);
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .removeAvatar(
            currentAvatarUrl: currentUrl,
            onSuccess: () {
              _form.control('avatarUrl').value = '';
              ref.invalidate(appUserFutureProvider);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'تم حذف الصورة الشخصية',
                  ),
                ),
              );
            },
            onError: (message) {
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
          );
    } finally {
      if (mounted) {
        setState(() => _isDeletingAvatar = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_form.valid) {
      _form.markAllAsTouched();
      return;
    }

    final appUser = await ref.read(appUserFutureProvider.future);
    if (appUser == null) return;

    final name =
        (_form.control('name').value as String?)?.trim() ?? appUser.name ?? '';
    final email = (_form.control('email').value as String?)?.trim() ?? '';
    final avatarUrl = (_form.control('avatarUrl').value as String?)?.trim();
    final gender = (_form.control('gender').value as String?)?.trim();
    final birthDate = (_form.control('birthDate').value as String?)?.trim();

    setState(() => _isSavingProfile = true);
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .updateProfile(
            name: name,
            email: email,
            avatarUrl: avatarUrl?.isEmpty == true ? null : avatarUrl,
            gender: gender?.isEmpty == true ? null : gender,
            type: appUser.type?.name,
            birthDate: birthDate?.isEmpty == true ? null : birthDate,
            onSuccess: () {
              if (!mounted) return;
              ref.invalidate(appUserFutureProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم تحديث الملف الشخصي بنجاح',
                  ),
                ),
              );
            },
            onError: (message) {
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
          );
    } finally {
      if (mounted) {
        setState(() => _isSavingProfile = false);
      }
    }
  }
}



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/presentation/providers/loading_provider.dart';
import '../providers/auth_notifier_provider.dart';
import '../providers/providers.dart';
import '../providers/signup_form_provider.dart';
import 'auth_shared_widgets.dart';

const _signupLoadingScope = 'signup-form';

class SignupFormWidget extends ConsumerStatefulWidget {
  const SignupFormWidget({
    super.key,
    this.onSwitchToLogin,
    this.showBottomSwitchAction = true,
  });

  final VoidCallback? onSwitchToLogin;
  final bool showBottomSwitchAction;

  @override
  ConsumerState<SignupFormWidget> createState() => _SignupFormWidgetState();
}

class _SignupFormWidgetState extends ConsumerState<SignupFormWidget> {
  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parts = value.split('-');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    return DateTime(y, m, d);
  }

  Future<void> _pickBirthDate(FormGroup form) async {
    final now = DateTime.now();
    final existing = _parseDate(form.control('birthDate').value as String?);
    final picked = await showDatePicker(
      context: context,
      initialDate: existing ?? DateTime(now.year - 20, 1, 1),
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
    );

    if (picked != null) {
      form.control('birthDate').value = _formatDate(picked);
    }
  }

  Future<void> _handleSignup(
    BuildContext context,
    WidgetRef ref,
    FormGroup form,
  ) async {
    ref.read(scopedLoadingProvider(_signupLoadingScope).notifier).state = true;
    if (!form.valid) {
      form.markAllAsTouched();
      ref.read(scopedLoadingProvider(_signupLoadingScope).notifier).state =
          false;
      return;
    }

    try {
      final name = (form.control('name').value as String?)?.trim() ?? '';
      final email = (form.control('email').value as String?)?.trim() ?? '';
      final gender = (form.control('gender').value as String?)?.trim();
      const type = 'member';
      final birthDate = (form.control('birthDate').value as String?)?.trim();
      final password = (form.control('password').value as String?) ?? '';

      await ref
          .read(authNotifierProvider.notifier)
          .signup(
            name: name,
            email: email,
            password: password,
            gender: gender?.isEmpty == true ? null : gender,
            type: type,
            birthDate: birthDate?.isEmpty == true ? null : birthDate,
            onSuccess: () {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إنشاء الحساب بنجاح')),
              );
              widget.onSwitchToLogin?.call();
            },
            onError: (message) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
          );
    } finally {
      if (context.mounted) {
        ref.read(scopedLoadingProvider(_signupLoadingScope).notifier).state =
            false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(signupFormProvider);
    final isLoading = ref.watch(scopedLoadingProvider(_signupLoadingScope));
    final obscurePassword = ref.watch(signupPasswordVisibilityProvider);
    final obscureConfirmPassword = ref.watch(
      signupConfirmPasswordVisibilityProvider,
    );

    return ReactiveForm(
      formGroup: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'أنشئ حساباً جديداً',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 22),
          AuthTextField(
            formControlName: 'name',
            label: 'الاسم الكامل',
            prefixIcon: Icon(Icons.person_outline),
            validationMessages: {ValidationMessage.required: (_) => 'مطلوب'},
          ),
          const SizedBox(height: 16),
          AuthTextField(
            formControlName: 'email',
            label: 'البريد الإلكتروني',
            keyboardType: TextInputType.emailAddress,
            textDirection: TextDirection.ltr,
            prefixIcon: Icon(Icons.email_outlined),
            validationMessages: {
              ValidationMessage.required: (_) => 'مطلوب',
              ValidationMessage.email: (_) => 'البريد الإلكتروني مطلوب',
            },
          ),
          const SizedBox(height: 16),
          ReactiveDropdownField<String>(
            formControlName: 'gender',
            decoration: InputDecoration(
              labelText: 'الجنس',
              prefixIcon: Icon(Icons.wc_outlined),
            ),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('ذكر')),
              DropdownMenuItem(value: 'female', child: Text('أنثى')),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _pickBirthDate(form),
            child: IgnorePointer(
              child: AuthTextField(
                formControlName: 'birthDate',
                label: 'تاريخ الميلاد',
                textDirection: TextDirection.ltr,
                prefixIcon: Icon(Icons.calendar_today_outlined),
                suffixIcon: IconButton(
                  onPressed: () => _pickBirthDate(form),
                  icon: const Icon(Icons.date_range_outlined),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AuthTextField(
            formControlName: 'password',
            label: 'كلمة المرور',
            obscureText: obscurePassword,
            textDirection: TextDirection.ltr,
            prefixIcon: Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                ref.read(signupPasswordVisibilityProvider.notifier).state =
                    !obscurePassword;
              },
            ),
            validationMessages: {
              ValidationMessage.required: (_) => 'مطلوب',
              ValidationMessage.minLength: (_) =>
                  'كلمة المرور على الأقل يجب أن تكون 6 محارف',
            },
          ),
          const SizedBox(height: 16),
          AuthTextField(
            formControlName: 'confirmPassword',
            label: 'تأكيد كلمة المرور',
            obscureText: obscureConfirmPassword,
            textDirection: TextDirection.ltr,
            prefixIcon: Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                ref
                        .read(signupConfirmPasswordVisibilityProvider.notifier)
                        .state =
                    !obscureConfirmPassword;
              },
            ),
            validationMessages: {
              ValidationMessage.required: (_) => 'مطلوب',
              ValidationMessage.mustMatch: (_) =>
                  'كلمة المرور وتأكيدها غير متطابقين',
            },
          ),
          const SizedBox(height: 16),
          AuthPrimaryButton(
            label: 'إنشاء حساب',
            isLoading: isLoading,
            onPressed: () => _handleSignup(context, ref, form),
          ),
          if (widget.onSwitchToLogin != null &&
              widget.showBottomSwitchAction) ...[
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: widget.onSwitchToLogin,
                child: Text('لديك حساب؟ سجل دخول'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

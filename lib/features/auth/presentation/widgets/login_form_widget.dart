import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../core/presentation/providers/loading_provider.dart';
import '../providers/auth_notifier_provider.dart';
import '../providers/login_form_provider.dart';
import '../providers/providers.dart';
import 'auth_shared_widgets.dart';

const _loginLoadingScope = 'login-form';

class LoginFormWidget extends ConsumerWidget {
  const LoginFormWidget({
    super.key,
    this.onSwitchToSignup,
    this.showBottomSwitchAction = true,
  });

  final VoidCallback? onSwitchToSignup;
  final bool showBottomSwitchAction;

  Future<void> _handleLogin(
    BuildContext context,
    WidgetRef ref,
    FormGroup form,
  ) async {
    ref.read(scopedLoadingProvider(_loginLoadingScope).notifier).state = true;
    if (!form.valid) {
      form.markAllAsTouched();
      ref.read(scopedLoadingProvider(_loginLoadingScope).notifier).state =
          false;
      return;
    }

    try {
      final email = (form.control('email').value as String?)?.trim() ?? '';
      final password = (form.control('password').value as String?) ?? '';

      await ref
          .read(authNotifierProvider.notifier)
          .login(
            email: email,
            password: password,
            onSuccess: () {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
              );
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
        ref.read(scopedLoadingProvider(_loginLoadingScope).notifier).state =
            false;
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(loginFormProvider);
    final isLoading = ref.watch(scopedLoadingProvider(_loginLoadingScope));
    final obscurePassword = ref.watch(passwordVisibilityProvider);

    return ReactiveForm(
      formGroup: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 4),
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
                ref.read(passwordVisibilityProvider.notifier).state =
                    !obscurePassword;
              },
            ),
            validationMessages: {
              ValidationMessage.required: (_) => 'مطلوب',
              ValidationMessage.minLength: (_) =>
                  'كلمة المرور على الأقل يجب أن تكون 6 محارف',
            },
          ),
          const SizedBox(height: 12),
          AuthPrimaryButton(
            label: 'تسجيل الدخول',
            isLoading: isLoading,
            onPressed: () => _handleLogin(context, ref, form),
          ),
          if (onSwitchToSignup != null && showBottomSwitchAction) ...[
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: onSwitchToSignup,
                child: Text('ليس لديك حساب؟ أنشئ واحدًا'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

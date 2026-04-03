import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

final signupFormProvider = Provider.autoDispose<FormGroup>((ref) {
  final form = FormGroup(
    {
      'name': FormControl<String>(validators: [Validators.required]),
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
      'avatarUrl': FormControl<String>(),
      'gender': FormControl<String>(value: 'male'),
      'type': FormControl<String>(value: 'member'),
      'birthDate': FormControl<String>(),
      'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(6)],
      ),
      'confirmPassword': FormControl<String>(validators: [Validators.required]),
    },
    validators: [Validators.mustMatch('password', 'confirmPassword')],
  );

  return form;
});

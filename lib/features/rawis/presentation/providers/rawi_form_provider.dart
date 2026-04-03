import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../domain/models/rawi.dart';

final rawiFormProvider = Provider.family.autoDispose<FormGroup, Rawi?>((
  ref,
  rawi,
) {
  return FormGroup({
    'name': FormControl<String>(
      validators: [Validators.required],
      value: rawi?.name ?? '',
    ),
    'gender': FormControl<Gender>(
      validators: [Validators.required],
      value: rawi?.gender ?? Gender.male,
    ),
    'about': FormControl<String>(
      validators: [Validators.required],
      value: rawi?.about ?? '',
    ),
  });
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../domain/models/ruling.dart';

final rulingFormProvider = Provider.family.autoDispose<FormGroup, Ruling?>((
  ref,
  ruling,
) {
  return FormGroup({
    'name': FormControl<String>(
      validators: [Validators.required],
      value: ruling?.name ?? "",
    ),
  });
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../domain/models/book.dart';

final bookFormProvider = Provider.family.autoDispose<FormGroup, Book?>((
  ref,
  book,
) {
  return FormGroup({
    'name': FormControl<String>(
      validators: [Validators.required],
      value: book?.name ?? '',
    ),
    'muhaddithId': FormControl<String>(
      validators: [Validators.required],
      value: book?.muhaddithId ?? '',
    ),
  });
});

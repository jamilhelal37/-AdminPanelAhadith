import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../domain/models/comment.dart';

final commentFormProvider = Provider.family.autoDispose<FormGroup, Comment?>((
  ref,
  comment,
) {
  return FormGroup({
    'hadithId': FormControl<String>(
      validators: [Validators.required],
      value: comment?.hadithId ?? '',
    ),
    'userId': FormControl<String>(
      validators: [Validators.required],
      value: comment?.userId ?? '',
    ),
    'text': FormControl<String>(
      validators: [Validators.required],
      value: comment?.text ?? '',
    ),
  });
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../domain/models/topic.dart';

final topicFormProvider = Provider.family.autoDispose<FormGroup, Topic?>((
  ref,
  topic,
) {
  return FormGroup({
    'name': FormControl<String>(
      validators: [Validators.required],
      value: topic?.name ?? "",
    ),
  });
});

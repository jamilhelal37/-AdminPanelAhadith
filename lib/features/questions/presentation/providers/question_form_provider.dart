import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../domain/models/question.dart';

final questionFormProvider = Provider.family.autoDispose<FormGroup, Question?>((
  ref,
  question,
) {
  return FormGroup({
    
    'askerText': FormControl<String>(
      validators: [Validators.required],
      value: (question?.askerText ?? '').trim(),
    ),

    
    
    'askerId': FormControl<String>(
      validators: [Validators.required],
      value: question?.askerId,
    ),

    
    'answerText': FormControl<String>(
      value: (question?.answerText ?? '').trim(),
    ),

    
    'isActive': FormControl<bool>(value: question?.isActive ?? false),
  });
});


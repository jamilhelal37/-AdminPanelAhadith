import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../domain/models/question.dart';

final questionFormProvider = Provider.family.autoDispose<FormGroup, Question?>((
  ref,
  question,
) {
  return FormGroup({
    // ✅ نص السؤال
    'askerText': FormControl<String>(
      validators: [Validators.required],
      value: (question?.askerText ?? '').trim(),
    ),

    // ✅ المرسل (asker) - FK / user id
    // عند الإضافة خليه فاضي، أو حط id افتراضي إذا عندك
    'askerId': FormControl<String>(
      validators: [Validators.required],
      value: question?.askerId,
    ),

    // ✅ الجواب (اختياري)
    'answerText': FormControl<String>(
      value: (question?.answerText ?? '').trim(),
    ),

    // ✅ الحالة (افتراضي false كما في موديلك)
    'isActive': FormControl<bool>(value: question?.isActive ?? false),
  });
});


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../domain/models/hadith.dart';

final hadithFormProvider = Provider.family.autoDispose<FormGroup, Hadith?>((
  ref,
  hadith,
) {
  return FormGroup({
    'hadithNumber': FormControl<int>(
      validators: [Validators.required],
      value: hadith?.hadithNumber,
    ),
    'type': FormControl<HadithType>(
      validators: [Validators.required],
      value: hadith?.type ?? HadithType.marfu,
    ),
    'text': FormControl<String>(
      validators: [Validators.required],
      value: (hadith?.text ?? '').trim(),
    ),

    // Required FKs
    'rawiId': FormControl<String>(
      validators: [Validators.required],
      value: hadith?.rawiId,
    ),
    'sourceId': FormControl<String>(
      validators: [Validators.required],
      value: hadith?.sourceId,
    ),
    'muhaddithRulingId': FormControl<String>(
      validators: [Validators.required],
      value: hadith?.muhaddithRulingId,
    ),

    // Optional FKs
    'finalRulingId': FormControl<String?>(value: hadith?.finalRulingId),
    'explainingId': FormControl<String?>(value: hadith?.explainingId),

    // Optional text
    'sanad': FormControl<String>(value: (hadith?.sanad ?? '').trim()),
    'subValid': FormControl<String?>(value: hadith?.subValid?.trim()),
  });
});

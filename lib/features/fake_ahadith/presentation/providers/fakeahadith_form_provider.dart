import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../domain/models/fake_ahadith.dart';

final fakeAhadithFormProvider = Provider.family
    .autoDispose<FormGroup, FakeAhadith?>((ref, fakeAhadith) {
      return FormGroup({
        'text': FormControl<String>(
          validators: [Validators.required],
          value: fakeAhadith?.text ?? '',
        ),
        'ruling': FormControl<String>(
          validators: [Validators.required],
          value: fakeAhadith?.ruling ?? '',
        ),
        'subValid': FormControl<String>(value: fakeAhadith?.subValid ?? ''),
      });
    });

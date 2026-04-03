import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../domain/models/explaining.dart';

final explainingFormProvider = Provider.family
    .autoDispose<FormGroup, Explaining?>((ref, explaining) {
      return FormGroup({
        'text': FormControl<String>(
          validators: [Validators.required],
          value: explaining?.text ?? "",
        ),
      });
    });

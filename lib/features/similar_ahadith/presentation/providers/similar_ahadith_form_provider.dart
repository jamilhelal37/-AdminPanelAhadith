import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../domain/models/similar_ahadith.dart';

final similarAhadithFormProvider = Provider.family
    .autoDispose<FormGroup, SimilarAhadith?>((ref, similarAhadith) {
      return FormGroup({
        'mainHadithId': FormControl<String>(
          validators: [Validators.required],
          value: similarAhadith?.mainHadithId ?? '',
        ),
        'simHadithId': FormControl<String>(
          validators: [Validators.required],
          value: similarAhadith?.simHadithId ?? '',
        ),
      });
    });

import 'package:ahadith/features/muhaddiths/domain/models/muhaddith.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

final muhaddithFormProvider = Provider.family
    .autoDispose<FormGroup, Muhaddith?>((ref, muhaddith) {
      return FormGroup({
        'name': FormControl<String>(
          validators: [Validators.required],
          value: muhaddith?.name ?? '',
        ),
        'gender': FormControl<Gender>(
          validators: [Validators.required],
          value: muhaddith?.gender ?? Gender.male,
        ),
        'about': FormControl<String>(
          validators: [Validators.required],
          value: muhaddith?.about ?? '',
        ),
      });
    });

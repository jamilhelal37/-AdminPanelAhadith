import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../domain/models/topic_class.dart';

final topicClassFormProvider = Provider.family
    .autoDispose<FormGroup, TopicClass?>((ref, topicClass) {
      return FormGroup({
        'topicId': FormControl<String>(
          validators: [Validators.required],
          value: topicClass?.topicId ?? '',
        ),
        'hadithId': FormControl<String>(
          validators: [Validators.required],
          value: topicClass?.hadithId ?? '',
        ),
      });
    });

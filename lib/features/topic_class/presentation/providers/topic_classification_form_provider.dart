import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../ahadith/domain/models/hadith.dart';

final topicClassificationFormProvider = Provider.family
    .autoDispose<FormGroup, (Hadith?, List<String>?)>((ref, data) {
      final (hadith, selectedTopicIds) = data;

      return FormGroup({
        'hadithId': FormControl<String>(value: hadith?.id ?? ''),
        'topicIds': FormControl<List<String>>(value: selectedTopicIds ?? []),
      });
    });

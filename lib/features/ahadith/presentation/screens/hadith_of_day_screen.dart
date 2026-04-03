import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../providers/hadith_of_day_provider.dart';
import '../widgets/hadith_of_day_content.dart';

class HadithOfDayScreen extends ConsumerWidget {
  const HadithOfDayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hadithAsync = ref.watch(hadithOfTheDayProvider);
    return HadithOfDayContent(hadithAsync: hadithAsync);
  }
}

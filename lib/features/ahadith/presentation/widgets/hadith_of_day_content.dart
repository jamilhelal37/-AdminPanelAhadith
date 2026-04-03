import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/hadith.dart';
import '../screens/hadith_detail_screen.dart';

class HadithOfDayContent extends ConsumerWidget {
  const HadithOfDayContent({super.key, required this.hadithAsync});

  final AsyncValue<Hadith?> hadithAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return hadithAsync.when(
      data: (hadith) {
        if (hadith == null) {
          return const _HadithOfDayStatusScaffold(
            title: 'حديث اليوم',
            message: 'لا يوجد حديث متاح حالياً',
          );
        }

        return HadithDetailScreen(hadith: hadith, appBarTitle: 'حديث اليوم');
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => _HadithOfDayStatusScaffold(
        title: 'حديث اليوم',
        message: 'تعذر تحميل حديث اليوم:\n$error',
      ),
    );
  }
}

class _HadithOfDayStatusScaffold extends StatelessWidget {
  const _HadithOfDayStatusScaffold({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            message,
            style: const TextStyle(fontSize: 16, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}



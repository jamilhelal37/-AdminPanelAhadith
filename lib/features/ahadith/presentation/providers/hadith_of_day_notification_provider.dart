import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/hadith_of_day_bootstrap_service.dart';
import '../../application/hadith_of_day_notification_service.dart';
import 'hadith_of_day_provider.dart';

Future<void> scheduleHadithOfDayNotifications(WidgetRef ref) async {
  final hadiths = await ref.read(hadithCatalogProvider.future);
  if (hadiths.isEmpty) return;

  await ref
      .read(hadithOfDayNotificationServiceProvider)
      .scheduleUpcomingNotifications(hadiths);
}

Future<void> prepareHadithOfDayOnAppLaunch(WidgetRef ref) async {
  final hadiths = await ref.read(hadithCatalogProvider.future);
  if (hadiths.isEmpty) return;
  await ref
      .read(hadithOfDayBootstrapServiceProvider)
      .prepareOnAppLaunch(hadiths);
}

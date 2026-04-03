import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/hadith.dart';
import 'hadith_of_day_cache.dart';
import 'hadith_of_day_helper.dart';
import 'hadith_of_day_notification_constants.dart';
import 'hadith_of_day_notification_service.dart';

class HadithOfDayBootstrapService {
  const HadithOfDayBootstrapService(this._notificationService);

  final HadithOfDayNotificationService _notificationService;

  Future<void> prepareOnAppLaunch(List<Hadith> hadiths) async {
    if (hadiths.isEmpty) return;

    final daysToPrepare = HadithOfDayNotificationConstants.daysToSchedule;
    final hasCachedRange = await HadithOfDayCache.hasCachedRange(
      days: daysToPrepare,
    );

    if (!hasCachedRange) {
      final cachedHadiths = <DateTime, Hadith>{};
      final now = DateTime.now();
      for (var dayOffset = 0; dayOffset < daysToPrepare; dayOffset++) {
        final targetDate = now.add(Duration(days: dayOffset));
        final hadith = selectHadithOfTheDay(hadiths, date: targetDate);
        if (hadith == null) continue;

        cachedHadiths[DateTime(
              targetDate.year,
              targetDate.month,
              targetDate.day,
            )] =
            hadith;
      }

      if (cachedHadiths.isNotEmpty) {
        await HadithOfDayCache.cacheScheduledHadiths(cachedHadiths);
      }
    }

    await _notificationService.scheduleUpcomingNotifications(hadiths);
  }
}

final hadithOfDayBootstrapServiceProvider =
    Provider<HadithOfDayBootstrapService>((ref) {
      return HadithOfDayBootstrapService(
        ref.read(hadithOfDayNotificationServiceProvider),
      );
    });

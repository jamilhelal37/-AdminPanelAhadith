import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/hadith.dart';
import 'hadith_of_day_cache.dart';
import 'hadith_of_day_helper.dart';
import 'hadith_of_day_notification_constants.dart';
import 'hadith_of_day_notification_service.dart';

class HadithOfDayNotificationScheduler {
  const HadithOfDayNotificationScheduler(this._notifications);

  final AwesomeNotifications _notifications;
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<void> scheduleUpcomingNotifications(List<Hadith> hadiths) async {
    if (hadiths.isEmpty) return;

    final scheduledHadiths = <DateTime, Hadith>{};
    final now = DateTime.now();
    final todayKey = DateTime(now.year, now.month, now.day).toIso8601String();
    final scheduleKey = '$todayKey-${hadiths.length}';

    if (await _prefs.getString(HadithOfDayNotificationConstants.scheduledKey) ==
        scheduleKey) {
      return;
    }

    for (var i = 0; i < HadithOfDayNotificationConstants.daysToSchedule; i++) {
      final notificationId =
          HadithOfDayNotificationConstants.baseNotificationId + i;
      await _notifications.cancel(notificationId);
      await _notifications.cancelSchedule(notificationId);
    }

    for (
      var dayOffset = 0;
      dayOffset < HadithOfDayNotificationConstants.daysToSchedule;
      dayOffset++
    ) {
      final targetDate = now.add(Duration(days: dayOffset));
      final hadith = selectHadithOfTheDay(hadiths, date: targetDate);
      if (hadith == null) continue;
      scheduledHadiths[DateTime(
            targetDate.year,
            targetDate.month,
            targetDate.day,
          )] =
          hadith;

      await _notifications.createNotification(
        schedule: NotificationCalendar.fromDate(
          date: _scheduledDateFor(targetDate, immediateIfPast: dayOffset == 0),
          allowWhileIdle: true,
          preciseAlarm: false,
          repeats: false,
        ),
        content: NotificationContent(
          id: HadithOfDayNotificationConstants.baseNotificationId + dayOffset,
          channelKey: HadithOfDayNotificationConstants.channelId,
          title: HadithOfDayNotificationConstants.channelName,
          body: buildHadithOfDayNotificationBody(hadith.text),
          notificationLayout: NotificationLayout.BigText,
          payload: {
            HadithOfDayNotificationService.payloadKey:
                HadithOfDayNotificationConstants.payload,
          },
        ),
      );
    }

    await HadithOfDayCache.cacheScheduledHadiths(scheduledHadiths);

    await _prefs.setString(
      HadithOfDayNotificationConstants.scheduledKey,
      scheduleKey,
    );
  }

  DateTime _scheduledDateFor(DateTime date, {required bool immediateIfPast}) {
    final now = DateTime.now();
    final scheduled = DateTime(date.year, date.month, date.day, 9);

    if (!scheduled.isBefore(now)) {
      return scheduled;
    }

    if (immediateIfPast) {
      return now.add(const Duration(seconds: 5));
    }

    return scheduled.add(const Duration(days: 1));
  }
}

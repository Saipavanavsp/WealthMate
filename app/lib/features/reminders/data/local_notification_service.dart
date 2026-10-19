import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../domain/bill_reminder.dart';
import '../domain/reminder_repository.dart';

/// Schedules a repeating notification on the reminder's day each month.
///
/// Uses inexact alarms, so Android doesn't need the exact-alarm permission. A
/// bill reminder landing a few minutes late is fine.
class LocalNotificationService implements ReminderNotifier {
  LocalNotificationService([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;

  static const _channel = AndroidNotificationDetails(
    'bill_reminders',
    'Bill reminders',
    channelDescription: 'Reminders for upcoming bills',
    importance: Importance.high,
    priority: Priority.high,
  );

  @override
  Future<void> initialise() async {
    if (_ready) return;
    tz_data.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } catch (e) {
      debugPrint('Falling back to UTC for notifications: $e');
    }

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    _ready = true;
  }

  @override
  Future<void> scheduleMonthly(BillReminder reminder) async {
    await initialise();
    final due = reminder.nextDue(DateTime.now());
    await _plugin.zonedSchedule(
      id: reminder.id!,
      title: '${reminder.title} is due',
      body: '${reminder.amount.format()} due on day ${reminder.dayOfMonth} of the month',
      scheduledDate: tz.TZDateTime.from(due, tz.local),
      notificationDetails: const NotificationDetails(android: _channel, iOS: DarwinNotificationDetails()),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  @override
  Future<void> cancel(int reminderId) async {
    await initialise();
    await _plugin.cancel(id: reminderId);
  }
}

/// Used on the web build and in tests, where scheduled notifications aren't available.
class NoopReminderNotifier implements ReminderNotifier {
  const NoopReminderNotifier();

  @override
  Future<void> initialise() async {}

  @override
  Future<void> scheduleMonthly(BillReminder reminder) async {}

  @override
  Future<void> cancel(int reminderId) async {}
}

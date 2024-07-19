import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzl;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsServices {
  static final _localNotification = FlutterLocalNotificationsPlugin();

  static bool notificationEnabled = false;

  static Future<void> requestPermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
      notificationEnabled = await _localNotification
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
          false;

      await _localNotification
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final androidImplementation =
          _localNotification.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestExactAlarmsPermission();

      final bool? grantedScheduleNotificationPermission =
          await androidImplementation?.requestExactAlarmsPermission();

      notificationEnabled = grantedNotificationPermission ?? false;
      notificationEnabled = grantedScheduleNotificationPermission ?? false;
    }
  }

  static Future<void> start() async {
    await _initializeTimeZones();
    await _initializeNotifications();
  }

  static Future<void> _initializeTimeZones() async {
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tzl.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  static Future<void> _initializeNotifications() async {
    const androidInit = AndroidInitializationSettings("@mipmap/ic_launcher");
    final iosInit = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'demoCategory',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('id_1', 'Action 1'),
            DarwinNotificationAction.plain(
              'id_2',
              'Action 2',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
            DarwinNotificationAction.plain(
              'id_3',
              'Action 3',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        )
      ],
    );

    final notificationInit = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotification.initialize(
      notificationInit,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        print(notificationResponse.payload);
      },
    );
  }

  static Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledDate) async {
    await _localNotification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          importance: Importance.max,
          priority: Priority.max,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}

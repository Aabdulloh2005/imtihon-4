import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzl;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsServices {
  static final _localnotification = FlutterLocalNotificationsPlugin();

  static bool notificationEnabled = false;

  static Future<void> requestPermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
      /// agar [IOS] bo'lsa shu orqali ruxsat so'raymiz
      notificationEnabled = await _localnotification
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
          false;

      await _localnotification
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      /// agar [Android] bo'lsa bundan foydalanamiz
      final androidImplementation =
          _localnotification.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      // bu yerda darhol xabarnomaga ruhsat so'raymiz.
      final bool? grantedNotificationPermission =
          await androidImplementation?.requestExactAlarmsPermission();

      // bu yerda rejali xabarnomaga ruxsat so'raymiz
      final bool? grantedScheduleNotificationPermission =
          await androidImplementation?.requestExactAlarmsPermission();

      //! kamchilik:
      //? ikkalasi uchunham bitta o'zgaruvchi ishlatilgan!
      notificationEnabled = grantedNotificationPermission ?? false;
      notificationEnabled = grantedScheduleNotificationPermission ?? false;
    }
  }

  static Future<void> start() async {
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tzl.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    /// [Adroid] va [IOS] uchun sozlamalarni to'g'irlaymiz
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

    await _localnotification.initialize(
      notificationInit,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        print(notificationResponse.payload);
      },
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledDate) async {
    await _localnotification.zonedSchedule(
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

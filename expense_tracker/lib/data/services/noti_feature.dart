// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tzdata;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static void initialize(BuildContext context) {
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//       // iOS initialization settings if needed
//     );

//     // _notificationsPlugin.initialize(initializationSettings,
//     //     onSelectNotification: _handleNotificationClick);

//     tzdata.initializeTimeZones();
//   }

//   static Future<void> _handleNotificationClick(String? payload) async {
//     // Handle notification click here, e.g., navigate to add expense page
//     // Example navigation to add expense page
//     // Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpenseScreen()));
//   }

//   static void showDailyNotification(BuildContext context, TimeOfDay selectedTime) {
//     final now = DateTime.now();
//     final scheduledDateTime = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       selectedTime.hour,
//       selectedTime.minute,
//     );

//     scheduleDailyNotification(context, scheduledDateTime);
//   }

//   static void scheduleDailyNotification(BuildContext context, DateTime selectedDateTime) async {
//     final AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'expense_tracker_daily_reminder', // channel id
//       'Expense Tracker Daily Reminder', // channel name

//       importance: Importance.high,
//       priority: Priority.high,
//       icon: '@mipmap/ic_launcher',
//       enableLights: true,
//       enableVibration: true,
//       playSound: true,

//     );

//     NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     final tz.TZDateTime scheduledDate =
//         tz.TZDateTime.from(selectedDateTime, tz.local);

//     await _notificationsPlugin.zonedSchedule(
//       0, // Notification id
//       'Expense Tracker Reminder', // Title
//       'Don\'t forget to add your daily expenses!', // Body
//       scheduledDate,
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotiFeature {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? result =
          await androidImplementation.requestNotificationsPermission();
      if (result != true) {
        // Handle the case when the user denied the permission
      }
    }
  }

  notificationsDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName",
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationsDetails());
  }

  Future scheduleDailyNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleNotificationDateTime,
  }) async {
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduleNotificationDateTime, tz.local),
      await notificationsDetails(),
      // androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduleNotificationDateTime,
  }) async {
    // Convert DateTime to TZDateTime for proper timezone handling
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      scheduleNotificationDateTime,
      tz.local, // Replace with your desired timezone
    );

    // Check if scheduledDate is in the future
    if (scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'channel id',
            'channel name',
            // 'channel description',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } else {
      print('Error: Scheduled date must be in the future.');
    }
  }
}

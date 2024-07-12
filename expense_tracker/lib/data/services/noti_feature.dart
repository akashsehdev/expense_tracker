import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      // iOS initialization settings if needed
    );

    // _notificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: _handleNotificationClick);

    tzdata.initializeTimeZones();
  }

  static Future<void> _handleNotificationClick(String? payload) async {
    // Handle notification click here, e.g., navigate to add expense page
    // Example navigation to add expense page
    // Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpenseScreen()));
  }

  static void showDailyNotification(BuildContext context, TimeOfDay selectedTime) {
    final now = DateTime.now();
    final scheduledDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    scheduleDailyNotification(context, scheduledDateTime);
  }

  static void scheduleDailyNotification(BuildContext context, DateTime selectedDateTime) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'expense_tracker_daily_reminder', // channel id
      'Expense Tracker Daily Reminder', // channel name
      
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableLights: true,
      enableVibration: true,
      playSound: true,
      
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(selectedDateTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      0, // Notification id
      'Expense Tracker Reminder', // Title
      'Don\'t forget to add your daily expenses!', // Body
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}

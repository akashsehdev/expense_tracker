// // Example local notification setup


// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// void initializeNotifications() {
//   var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
//   var initializationSettingsIOS = IOSInitializationSettings();
//   var initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS,
//   );
//   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   flutterLocalNotificationsPlugin.initialize(initializationSettings);
// }

// Future<void> showNotification() async {
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'your_channel_id',
//     'your_channel_name',
//     'your_channel_description',
//   );
//   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//   var platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//     iOS: iOSPlatformChannelSpecifics,
//   );
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     'Reminder',
//     'Don\'t forget to track your expenses today!',
//     platformChannelSpecifics,
//   );
// }

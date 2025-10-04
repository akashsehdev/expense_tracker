import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/services/noti_feature.dart';
import 'domain/provider/provider_.dart';
import 'data/services/db_expense_provider.dart';
import 'presentation/screens/home_expense_list.dart';
import 'presentation/screens/auth.dart';
import 'package:timezone/data/latest.dart' as tzdata;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotiFeature().initNotification();
  tzdata.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // NotificationService.initialize(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UiProvider()..initStorage(),
        ),
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
      ],
      child: Consumer<UiProvider>(
        builder: (context, UiProvider notifier, child) {
          return MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            // Determine initial screen based on rememberMe flag
            home: notifier.rememberMe
                ? FutureBuilder<int?>(
                    future:
                        getUserIdFromStorage(), // Example method to fetch userId
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error fetching userId'));
                      } else {
                        int? userId = snapshot.data;
                        return userId != null
                            ? ExpenseList(userId: userId)
                            : AuthScreen(); // Navigate to AuthScreen if userId is null
                      }
                    },
                  )
                : AuthScreen(),
          );
        },
      ),
    );
  }

  Future<int?> getUserIdFromStorage() async {
    // Example function to retrieve userId from storage (e.g., SharedPreferences)
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'data/provider/provider_.dart';
// import 'data/services/db_expense_provider.dart';
// import 'presentation/views/home_expense_list.dart';
// import 'presentation/views/auth.dart';
// import 'presentation/views/home.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   DatabaseProvider();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//             create: (context) => UiProvider()..initStorage()),
//         ChangeNotifierProvider(create: (context) => DatabaseProvider()),
//       ],
//       // create: (context) => UiProvider()..initStorage(),
//       child:
//           Consumer<UiProvider>(builder: (context, UiProvider notifier, child) {
//         return MaterialApp(
//           theme: ThemeData(
//             colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//             useMaterial3: true,
//           ),
//           debugShowCheckedModeBanner: false,
//           //First Page
//           //if rememberMe is true goto home else authscreen
//           home: notifier.rememberMe ? ExpenseList(userId: userD,) : const AuthScreen(),
//           // home: ExpenseList(),
//           // home: AddExpenseScreen(),
//         );
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/provider/provider_.dart';
import 'data/services/db_expense_provider.dart';
import 'presentation/views/home_expense_list.dart';
import 'presentation/views/auth.dart';
import 'presentation/views/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UiProvider()..initStorage(),
        ),
        ChangeNotifierProvider(
          create: (context) => DatabaseProvider(),
        ),
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

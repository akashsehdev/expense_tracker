import 'package:expense_tracker/data/provider/provider_.dart';
import 'package:expense_tracker/presentation/views/auth.dart';
import 'package:expense_tracker/presentation/views/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UiProvider(),
      child: Consumer<UiProvider>(
        builder: (context, UiProvider notifier, child) {
          return MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            //First Page
            //if rememberMe is true goto home else authscreen
            home: notifier.rememberMe? const HomeScreen() : const AuthScreen(),
          );
        }
      ),
    );
  }
}

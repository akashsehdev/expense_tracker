import 'package:expense_tracker/presentation/components/TextWidget.dart';
import 'package:expense_tracker/presentation/components/btn.dart';
import 'package:expense_tracker/presentation/components/colors.dart';
import 'package:expense_tracker/presentation/views/login.dart';
import 'package:expense_tracker/presentation/views/signup.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textWidget(
              title: "Authentication",
              color: Colors.blue,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            Btn(
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
              },
              label: "LOGIN",
              backgroundColor: primaryColor,
              fontSize: 20,
              txtColor: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            Btn(
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ));
              },
              label: "SIGN UP",
              backgroundColor: primaryColor,
              fontSize: 20,
              txtColor: Colors.white,
              fontWeight: FontWeight.w600,
            )
          ],
        ),
      )),
    );
  }
}

import 'package:expense_tracker/presentation/components/TextWidget.dart';
import 'package:expense_tracker/presentation/components/btn.dart';
import 'package:expense_tracker/presentation/components/colors.dart';
import 'package:expense_tracker/presentation/screens/login.dart';
import 'package:expense_tracker/presentation/screens/signup.dart';
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
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            textWidget(
              title: "New Here?",
              color: Colors.blue,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(
              width: 20,
            ),
            textWidget(
              textAlign: TextAlign.center,
              title: "Sign up or login and discover your expense tracker",
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
            Image.asset(
              "assets/authenticate.png",
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Btn(
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                      },
                      label: "LOGIN",
                      backgroundColor: bgColor,
                      fontSize: 20,
                      txtColor: const Color.fromARGB(255, 27, 27, 27),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Btn(
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
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

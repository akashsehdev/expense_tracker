import 'package:expense_tracker/data/models/user.dart';
import 'package:expense_tracker/data/services/db_helper.dart';
import 'package:expense_tracker/presentation/components/TextWidget.dart';
import 'package:expense_tracker/presentation/components/colors.dart';
import 'package:expense_tracker/presentation/components/textField.dart';
import 'package:expense_tracker/presentation/views/login.dart';
import 'package:flutter/material.dart';

import '../components/btn.dart';
import '../components/controllers_.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final db = DatabaseHelper();
  signUp() async {
    var res = await db.createUser(Users(
      fullName: fullName.text,
      email: email.text,
      userName: userName.text,
      userPassword: password.text,
    ));
    if (res > 0) {
      if (!mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: textWidget(
                      title: "Register New Account",
                      color: primaryColor,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //Full Name
                  InputField(
                    hint: "Full Name",
                    icon: Icons.person,
                    controller: fullName,
                  ),
                  //Email
                  InputField(
                    hint: "Email",
                    icon: Icons.email,
                    controller: email,
                  ),
                  //UserName
                  InputField(
                    hint: "Username",
                    icon: Icons.account_circle,
                    controller: userName,
                  ),
                  //Password
                  InputField(
                    hint: "Password",
                    icon: Icons.lock,
                    controller: password,
                    passwordInvisible: true,
                  ),
                  //Re-enter password
                  InputField(
                    hint: "Re-enter password",
                    icon: Icons.lock,
                    controller: confirmPass,
                    passwordInvisible: true,
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  Btn(
                    label: "SIGN UP",
                    press: () {
                      signUp();
                    },
                    txtColor: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    backgroundColor: primaryColor,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget(
                        title: "Already have an account?",
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        },
                        child: textWidget(
                          title: "LOGIN",
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user.dart';
import '../../data/provider/provider_.dart';
import '../../data/services/db_helper.dart';
import '../../presentation/components/TextWidget.dart';
import '../../presentation/components/btn.dart';
import '../../presentation/components/colors.dart';
import '../../presentation/components/textField.dart';
import '../../presentation/views/signup.dart';
import '../../presentation/views/home_expense_list.dart';
import '../components/controllers_.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  bool isLoginTrue = false;

  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textWidget(
                title: "LOGIN",
                color: ActiveColor,
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
              // Username
              InputField(
                hint: "Username",
                icon: Icons.account_circle,
                controller: username,
              ),
              // Password
              InputField(
                hint: "Password",
                icon: Icons.lock,
                controller: pass,
                passwordInvisible: true,
              ),
              Consumer<UiProvider>(
                builder: (context, UiProvider notifier, child) {
                  return ListTile(
                    horizontalTitleGap: 2,
                    title: textWidget(
                      title: "Remember me",
                      color: ActiveColor,
                    ),
                    leading: Checkbox(
                      activeColor: primaryColor,
                      value: notifier.isChecked,
                      onChanged: (value) {
                        setState(() {
                          notifier.toggleCheck();
                        });
                      },
                    ),
                  );
                },
              ),
              // Our login button
              Consumer<UiProvider>(
                builder: (context, UiProvider notifier, child) {
                  return Btn(
                    label: "LOGIN",
                    press: () async {
                      Users? userDetails = await db.getUser(username.text);
                      var res = await db.authenticate(Users(
                        userName: username.text,
                        userPassword: pass.text,
                      ));
                      if (res == true) {
                        // Store user details in SharedPreferences
                        await saveUserDetails(userDetails!);

                        // If result is correct then go to profile or home
                        if (notifier.isChecked == true) {
                          // Set remember me true if checked
                          notifier.setRememberMe();
                        }

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpenseList(
                              userId: userDetails.userId!,
                            ),
                          ),
                        );
                      } else {
                        // Otherwise show the error message
                        setState(() {
                          isLoginTrue = true;
                        });
                      }
                    },
                    txtColor: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    backgroundColor: primaryColor,
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                    title: "Don't have an account?",
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupScreen(),
                        ),
                      );
                    },
                    child: textWidget(
                      title: "SIGN UP",
                      color: ActiveColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Access denied message in case username and password is incorrect
              // By default it is hidden
              // When login is not true then display the message
              isLoginTrue
                  ? textWidget(
                      title: "Username or password is incorrect",
                      color: Colors.red,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveUserDetails(Users userDetails) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(
        'userId', userDetails.userId!); // Example field, adjust as needed
    prefs.setString('userName', userDetails.userName ?? '');
    prefs.setString('fullName', userDetails.fullName ?? '');
    prefs.setString('email', userDetails.email ?? '');
    // Add other fields as needed
  }
}

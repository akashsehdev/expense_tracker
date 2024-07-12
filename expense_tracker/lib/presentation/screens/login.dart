import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/db_helper.dart';
import '../../domain/models/user.dart';
import '../../domain/provider/provider_.dart';
import '../components/TextWidget.dart';
import '../components/btn.dart';
import '../components/colors.dart';
import '../components/textField.dart';
import 'signup.dart';
import 'home_expense_list.dart';
import '../components/controllers_.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  bool isLoginTrue = false;
  bool _passwordVisible = false;
  String? _loginError;

  final db = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget(
                        title: "LOGIN",
                        color: ActiveColor,
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                      Image.asset(
                        "assets/login.png",
                        height: 300,
                      ),
                      // Username
                      InputField(
                        hint: "Username",
                        icon: Icons.account_circle,
                        controller: username,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                      ),
                      // Password
                      InputField(
                        hint: "Password",
                        icon: Icons.lock,
                        controller: pass,
                        passwordInvisible: !_passwordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
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
                              if (_formKey.currentState!.validate()) {
                                Users? userDetails =
                                    await db.getUser(username.text);
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
                                    _loginError =
                                        "Username or password doesn't match";
                                  });
                                }
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
                              title: _loginError ??
                                  "Username or password is incorrect",
                              color: Colors.red,
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
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

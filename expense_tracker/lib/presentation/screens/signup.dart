import 'package:expense_tracker/data/services/db_helper.dart';
import 'package:expense_tracker/presentation/components/TextWidget.dart';
import 'package:expense_tracker/presentation/components/colors.dart';
import 'package:expense_tracker/presentation/components/textField.dart';
import 'package:expense_tracker/presentation/screens/login.dart';
import 'package:flutter/material.dart';
import '../../domain/models/user.dart';
import '../components/btn.dart';
import '../components/controllers_.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final db = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  signUp() async {
    if (_formKey.currentState!.validate()) {
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
      } else {
        // Handle error or show a message
      }
    }
  }

//Validate the password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one digit';
    } else if (!RegExp(r'[!@#\$%\^&\*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    } else if (RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Username should not contain capital letters';
    } else if (value == fullName.text) {
      return 'Username should not match Full Name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
                        color: ActiveColor,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InputField(
                            hint: "Full Name",
                            icon: Icons.person,
                            controller: fullName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Full Name is required';
                              }
                              return null;
                            },
                          ),
                          InputField(
                            hint: "Email",
                            icon: Icons.email,
                            controller: email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          InputField(
                            hint: "Username",
                            icon: Icons.account_circle,
                            controller: userName,
                            validator: _validateUsername,
                          ),
                          InputField(
                            hint: "Password",
                            icon: Icons.lock,
                            controller: password,
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
                            validator: _validatePassword,
                          ),
                          InputField(
                            hint: "Re-enter password",
                            icon: Icons.lock,
                            controller: confirmPass,
                            passwordInvisible: !_confirmPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _confirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _confirmPasswordVisible =
                                      !_confirmPasswordVisible;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm Password is required';
                              } else if (value != password.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Btn(
                            label: "SIGN UP",
                            press: signUp,
                            txtColor: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            backgroundColor: primaryColor,
                          ),
                        ],
                      ),
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
                              ),
                            );
                          },
                          child: textWidget(
                            title: "LOGIN",
                            color: ActiveColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

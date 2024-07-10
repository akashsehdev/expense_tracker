import 'package:flutter/material.dart';
import 'package:expense_tracker/data/models/user.dart';
import 'package:expense_tracker/data/provider/provider_.dart';
import 'package:expense_tracker/data/services/db_helper.dart';
import 'package:expense_tracker/presentation/components/TextWidget.dart';
import 'package:expense_tracker/presentation/components/btn.dart';
import 'package:expense_tracker/presentation/components/colors.dart';
import 'package:expense_tracker/presentation/components/textField.dart';
import 'package:expense_tracker/presentation/views/home.dart';
import 'package:expense_tracker/presentation/views/signup.dart';
import 'package:provider/provider.dart';
import '../components/controllers_.dart';
import 'profile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  bool isLoginTrue = false;

  final db = DatabaseHelper();
  //Login Method
  //we will take the value of text fields using controllers in order to verify whether details are correct or not

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
                fontWeight: FontWeight.w600),

            //Username
            InputField(
              hint: "Username",
              icon: Icons.account_circle,
              controller: username,
            ),

            //Password
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
                  onChanged: (value) => notifier.toggleCheck(),
                ),
              );
            }),

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
                    //If result is correct then go to profile or home
                    if (notifier.isChecked == true) {
                      //if i checked the remember me then setRemember me true,
                      //Login session become true
                      notifier.setRememberMe();
                    }
                    if (!mounted) return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => 
                          // const HomeScreen(),
                           Profile(
                            profile: userDetails,
                          ),
                        ));
                  } else {
                    //otherwise show the error message
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
            }),

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
                        ));
                  },
                  child: textWidget(
                    title: "SIGN UP",
                    color: ActiveColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),

            //Access denied message in case username and password is incorrect
            //By default it is hidden
            //When login is not true then display the message
            isLoginTrue
                ? textWidget(
                    title: "Username or password is incorrect",
                    color: Colors.red,
                  )
                : SizedBox()
          ],
        ),
      )),
    );
  }
}

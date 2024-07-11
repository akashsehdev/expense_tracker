import 'package:expense_tracker/presentation/components/TextWidget.dart';
import 'package:expense_tracker/presentation/components/colors.dart';
import 'package:expense_tracker/presentation/views/auth.dart';
import 'package:expense_tracker/presentation/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/user.dart';
import '../../data/provider/provider_.dart';
import '../../data/services/db_helper.dart';
import '../components/btn.dart';

class Profile extends StatelessWidget {
  final Users? profile;

  const Profile({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 25),
            child: profile != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // const CircleAvatar(
                      //   radius: 57,
                      //   // child: CircleAvatar(
                      //   //   backgroundImage: AssetImage(""),
                      //   //   radius: 55,
                      //   // ),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      textWidget(
                        title: profile!.fullName.toString(),
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textWidget(
                        title: profile!.email.toString(),
                        fontSize: 17,
                        color: Colors.grey,
                      ),

                      // button
                      // Btn(
                      //   label: "SIGN UP",
                      //   press: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => const SignupScreen(),
                      //       ),
                      //     );
                      //   },
                      //   txtColor: Colors.white,
                      //   fontSize: 20,
                      //   fontWeight: FontWeight.bold,
                      //   backgroundColor: primaryColor,
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      // Name, email and username
                      Container(
                        decoration: BoxDecoration(
                            color: listBgColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.person,
                                size: 30,
                              ),
                              title: textWidget(
                                title: profile!.fullName.toString(),
                                color: Colors.white,
                              ),
                              subtitle: Text("Full Name"),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.email,
                                size: 30,
                              ),
                              title: textWidget(
                                title: profile!.email.toString(),
                                color: Colors.white,
                              ),
                              subtitle: Text("Email"),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.account_circle,
                                size: 30,
                              ),
                              title: textWidget(
                                title: profile!.userName.toString(),
                                color: Colors.white,
                              ),
                              subtitle: Text("Username"),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer<UiProvider>(
                            builder: (context, UiProvider notifier, child) {
                              return Btn(
                                label: "SIGN OUT",
                                press: () {
                                  notifier.logout(context);
                                },
                                txtColor: bgColor,
                                fontWeight: FontWeight.bold,
                                backgroundColor: primaryColor,
                              );
                            },
                          ),
                          SizedBox(),
                          Btn(
                            label: "DELETE ACCOUNT",
                            press: () {
                              _showDeleteDialog(context);
                            },
                            txtColor: Colors.white,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      "No profile information available.",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text(
            'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () async {
              if (profile != null) {
                await _deleteAccount(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final db = DatabaseHelper();
    await db.deleteUser(profile!.userId!);
    Navigator.of(context).pop(); // Close the dialog
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (Route<dynamic> route) => false,
    );
  }
}

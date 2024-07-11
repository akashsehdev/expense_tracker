import 'package:expense_tracker/presentation/components/TextWidget.dart';
import 'package:expense_tracker/presentation/components/colors.dart';
import 'package:expense_tracker/presentation/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/user.dart';
import '../../data/provider/provider_.dart';
import '../components/btn.dart';

class Profile extends StatelessWidget {
  final Users? profile;
  const Profile({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 25),
            child: profile != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 57,
                        // child: CircleAvatar(
                        //   backgroundImage: AssetImage(""),
                        //   radius: 55,
                        // ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      textWidget(
                        title: profile!.fullName.toString() ?? "",
                        fontSize: 28,
                        color: primaryColor,
                      ),
                      textWidget(
                        title: profile!.email.toString() ?? "",
                        fontSize: 17,
                        color: Colors.grey,
                      ),

                      //button
                      Btn(
                        label: "SIGN UP",
                        press: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ));
                        },
                        txtColor: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        backgroundColor: primaryColor,
                      ),

                      //Name, email and username
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          size: 30,
                        ),
                        title: Text(profile!.fullName.toString() ?? ""),
                        subtitle: Text("Full Name"),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.email,
                          size: 30,
                        ),
                        title: Text(profile!.email.toString() ?? ""),
                        subtitle: Text("Email"),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.account_circle,
                          size: 30,
                        ),
                        title: Text(profile!.userName.toString() ?? ""),
                        subtitle: Text("Username"),
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
                                backgroundColor: primaryColor);
                          })
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
}

// import 'package:flutter/material.dart';
// import 'package:expense_tracker/presentation/components/TextWidget.dart';
// import 'package:expense_tracker/presentation/components/colors.dart';
// import 'package:expense_tracker/presentation/screens/auth.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import '../../data/services/noti_feature.dart';
// import '../../domain/models/user.dart';
// import '../../domain/provider/provider_.dart';
// import '../../data/services/db_helper.dart';
// import '../components/btn.dart';

// class Profile extends StatefulWidget {
//   final Users? profile;

//   const Profile({Key? key, this.profile}) : super(key: key);

//   @override
//   _ProfileState createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   TimeOfDay _selectedTime =
//       TimeOfDay(hour: 8, minute: 0); // Default reminder time

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 25),
//             child: widget.profile != null
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       textWidget(
//                         title: widget.profile!.fullName.toString(),
//                         fontSize: 35,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textWidget(
//                         title: widget.profile!.email.toString(),
//                         fontSize: 17,
//                         color: Colors.grey,
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       // Name, email and username
//                       Container(
//                         decoration: BoxDecoration(
//                             color: listBgColor,
//                             borderRadius: BorderRadius.circular(15)),
//                         child: Column(
//                           children: [
//                             ListTile(
//                               leading: Icon(
//                                 Icons.person,
//                                 size: 30,
//                               ),
//                               title: textWidget(
//                                 title: widget.profile!.fullName.toString(),
//                                 color: Colors.white,
//                               ),
//                               subtitle: Text("Full Name"),
//                             ),
//                             ListTile(
//                               leading: Icon(
//                                 Icons.email,
//                                 size: 30,
//                               ),
//                               title: textWidget(
//                                 title: widget.profile!.email.toString(),
//                                 color: Colors.white,
//                               ),
//                               subtitle: Text("Email"),
//                             ),
//                             ListTile(
//                               leading: Icon(
//                                 Icons.account_circle,
//                                 size: 30,
//                               ),
//                               title: textWidget(
//                                 title: widget.profile!.userName.toString(),
//                                 color: Colors.white,
//                               ),
//                               subtitle: Text("Username"),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       // Set Daily Reminder Time Button
//                       Btn(
//                           label: 'Set Daily Reminder Time',
//                           press: () {
//                             // DateTime(
//                             //   context,
//                             //   showTitleActions: true,
//                             //   onChanged: (date) => _selectedTime = date,
//                             //   onConfirm: (time) {},
//                             // );

//                             _pickReminderTime();
//                             _selectedTime;
//                           },
//                           txtColor: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           backgroundColor: bgColor),

//                       Btn(
//                           label: 'Schedule Notifications',
//                           press: () {
//                             print(timeOfDayToDateTime(_selectedTime));
//                             NotiFeature().scheduleDailyNotification(
//                                 title: "It's time to add your expenses",
//                                 body: '$timeOfDayToDateTime($_selectedTime)',
//                                 scheduleNotificationDateTime:
//                                     timeOfDayToDateTime(_selectedTime));
//                           },
//                           txtColor: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           backgroundColor: bgColor),
//                       SizedBox(height: 20),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Consumer<UiProvider>(
//                             builder: (context, UiProvider notifier, child) {
//                               return Btn(
//                                 label: "SIGN OUT",
//                                 press: () {
//                                   notifier.logout(context);
//                                 },
//                                 txtColor: bgColor,
//                                 fontWeight: FontWeight.bold,
//                                 backgroundColor: primaryColor,
//                               );
//                             },
//                           ),
//                           Btn(
//                             label: "DELETE ACCOUNT",
//                             press: () {
//                               _showDeleteDialog(context);
//                             },
//                             txtColor: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             backgroundColor: Colors.red,
//                           ),
//                         ],
//                       ),
//                     ],
//                   )
//                 : Center(
//                     child: Text(
//                       "No profile information available.",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showDeleteDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: backgroundColor,
//         title: textWidget(
//           title: 'Delete Account',
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//         ),
//         content: textWidget(
//           title:
//               'Are you sure you want to delete your account? This action cannot be undone.',
//           color: Colors.white,
//         ),
//         actions: [
//           TextButton(
//             child: textWidget(title: 'Cancel'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           TextButton(
//             child: textWidget(title: 'Delete'),
//             onPressed: () async {
//               if (widget.profile != null) {
//                 await _deleteAccount(context);
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _deleteAccount(BuildContext context) async {
//     final db = DatabaseHelper();
//     await db.deleteUser(widget.profile!.userId!);
//     Navigator.of(context).pop(); // Close the dialog
//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (context) => const AuthScreen()),
//       (Route<dynamic> route) => false,
//     );
//   }

//   DateTime timeOfDayToDateTime(TimeOfDay time) {
//     final now = DateTime.now();
//     return DateTime(now.year, now.month, now.day, time.hour, time.minute);
//   }

//   Future<void> _pickReminderTime() async {
//     DateTime convertedDateTime = timeOfDayToDateTime(_selectedTime);
//     final TimeOfDay? pickedTime = (await showTimePicker(
//       context: context,
//       initialTime: _selectedTime,
//     ));

//     if (pickedTime != null) {
//       setState(() {
//         _selectedTime = convertedDateTime as TimeOfDay;
//       });
//       // Schedule daily notification based on selected time
//       // NotificationService.showDailyNotification(context, _selectedTime);
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:expense_tracker/presentation/components/TextWidget.dart';
import 'package:expense_tracker/presentation/components/colors.dart';
import 'package:expense_tracker/presentation/screens/auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../data/services/noti_feature.dart';
import '../../domain/models/user.dart';
import '../../domain/provider/provider_.dart';
import '../../data/services/db_helper.dart';
import '../components/btn.dart';

class Profile extends StatefulWidget {
  final Users? profile;

  const Profile({Key? key, this.profile}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DateTime _selectedDateTime = DateTime.now(); // Default reminder time
  bool _isNotificationScheduled = false;

  @override
  void initState() {
    super.initState();
  }

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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: widget.profile != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      textWidget(
                        title: widget.profile!.fullName.toString(),
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textWidget(
                        title: widget.profile!.email.toString(),
                        fontSize: 17,
                        color: Colors.grey,
                      ),
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
                                title: widget.profile!.fullName.toString(),
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
                                title: widget.profile!.email.toString(),
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
                                title: widget.profile!.userName.toString(),
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
                      // Set Daily Reminder Time Button
                      // Btn(
                      //   label: 'Push notification only',
                      //   press: () {
                      //     NotiFeature().showNotification();
                      //   },
                      //   txtColor: Colors.black,
                      //   fontWeight: FontWeight.bold,
                      //   backgroundColor: bgColor,
                      // ),
                      Column(
                        children: [
                          Center(
                            child: Btn(
                              label: 'Set Daily Notification',
                              press: () {
                                NotiFeature().scheduleDailyNotificationWithTime(
                                  "Scheduled Notification",
                                  "Don't forget to add your expenses",
                                );
                              },
                              txtColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              backgroundColor: bgColor,
                            ),
                          ),
                          Btn(
                            label: 'Stop Daily Notification',
                            press: () {
                              NotiFeature().stopDailyNotificationWithTime();
                            },
                            txtColor: Colors.white,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.red,
                          ),
                        ],
                      ),
                      Btn(
                        label: 'Set Daily Reminder with Date & Time',
                        press: () {
                          _pickReminderDateTime();
                        },
                        txtColor: Colors.black,
                        fontWeight: FontWeight.bold,
                        backgroundColor: bgColor,
                      ),

                      // Toggle Button for Scheduled Notifications
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Scheduled Notifications',
                            style: TextStyle(color: Colors.white),
                          ),
                          Switch(
                            value: _isNotificationScheduled,
                            onChanged: (value) {
                              setState(() {
                                _isNotificationScheduled = value;
                                if (_isNotificationScheduled) {
                                  _scheduleNotification();
                                } else {
                                  _cancelNotification();
                                }
                              });
                            },
                            activeColor: primaryColor,
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
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
        backgroundColor: backgroundColor,
        title: textWidget(
          title: 'Delete Account',
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        content: textWidget(
          title:
              'Are you sure you want to delete your account? This action cannot be undone.',
          color: Colors.white,
        ),
        actions: [
          TextButton(
            child: textWidget(title: 'Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: textWidget(title: 'Delete'),
            onPressed: () async {
              if (widget.profile != null) {
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
    await db.deleteUser(widget.profile!.userId!);
    Navigator.of(context).pop(); // Close the dialog
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _pickReminderDateTime() async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _scheduleNotification() {
    // Schedule notification logic here
    NotiFeature().scheduleNotification(
      id: 0,
      title: "Reminder with date and time",
      body: "Don't forget to add your expenses today!",
      scheduleNotificationDateTime: _selectedDateTime,
    );
  }

  void _cancelNotification() {
    // Cancel notification logic here
    // NotiFeature().cancelScheduledNotification(id: 0); // Implement cancellation if needed
  }
}

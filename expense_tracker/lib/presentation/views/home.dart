import 'package:expense_tracker/data/provider/provider_.dart';
import 'package:expense_tracker/presentation/components/btn.dart';
import 'package:expense_tracker/presentation/components/colors.dart';
import 'package:expense_tracker/presentation/views/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/user.dart';
import '../../data/services/db_helper.dart';
import '../components/controllers_.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DatabaseHelper();

  late String _amount;
  late String _description;
  late DateTime _date;

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Amount',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _amount = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    onChanged: (value) {
                      _description = value;
                    },
                  ),
                  // ListTile(
                  //   title: Text(_date == null
                  //       ? 'Select Date'
                  //       : 'Date: ${_date.toLocal()}'.split(' ')[0]),
                  //   trailing: Icon(Icons.calendar_today),
                  //   onTap: () {
                  //     DatePicker.showDatePicker(
                  //       context,
                  //       showTitleActions: true,
                  //       onConfirm: (date) {
                  //         setState(() {
                  //           _date = date;
                  //         });
                  //       },
                  //       currentTime: DateTime.now(),
                  //       locale: LocaleType.en,
                  //     );
                  //   },
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle submit logic here
                      print('Amount: $_amount');
                      print('Description: $_description');
                      print('Date: $_date');
                      Navigator.pop(context);
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Center(
          child: Column(
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
              }),
              Btn(
                  label: "Profile",
                  press: () async {
                    Users? userDetails = await db.getUser(username.text);
                    Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(
                            profile: userDetails!,
                          ),
                        ));
                  },
                  txtColor: Colors.white,
                  fontWeight: FontWeight.bold,
                  backgroundColor: primaryColor),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 80.0,
          width: 80.0,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              tooltip: 'Add Expenses',
              child: Icon(Icons.add),
              onPressed: () {
                _showBottomSheet(context);
              },
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()));
                  },
                  icon: Icon(
                    Icons.person_rounded,
                    size: 30,
                  ))
            ],
          ),
        ));
  }
}

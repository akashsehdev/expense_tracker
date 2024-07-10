// import 'package:flutter/material.dart';
// import 'package:expense_tracker/data/services/db_helper.dart';

// import 'models/user.dart'; // Assuming DatabaseService is defined here

// class AuthProvider with ChangeNotifier {
//   DatabaseService _dbHelper = DatabaseService();
//   late int _userId;

//   int get userId => _userId;

//   Future<bool> login(String username, String password) async {
//     var user = await _dbHelper.getUser(username, password);
//     if (user != null) {
//       _userId = user.id!; // Assuming 'id' is the field in User model
//       notifyListeners();
//       return true;
//     }
//     return false;
//   }

//   Future<bool> signup(String username, String password) async {
//     var userId = await _dbHelper.insertUser(User(username: username, password: password));
//     if (userId != null) {
//       _userId = userId;
//       notifyListeners();
//       return true;
//     }
//     return false;
//   }

//   void logout() {
//     _userId ;
//     notifyListeners();
//   }
// }

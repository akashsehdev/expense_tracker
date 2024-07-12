import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/screens/login.dart';
import '../models/user.dart';

class UiProvider extends ChangeNotifier {
  bool _isChecked = false;
  bool get isChecked => _isChecked;

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  // late SharedPreferences storage;

  //Method to check and uncheck remember me
  //we need to do it using provider state management

  toggleCheck() {
    _isChecked = !_isChecked;
    notifyListeners();
  }

  //When login is successful, then we will true the value to remember our login session
  //
  setRememberMe() async {
    _rememberMe = true;
    final SharedPreferences storage = await SharedPreferences.getInstance();

    //We store the value in secure storage to be remembered
    storage.setBool("rememberMe", _rememberMe);
    notifyListeners();
  }

  //Set rememberMe value to false
  logout(context) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    _rememberMe = false;
    storage.setBool("rememberMe", _rememberMe);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));

    notifyListeners();
  }

  //Init secure storage
  initStorage() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    final SharedPreferences storage = await SharedPreferences.getInstance();
    _rememberMe = storage.getBool("rememberMe") ?? false;
    notifyListeners();
  }
}

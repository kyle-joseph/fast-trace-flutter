import 'package:FastTrace/models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  SharedPreferences _userData;
  // bool alreadyLoggedIn = false;
  var _user = User();

  AppState() {
    checkLoggedIn();
  }

  User get currentUser => _user;

  void setUser(dynamic user) {
    _user = user;
    notifyListeners();
  }

  void checkLoggedIn() async {
    _userData = await SharedPreferences.getInstance();
    if (_userData.containsKey('email') && _userData.containsKey('company')) {
      setUser(User(
          email: _userData.getString('email'),
          company: _userData.getString('company')));
    }
  }
}

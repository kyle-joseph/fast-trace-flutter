import 'package:flutter/material.dart';
import 'package:FastTrace/screens/auth/login_screen.dart';
import 'package:FastTrace/screens/auth/signup_screen.dart';
class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  bool showSignIn = true;

  void toggleView(){
    setState(() => showSignIn = !showSignIn);
  }
  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginPage(toggleView:  toggleView);
    } else {
      return SignupPage(toggleView:  toggleView);
    }
  }
}
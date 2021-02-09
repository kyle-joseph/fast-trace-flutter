import 'package:FastTrace/State/appstate.dart';
import 'package:FastTrace/screens/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:FastTrace/screens/home/body.dart';
import 'package:FastTrace/screens/drawer.dart';
import 'package:FastTrace/screens/customappbar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String active = "home";
    final state = Provider.of<AppState>(context);

    if (state.currentUser.email == "none" &&
        state.currentUser.company == "none") {
      return Auth();
    }

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppbar(
          title: "",
          color: Color(0xff5253ED),
        ),
        body: Body(),
        drawer: CustomDrawer(active: active),
      ),
    );
  }
}

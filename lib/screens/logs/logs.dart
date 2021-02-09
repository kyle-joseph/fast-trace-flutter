import 'package:flutter/material.dart';
import 'package:FastTrace/screens/logs/body.dart';
import 'package:FastTrace/screens/drawer.dart';
import 'package:FastTrace/screens/customappbar.dart';

class LogsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String active = "logs";
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppbar(
          title: "Logs",
          color: Color(0xff5253ED),
        ),
        body: Body(),
        drawer: CustomDrawer(active: active),
      ),
    );
  }
}

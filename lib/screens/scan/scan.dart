import 'package:flutter/material.dart';
import 'package:FastTrace/screens/scan/body.dart';
import 'package:FastTrace/screens/drawer.dart';
import 'package:FastTrace/screens/customappbar.dart';

class ScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String active = "scan";
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppbar(
          title: "Scan QR Code",
          color: Color(0xff5253ED),
        ),
        body: Body(),
        drawer: CustomDrawer(active: active),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xff5253ED),
        body: Center(
          child: Container(
            child: SpinKitDoubleBounce(
              color: Colors.white,
              size: 100.0,
            ),
          ),
        ),
      ),
    );
  }
}

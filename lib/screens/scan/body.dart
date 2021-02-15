import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _scanBarcode = 'Unknown';
  String error = '';

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    if (_scanBarcode != '-1') {
      List log = qrDataToList(_scanBarcode);
      if (log.length == 8) {
        await Navigator.pushNamed(context, '/scanned', arguments: log);
        setState(() => error = '');
      } else {
        setState(() => error = 'Invalid QR Code');
        Toast.show(error, context, duration: 5, gravity: Toast.BOTTOM);
      }
    }
  }

  int countAsterisk(String log) {
    int count = 0;
    for (int i = 0; i < log.length; i++) {
      if (log[i] == '*') {
        count++;
      }
    }
    return count;
  }

  List qrDataToList(String log) {
    print(countAsterisk(log));
    if (countAsterisk(log) == 5) {
      List convertLog = log.split('*');
      DateTime datetime = DateTime.now();
      convertLog.add(DateFormat.yMd().format(datetime));
      convertLog.add(DateFormat.Hm().format(datetime));

      return convertLog;
    }
    return [];
  }

  //See assets/images for a sample qrcode containing firsname*lastname*address*birtdate
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.1),
              child: Image.asset(
                'assets/images/qr.jpg',
                filterQuality: FilterQuality.high,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            // Container(
            //   padding: EdgeInsets.symmetric(
            //     vertical: 5,
            //   ),
            //   child: Text(
            //     error,
            //     style: TextStyle(
            //       color: Colors.redAccent,
            //     ),
            //   ),
            // ),
            Container(
              height: 50,
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                color: Colors.white,
                onPressed: () => scanQR(),
                icon: Icon(
                  Icons.qr_code,
                  size: 40,
                  color: Color(0xff5253ED),
                ),
                label: Text(
                  "Scan Now",
                  style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                      color: Color(0xff5253ED),
                      fontWeight: FontWeight.w800,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

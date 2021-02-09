import 'package:FastTrace/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:FastTrace/services/customerLogs.dart';
import 'package:FastTrace/State/appstate.dart';
import 'package:provider/provider.dart';
import 'package:FastTrace/services/connection.dart';
import 'package:toast/toast.dart';

class ScannedQR extends StatefulWidget {
  @override
  _ScannedQRState createState() => _ScannedQRState();
}

class _ScannedQRState extends State<ScannedQR> {
  final _formKey = GlobalKey<FormState>();
  final Logs _logs = Logs();
  bool loading = false;

  String temperature = '';

  //Check if Temperature entered is numeric
  bool isNumeric(String temp) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
    return numericRegex.hasMatch(temp);
  }

  Widget rowData(String title, String data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.nunito(
                textStyle: TextStyle(
                  color: Color(0xff5253ED),
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              data,
              style: GoogleFonts.nunito(
                textStyle: TextStyle(
                  color: Color(0xff5253ED),
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List passedData = ModalRoute.of(context).settings.arguments;
    final user = Provider.of<AppState>(context).currentUser;

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Save Log"),
              backgroundColor: Color(0xff5253ED),
            ),
            body: Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      rowData("Firstname: ", passedData[0]),
                      rowData("Lastname: ", passedData[1]),
                      rowData("Address: ", passedData[2]),
                      rowData("Birthdate: ", passedData[3]),
                      rowData("Contact #: ", passedData[4]),
                      rowData("Date: ", passedData[5]),
                      rowData("Time: ", passedData[6]),
                      Form(
                        key: _formKey,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Column(children: [
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Enter Temperature',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter temperature';
                                } else if (!isNumeric(value)) {
                                  return 'Please enter numbers only';
                                }
                                return null;
                              },
                              onChanged: (val) => temperature = val,
                            )
                          ]),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              child: RaisedButton(
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  color: Color(0xFFF83447),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ),
                            SizedBox(
                              child: RaisedButton(
                                  child: Text(
                                    'Save',
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  color: Color(0xFF5253ED),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      bool connection =
                                          await Connection().checkConnection();

                                      //check if there is internet access
                                      if (connection) {
                                        setState(() => loading = true);
                                        bool logAdded = await _logs.addLogs(
                                            passedData,
                                            double.parse(temperature)
                                                .toStringAsFixed(1),
                                            user.company);
                                        if (logAdded) {
                                          setState(() => loading = false);
                                          Toast.show(
                                              "Customer Log Added", context,
                                              duration: 5,
                                              gravity: Toast.BOTTOM);
                                          Navigator.pop(context);
                                        }
                                      } else {
                                        Toast.show(
                                            "No Internet Connection", context,
                                            duration: 5, gravity: Toast.BOTTOM);
                                      }
                                    }
                                  }),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

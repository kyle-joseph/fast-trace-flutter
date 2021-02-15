import 'package:FastTrace/State/appstate.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:FastTrace/services/customerLogs.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  DateTime _fromDate = DateTime.now();
  List customerLogs = [];
  Logs _logs = Logs();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  fetchLogs() async {
    setState(() => loading = true);
    final user = Provider.of<AppState>(context, listen: false).currentUser;
    dynamic logs = await _logs.getLogs(numericDate, user.company);
    setState(() => loading = false);
    setState(() => customerLogs = logs);
  }

  String get wordedDate {
    return DateFormat.yMMMd().format(_fromDate);
  }

  String get numericDate {
    return DateFormat.yMd().format(_fromDate);
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _fromDate) {
      setState(() => _fromDate = picked);
      fetchLogs();
    }
  }

  Widget getLog(int idx) {
    List log = customerLogs;
    return ListTile(
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            rowData("Name:",
                "${log[idx].data()['firstname']} ${log[idx].data()['lastname']}"),
            rowData("Address:", log[idx].data()['address']),
            rowData("Gender:", log[idx].data()['gender']),
            rowData("Age:", log[idx].data()['age']),
            rowData("Contact #:", log[idx].data()['contact_num']),
            rowData("Date:", log[idx].data()['date']),
            rowData("Time:", log[idx].data()['time']),
          ],
        ),
      ),
    );
  }

  Widget rowData(String title, String data) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: GoogleFonts.nunito(
                textStyle: TextStyle(
                  color: Color(0xff5253ED),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              data,
              style: GoogleFonts.nunito(
                textStyle: TextStyle(
                  color: Color(0xff5253ED),
                  fontWeight: FontWeight.normal,
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
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffECECEC),
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xff5253ED),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  wordedDate,
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.date_range_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    _showDatePicker();
                  },
                )
              ],
            ),
          ),
          loading
              ? Expanded(
                  child: Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    child: ListView.builder(
                      itemCount: customerLogs.length,
                      itemBuilder: (BuildContext context, int idx) {
                        return getLog(idx);
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

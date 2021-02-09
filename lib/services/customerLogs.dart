import 'package:cloud_firestore/cloud_firestore.dart';

class Logs {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference logs = FirebaseFirestore.instance.collection('logs');

  //get logs by date and establishment
  getLogs(String date, String company) async {
    List custLogs = [];
    await logs
        .where('date', isEqualTo: date)
        .where('establishment', isEqualTo: company)
        .get()
        .then((res) {
      if (res.docs.isNotEmpty) {
        custLogs = res.docs;
      }
    }).catchError((error) => print(error));

    return custLogs;
  }

  //add customer logs to database
  addLogs(List log, String temperature, String company) async {
    bool logAdded = false;
    await logs.add({
      'firstname': log[0],
      'lastname': log[1],
      'address': log[2],
      'birthdate': log[3],
      'contact_num': log[4],
      'date': log[5],
      'time': log[6],
      'temperature': temperature,
      'establishment': company,
    }).then((value) {
      logAdded = true;
    }).catchError((error) => print(error));
    return logAdded;
  }
}

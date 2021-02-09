import 'package:FastTrace/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authenticate {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  //Create user instance with email and company name
  User user(String email, String company) {
    return User(email: email, company: company);
  }

  getUserData(String email) {
    return users.where('email', isEqualTo: email).get();
  }

  //Validate Email if exists in Database
  emailExists(String email) async {
    dynamic exists = false;

    await getUserData(email).then((res) {
      if (res.docs.isNotEmpty) {
        print(res.docs[0].data()['email']);
        exists = true;
      }
    }).catchError((error) => print(error));
    return exists;
  }

  //Login User
  loginUser(String email, String password) async {
    bool authenticated = false;
    String company = '';
    if (await emailExists(email)) {
      await getUserData(email).then((QuerySnapshot res) {
        if (res.docs.isNotEmpty) {
          if (res.docs[0].data()['password'] == password) {
            authenticated = true;
            company = res.docs[0].data()['company_name'];
          }
        }
      }).catchError((error) => print(error));

      if (authenticated) {
        return user(email, company);
      }
      return null;
    }
  }

  //Register User
  registerUser(String company, String email, String password) async {
    bool userAdded = false;
    await users
        .add({'company_name': company, 'email': email, 'password': password})
        .then((value) => userAdded = true)
        .catchError((error) => print("Failed to add user: $error"));
    if (userAdded) {
      return user(email, company);
    }
    return null;
  }

  //Forgot Password

}

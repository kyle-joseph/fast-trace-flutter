import 'package:FastTrace/State/appstate.dart';
import 'package:FastTrace/screens/loading.dart';
import 'package:FastTrace/services/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:FastTrace/services/connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SignupPage extends StatefulWidget {
  final Function toggleView;
  SignupPage({this.toggleView});

  @override
  State<StatefulWidget> createState() => new _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _signupFormKey = GlobalKey<FormState>();
  final Authenticate _auth = Authenticate();
  bool loading = false;

  String company = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
                child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/images/background1.png"),
                    fit: BoxFit.fill,
                  )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Form(
                    key: _signupFormKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[100]))),
                                child: TextFormField(
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter Company Name' : null,
                                  onChanged: (val) {
                                    setState(() => company = val);
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Company Name",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[100]))),
                                child: TextFormField(
                                  validator: (val) {
                                    if (val.isNotEmpty) {
                                      bool emailValid = RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val);
                                      if (emailValid) {
                                        return null;
                                      }
                                      return 'Invalid email';
                                    }
                                    return 'Please enter email';
                                  },
                                  onChanged: (val) {
                                    setState(() => email = val);
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[100]))),
                                child: TextFormField(
                                  validator: (val) => val.length < 8
                                      ? 'Password should be at least 8 chars'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => password = val);
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[100]))),
                                child: TextFormField(
                                  validator: (val) {
                                    if (val != password) {
                                      return "Password doesn't match";
                                    }
                                    return null;
                                  },
                                  onChanged: (val) {
                                    setState(() => confirmPassword = val);
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Confirm Password",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'By clicking "Signup", you are agree to the terms of service and privacy policy',
                          style: TextStyle(
                              color: Color.fromRGBO(143, 148, 251, 1)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 50,
                            width: 300,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: RaisedButton(
                              color: Colors.purple[280],
                              child: Text(
                                'Signup',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(143, 100, 251, .8)),
                              ),
                              onPressed: () async {
                                //Signup

                                if (_signupFormKey.currentState.validate()) {
                                  bool connection =
                                      await Connection().checkConnection();
                                  if (connection) {
                                    setState(() => loading = true);

                                    SharedPreferences _login =
                                        await SharedPreferences.getInstance();

                                    bool emailExist =
                                        await _auth.emailExists(email);

                                    if (!emailExist) {
                                      dynamic user = await _auth.registerUser(
                                          company, email, password);

                                      if (user != null) {
                                        Provider.of<AppState>(context,
                                                listen: false)
                                            .setUser(user);

                                        _login.setString('email', user.email);
                                        _login.setString(
                                            'company', user.company);
                                        setState(() => error = '');
                                        setState(() => loading = false);
                                      } else {
                                        setState(() => error =
                                            'Failed to register. Please try again.');
                                        setState(() => loading = false);
                                      }
                                    } else {
                                      setState(
                                          () => error = 'Email already exist');
                                      setState(() => loading = false);
                                    }
                                  } else {
                                    Toast.show(
                                        "No Internet Connection", context,
                                        duration: 5, gravity: Toast.TOP);
                                  }
                                }
                              },
                            )),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          child: Text(
                            error,
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                        Container(
                            child: Row(
                          children: <Widget>[
                            Text(
                              'Already Registered?',
                              style: TextStyle(
                                  color: Color.fromRGBO(143, 148, 251, .8)),
                            ),
                            FlatButton(
                              textColor: Colors.blue,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(143, 148, 251, .8),
                                ),
                              ),
                              onPressed: () {
                                //signup screen
                                widget.toggleView();
                              },
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          )));
  }
}

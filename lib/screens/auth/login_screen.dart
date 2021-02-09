import 'package:FastTrace/services/authenticate.dart';
import 'package:FastTrace/State/appstate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:FastTrace/services/connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../loading.dart';

class LoginPage extends StatefulWidget {
  final Function toggleView;
  LoginPage({this.toggleView});

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Authenticate _auth = Authenticate();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //error message
  String error = '';

  //will hold the value of email and password
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/background1.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(143, 148, 251, .2),
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
                                            TextStyle(color: Colors.grey[400]),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                    child: TextFormField(
                                      obscureText: true,
                                      validator: (val) => val.length < 8
                                          ? 'Password should be at least 8 chars'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => password = val);
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400])),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                //forgot password screen
                              },
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                    color: Color.fromRGBO(143, 148, 251, .8)),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 300,
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: RaisedButton(
                                color: Colors.purple[280],
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(143, 148, 251, .8)),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    bool connection =
                                        await Connection().checkConnection();

                                    if (connection) {
                                      setState(() => loading = true);
                                      SharedPreferences _login =
                                          await SharedPreferences.getInstance();

                                      dynamic user = await _auth.loginUser(
                                          email, password);

                                      if (user != null) {
                                        Provider.of<AppState>(context,
                                                listen: false)
                                            .setUser(user);

                                        _login.setString('email', user.email);
                                        _login.setString(
                                            'company', user.company);

                                        setState(() => error = '');
                                        setState(() => loading = false);

                                        // Navigator.popAndPushNamed(context, '/');
                                      } else {
                                        setState(() => error =
                                            'Invalid email or password');
                                        setState(() => loading = false);
                                      }
                                    } else {
                                      Toast.show(
                                          "No Internet Connection", context,
                                          duration: 5, gravity: Toast.TOP);
                                    }
                                  }
                                },
                              ),
                            ),
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
                                  'Does not have account?',
                                  style: TextStyle(
                                      color: Color.fromRGBO(143, 148, 251, .8)),
                                ),
                                FlatButton(
                                  textColor: Colors.blue,
                                  child: Text(
                                    'Signup',
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
                      ))
                ]),
              ),
            ),
          );
  }
}

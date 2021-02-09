import 'package:FastTrace/State/appstate.dart';
import 'package:FastTrace/screens/home/home.dart';
import 'package:FastTrace/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:FastTrace/screens/logs/logs.dart';
import 'package:FastTrace/screens/scan/scan.dart';
import 'package:FastTrace/screens/scan/scanned.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Container(
                  child: Text('Something went wrong...'),
                ),
              ),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Main();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

class Main extends StatelessWidget {
  final appTitle = 'Fast Trace';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: appTitle,
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/logs': (context) => LogsPage(),
          '/scan': (context) => ScanPage(),
          '/scanned': (context) => ScannedQR(),
        },
      ),
    );
  }
}

class Home {}

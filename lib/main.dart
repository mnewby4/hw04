import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'loginTabs.dart';
/*
  1. Any splash screen
  2. User registration + login (firebase auth + cloud firestore)
    - reg: unique user id, first, last, user role, registration datetime
    - auth: email + password
    auth pg shld have first, last, user role, email, pass
  3. after: ordered list of all msg boards name w img icon = each board (hardcoded?)
  4. icon in menu bar [of scaffold area] to open sliding nav menu
    - msg boards
    - profile [user can CHANGE this info!!]
    - settings: logout, change login info w personal info 
  5. new msg board -> list of all msgs posted in that convo 
    - every msg: datetime, msg, user/displayname
    - board name = titlebar
    - msgs = displayed IN REAL TIME
*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      home: MyHomePage(title: 'Firebase Auth Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: _isLoading ? SplashScreen() : LoginTabs(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 250),
            Text(
              "ChattyRooms", 
              style: TextStyle(
                fontSize: 50,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 300,
              child: Image.asset('assets/images/chaticon.png'),
            ),
            Text(
              "Loading, please wait...",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
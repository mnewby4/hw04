import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'home.dart';

/*
  User registration + login (firebase auth + cloud firestore)
    - reg: unique user id, first, last, user role, registration datetime
    - auth: email + password
    auth pg shld have first, last, user role, email, pass
 */

class LoginTabs extends StatefulWidget {
  LoginTabs({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginTabs> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.pages)),
                Tab(icon: Icon(Icons.email)),
              ],
            ),
            title: const Text('ChattyRooms'),
          ),
          body: TabBarView(
            children: [
              RegisterEmailSection(auth: _auth),
              EmailPasswordForm(auth: _auth),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterEmailSection extends StatefulWidget {
  RegisterEmailSection({Key? key, required this.auth}) : super(key: key);
  final FirebaseAuth auth;

  @override
  _RegisterEmailSectionState createState() => _RegisterEmailSectionState();
}

class _RegisterEmailSectionState extends State<RegisterEmailSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success = false;
  bool _initialState = true;
  String? _userEmail;

  void _register() async {
    try {
      var cred = await widget.auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() {
        _success = true;
        _userEmail = _emailController.text;
        _initialState = false;
      });

      final user = cred.user!;
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

      await userDoc.set({
        'id': user.uid,
        'firstName': _firstController.text,
        'lastName': _lastController.text, 
        'role': _roleController.text, 
        'date': FieldValue.serverTimestamp(),
        'email': _emailController.text,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(auth: widget.auth)),
      );
    } catch (e) {
      setState(() {
        _success = false;
        _initialState = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text('Register with a new account'),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
          //FIRST NAME 
          TextFormField(
            controller: _firstController,
            decoration: InputDecoration(labelText: 'First Name'),
            validator: (value) {
              if (value?.isEmpty??true) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          //LAST NAME
          TextFormField(
            controller: _lastController,
            decoration: InputDecoration(labelText: 'Last Name'),
            validator: (value) {
              if (value?.isEmpty??true) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          //USER ROLE
          TextFormField(
            controller: _roleController,
            decoration: InputDecoration(labelText: 'User Role'),
            validator: (value) {
              if (value?.isEmpty??true) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          //Email textform
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value?.isEmpty??true) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          //Password textform
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            validator: (value) {
              if(value?.isEmpty??true) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          //Submit Button
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _register();
                }
              },
              child: Text('Submit'),
            ),
          ),
          //Error Message
          Container(
            alignment: Alignment.center,
            child: Text(
              _initialState
                  ? ''
              : _success
                  ? 'Successfully registered $_userEmail'
                  : 'Registration failed',
              style: TextStyle(color: _success ? Colors.green : Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class EmailPasswordForm extends StatefulWidget {
  EmailPasswordForm({Key? key, required this.auth}) : super(key: key);
  final FirebaseAuth auth;

  @override
  _EmailPasswordFormState createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success = false;
  bool _initialState = true;
  String _userEmail ='';

  void _signInWithEmailAndPassword() async {
    try {
      await widget.auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() {
        _success = true;
        _userEmail = _emailController.text;
        _initialState = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(auth: widget.auth)),
      );
    } catch (e) {
      setState(() {
        _success = false;
        _initialState = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text('Sign in with an existing account'),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value?.isEmpty??true) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            validator: (value) {
              if (value?.isEmpty??true) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _signInWithEmailAndPassword();
                }
              },
              child: Text('Submit'),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _initialState
                  ? ''
                  : _success
                  ? 'Successfully signed in $_userEmail'
                  : 'Sign in failed',
              style: TextStyle(color: _success ? Colors.green : Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'ui/customerSigin.dart';
import 'ui/customerSignUp.dart';
import 'ui/registration.dart';
import 'ui/customerLoginPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PII Tracker - COVID Edition", home: MyHomePage(),
      // routes for naviagting to different pages
      routes: {
        // page route for login/registration page
        '/registration': (context) => Registration(),
        '/customerRegister': (context) => CustomerSignUp(),
        '/customerSignIn': (context) => CustomerSignIn(),
        '/customerLoginPage': (context) => CustomerLoginPage(),
      },
    );
  }
}

// route : /  (this is the default home page)
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // initstate invoked at the begining when the app is rebuilt
  void initState() {
    super.initState();

    // FIREBASE INITIALIZATION
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });

    //after delay of 2 seconds it will push to registration.dart in pages folder
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.pushReplacementNamed(context, '/registration');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PII Tracker"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("WELCOME"),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import './pages/registration.dart';

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
    //after delay of 2 seconds it will push to registration.dart in pages folder
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.pushNamed(context, '/registration');
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

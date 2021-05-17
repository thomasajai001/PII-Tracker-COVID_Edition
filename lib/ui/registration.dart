import 'package:flutter/material.dart';
import './login.dart';
import './signup.dart';

// page for user sign in and sign up

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

// object of tab controller
TabController object;

class _RegistrationState extends State<Registration>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // initializing  tab controller object
    object = TabController(length: 2, vsync: this);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        backgroundColor: Colors.amber[700],
      ),
      body: SafeArea(
        child: TabBarView(
          controller: object,
          children: [
            SignUp(), //present in /pages/login.dart
            Login(), //present in /pages/signup.dart
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: Colors.blue[500],
        child: TabBar(
          indicatorColor: Colors.blue[900],

          overlayColor: MaterialStateProperty.all<Color>(
            Colors.blueAccent,
          ), //onhovering color

          labelColor: Colors.white, // icon color

          controller: object,

          tabs: [
            Tab(
              child: Text(
                "Customer",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Shopkeeper",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

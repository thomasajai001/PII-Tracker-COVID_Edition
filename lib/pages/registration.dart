import 'package:flutter/material.dart';
import 'package:pii_tracker_covid_edition/pages/login.dart';
import 'package:pii_tracker_covid_edition/pages/signup.dart';

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
      appBar: AppBar(),
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
        color: Colors.blue[400],
        child: TabBar(
          indicatorColor: Colors.red,

          overlayColor: MaterialStateProperty.all<Color>(
            Color(0xFF51ff0d),
          ), //onhovering color

          labelColor: Colors.black, // icon color

          controller: object,

          tabs: [
            Tab(
              child: Text("Customer"),
            ),
            Tab(
              child: Text("Shopkeeper"),
            ),
          ],
        ),
      ),
    );
  }
}

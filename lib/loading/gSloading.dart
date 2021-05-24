import 'package:flutter/material.dart';

class GSLoginLoading extends StatefulWidget {
  @override
  _GSLoginLoadingState createState() => _GSLoginLoadingState();
}

class _GSLoginLoadingState extends State<GSLoginLoading> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/shopkeeperGoogleHomePage');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: new Image.asset(
        "assets/5.gif",
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}

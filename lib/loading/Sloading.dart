import 'package:flutter/material.dart';

class SLoginLoading extends StatefulWidget {
  @override
  _SLoginLoadingState createState() => _SLoginLoadingState();
}

class _SLoginLoadingState extends State<SLoginLoading> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/shopkeeperHomePage');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: new Image.asset(
        "assets/6.gif",
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}

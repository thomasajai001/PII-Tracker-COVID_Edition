import 'package:flutter/material.dart';

class CLoginLoading extends StatefulWidget {
  @override
  _CLoginLoadingState createState() => _CLoginLoadingState();
}

class _CLoginLoadingState extends State<CLoginLoading> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/customerHomePage');
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

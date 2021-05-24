import 'package:flutter/material.dart';

class GCLoginLoading extends StatefulWidget {
  @override
  _GCLoginLoadingState createState() => _GCLoginLoadingState();
}

class _GCLoginLoadingState extends State<GCLoginLoading> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/customerGoogleHomePage');
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

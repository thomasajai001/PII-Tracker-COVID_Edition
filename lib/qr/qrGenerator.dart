import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QrGenerator extends StatefulWidget {
  @override
  _QrGeneratorState createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  String id = "";
  String datas = " ";

  @override
  void initState() {
    super.initState();
    User shopkeeper = FirebaseAuth.instance.currentUser;
    id = shopkeeper.uid;
    setState(() {
      datas = id;
      print("Success");
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  QrImage(
                    data: datas,
                    version: QrVersions.auto,
                    size: 320,
                    gapless: false,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

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
    return Dialog(
      insetAnimationCurve: Curves.decelerate,
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        height: 368,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              data: datas,
              version: QrVersions.auto,
              size: 320,
              gapless: true,
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Done!',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

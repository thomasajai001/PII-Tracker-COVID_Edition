import 'package:flutter/material.dart';
import '../auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class CustomerLoginPage extends StatefulWidget {
  @override
  _CustomerLoginPageState createState() => _CustomerLoginPageState();
}

bool dataFilled = false;
Map data = {};

class _CustomerLoginPageState extends State<CustomerLoginPage> {
  TextEditingController nameC = TextEditingController();
  TextEditingController bodyC = TextEditingController();

  String name = " ";
  String body = " ";
  String n = "";
  String b = "";
  void add() {
    name = nameC.text.toString();
    body = bodyC.text.toString();
    CollectionReference users = firestore.collection('users');
    users
        .doc(data['id'])
        .set({'name': name, 'body': body}).then((value) => print("added"));
    setState(() {
      dataFilled = true;
    });
  }

  @override
  void initState() {
    super.initState();
    firestore.collection("users").doc(data['id']).get().then((doc) {
      if (doc.exists) {
        setState(() {
          print(doc.get('name'));
          // n = doc.data() as String;
          // print(n);
          // b = doc['body'];
          dataFilled = true;
        });
      } else {
        // doc.data() will be undefined in this case
        setState(() {
          dataFilled = false;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    setState(() {
      data = ModalRoute.of(context).settings.arguments;
      // firestore.collection("users").doc(data['id']).get().then((doc) {
      //   if (doc.exists) {
      //     setState(() {
      //       print(doc.get('name'));
      //       // n = doc['name'];
      //       // b = doc['body'];
      //       dataFilled = true;
      //     });
      //   } else {
      //     // doc.data() will be undefined in this case
      //     setState(() {
      //       dataFilled = false;
      //     });
      //   }
      // });
    });

    return (!dataFilled)
        ? Scaffold(
            appBar: AppBar(
              title: Text("Customer page"),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "name",
                      ),
                      controller: nameC,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "password",
                      ),
                      controller: bodyC,
                    ),
                    ElevatedButton(
                      onPressed: add,
                      child: Text("Add"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        customerSignout();
                        Navigator.pushNamed(context, '/registration');
                      },
                      child: Text("logout"),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Customer page"),
              centerTitle: true,
            ),
            body: Text(data['id']),
          );
  }
}

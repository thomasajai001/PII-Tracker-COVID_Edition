import 'package:flutter/material.dart';
import '../auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class CustomerLoginPage extends StatefulWidget {
  @override
  _CustomerLoginPageState createState() => _CustomerLoginPageState();
}

bool dataFilled = false;
Map Userid = {};
Map datas = {};

var list = [];

class _CustomerLoginPageState extends State<CustomerLoginPage> {
  TextEditingController nameC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController vaccineC = TextEditingController();
  String n = "";
  String a = "";
  String v = "";
  String name = " ";
  String body = " ";
  String email = "";
  DateTime date;
  String address = "";
  String vaccine = "";
  void add() {
    n = nameC.text.toString();
    a = addressC.text.toString();
    v = vaccineC.text.toString();
    email = Userid['email'];
    date = Userid['date'].creationTime;
    print(date);

    CollectionReference users = firestore.collection('users');
    users.doc(Userid['id']).set({
      'name': n,
      'address': a,
      'vaccine': v,
    }).then((value) => print("added"));
    setState(() {
      dataFilled = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    setState(() {
      Userid = ModalRoute.of(context).settings.arguments;
      email = Userid['email'];
      firestore
          .collection("users")
          .doc(Userid['id'])
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            datas = documentSnapshot.data();
            list = datas.values.toList();
            print(list);

            name = list[2];
            address = list[1];
            vaccine = list[0];
            dataFilled = true;
          });
        } else {
          setState(() {
            dataFilled = false;
          });
        }
      });
    });

    return (!dataFilled)
        ? Scaffold(
            appBar: AppBar(
              title: Text("Customer page"),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Name",
                      ),
                      controller: nameC,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Address",
                      ),
                      controller: addressC,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Vaccine Status",
                      ),
                      controller: vaccineC,
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
            body: Column(
              children: [
                ListTile(
                  tileColor: Colors.grey[100],
                  title: Text("Name"),
                  subtitle: Text(name),
                ),
                SizedBox(height: 10),
                ListTile(
                  tileColor: Colors.grey[100],
                  title: Text("Email"),
                  subtitle: Text(email),
                ),
                SizedBox(height: 10),
                ListTile(
                  tileColor: Colors.grey[100],
                  title: Text("Adress"),
                  subtitle: Text(address),
                ),
                SizedBox(height: 10),
                ListTile(
                  tileColor: Colors.grey[100],
                  title: Text("Vaccine Status"),
                  subtitle: Text(vaccine),
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
          );
  }
}

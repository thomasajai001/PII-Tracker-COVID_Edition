import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewCustomers extends StatefulWidget {
  @override
  _ViewCustomersState createState() => _ViewCustomersState();
}

class _ViewCustomersState extends State<ViewCustomers> {
  List customerData = [];

  @override
  void initState() {
    super.initState();
    getCustomers();
  }

  Future getCustomers() async {
    Map shopkeeperData;

    try {
      var shopkeeperUid = FirebaseAuth.instance.currentUser.uid;

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Shopkeeper")
          .doc(shopkeeperUid)
          .get();
      shopkeeperData = documentSnapshot.data();
    } catch (e) {
      print(e.toString());
    }

    print(shopkeeperData['customers'][0].toString());

    var customersList = shopkeeperData['customers'];

    customersList.forEach((customer) async {
      try {
        var customerUid = customer['customerUid'].toString();
        var time = customer['time'];
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(customerUid)
            .get();
        Map data = documentSnapshot.data();
        setState(() {
          customerData.add({'data': data, 'time': time});
        });
      } catch (e) {
        print(e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer list"),
      ),
      body: customerData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "No customers yet!",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                    height: 300,
                    child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/pii-test-a8b13.appspot.com/o/waiting.png?alt=media&token=842495c6-4ebe-4236-9d46-1a7a08aae954',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.9,
              child: ListView(
                children: customerData.map((e) {
                  return Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(e['data']['imageUrl']),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Name : ${e['data']['name']}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 15),
                              Text(
                                "Vaccine Staus: ${e['data']['vaccine']}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 15),
                              Text(
                                "Address: ${e['data']['address']}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 15),
                              Text(
                                "Time: ${DateFormat.MMMd().add_jm().format(DateTime.parse(e['time'].toDate().toString()))}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewCustomers extends StatefulWidget {
  @override
  _ViewCustomersState createState() => _ViewCustomersState();
}

class _ViewCustomersState extends State<ViewCustomers> {
  String shopkeeperUid;
  List customers, customerData = [];

  Map shopkeeperData;

  @override
  void initState() {
    super.initState();
    getCustomers();
  }

  Future getCustomers() async {
    try {
      shopkeeperUid = FirebaseAuth.instance.currentUser.uid;

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Shopkeeper")
          .doc(shopkeeperUid)
          .get();
      setState(() {
        shopkeeperData = documentSnapshot.data();
      });
    } catch (e) {
      print(e.toString());
    }

    print(shopkeeperData['customers'][0].toString());
    setState(() {
      customers = shopkeeperData['customers'];
    });

    customers.forEach((element) async {
      print("the element is " + element);
      try {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(element)
            .get();
        Map data = documentSnapshot.data();
        setState(() {
          customerData.add(data);
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        child: ListView(
          children: customerData.map((e) {
            return Container(
              height: 130,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(e['imageUrl']),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.611,
                    child: Column(
                      children: [
                        Text(
                          "Name : ${e['name']}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Vaccine Staus: ${e['vaccine']}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Address: ${e['address']}",
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

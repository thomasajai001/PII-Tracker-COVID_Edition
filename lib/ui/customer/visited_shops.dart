import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VisitedShops extends StatefulWidget {
  @override
  _VisitedShopsState createState() => _VisitedShopsState();
}

class _VisitedShopsState extends State<VisitedShops> {
  List shopkeepers, shopkeeperData = [];
  String uid;

  Map customerData;

  @override
  void initState() {
    super.initState();
    getVisitedStoresInfo();
  }

  Future getVisitedStoresInfo() async {
    try {
      uid = FirebaseAuth.instance.currentUser.uid;

      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      setState(() {
        customerData = documentSnapshot.data();
      });
    } catch (e) {
      print(e.toString());
    }

    print(customerData['visitedStores'][0].toString());
    setState(() {
      shopkeepers = customerData['visitedStores'];
    });

    shopkeepers.forEach((element) async {
      print("the element is " + element);
      try {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection("Shopkeeper")
            .doc(element)
            .get();
        Map data = documentSnapshot.data();
        setState(() {
          shopkeeperData.add(data);
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
        title: Text("Visited Shops"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        child: ListView(
          children: shopkeeperData.map((e) {
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
                          "Shop : ${e['shopName']}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Shopkeeper: ${e['shopkeeperName']}",
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

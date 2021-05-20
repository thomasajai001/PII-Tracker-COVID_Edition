import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VisitedShops extends StatefulWidget {
  @override
  _VisitedShopsState createState() => _VisitedShopsState();
}

class _VisitedShopsState extends State<VisitedShops> {
  List visitedStoresList, shopkeeperData = [];
  String customerUid, shopkeeperUid;

  Map customerData;

  @override
  void initState() {
    super.initState();
    getVisitedStoresInfo();
  }

  Future getVisitedStoresInfo() async {
    try {
      customerUid = FirebaseAuth.instance.currentUser.uid;

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(customerUid)
          .get();
      setState(() {
        customerData = documentSnapshot.data();
      });
    } catch (e) {
      print(e.toString());
    }
    print("hello");
    print(customerData['visitedStores'][0].toString());
    setState(() {
      visitedStoresList = customerData['visitedStores'];
    });

    visitedStoresList.forEach((visitedStore) async {
      print("the element is " + visitedStore.toString());
      try {
        shopkeeperUid = visitedStore['shopkeeperUid'].toString();
        var time = visitedStore['time'].toString();
        print('shopkeeperUid is ' + shopkeeperUid.toString());
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection("Shopkeeper")
            .doc(shopkeeperUid)
            .get();
        Map data = documentSnapshot.data();
        setState(() {
          shopkeeperData.add({'data': data, 'time': time});
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
              height: 160,
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
                    backgroundImage: NetworkImage(e['data']['imageUrl']),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Column(
                      children: [
                        Text(
                          "Shop : ${e['data']['shopName']}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Shopkeeper: ${e['data']['shopkeeperName']}",
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
                          "Time: " +
                              DateFormat.MMMd()
                                  .add_jm()
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(e['time']
                                              .toString()
                                              .split(',')[0]
                                              .split('=')[1]) *
                                          1000))
                                  .toString(),
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

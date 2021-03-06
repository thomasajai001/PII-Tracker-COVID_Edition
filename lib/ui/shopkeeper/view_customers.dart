import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ViewCustomers extends StatefulWidget {
  @override
  _ViewCustomersState createState() => _ViewCustomersState();
}

ScrollController _scrollController = ScrollController();

class _ViewCustomersState extends State<ViewCustomers> {
  bool loaded = true;
  List customerData = [];

  @override
  void initState() {
    super.initState();
    getCustomers();
  }

  Future getCustomers() async {
    loaded = false;
    new Timer(new Duration(milliseconds: 350), () {
      setState(() {
        loaded = true;
      });
    });
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
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
          decoration: BoxDecoration(
              // color: Colors.pink,
              ),
          height: 20,
          margin: EdgeInsets.only(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 10,
          ),
          child: Text(
            "Swipe right to to go back >>",
            style: TextStyle(color: Colors.grey),
          ),
          alignment: Alignment.bottomLeft,
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Text(""),
        title: Text("Customer list"),
      ),
      body: loaded
          ? customerData.isEmpty
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
                          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn.dribbble.com%2Fusers%2F1058271%2Fscreenshots%2F3308780%2Fsadbox_2x.png&f=1&nofb=1',
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
                              backgroundImage:
                                  NetworkImage(e['data']['imageUrl']),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Scrollbar(
                                thickness: 5,
                                isAlwaysShown: true,
                                controller: _scrollController,
                                showTrackOnHover: true,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      FittedBox(
                                        child: Text(
                                          "Name : ${e['data']['name']}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      FittedBox(
                                        child: Text(
                                          "Vaccine Status: ${e['data']['vaccine']}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      FittedBox(
                                        child: Text(
                                          "Address: ${e['data']['address']}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      FittedBox(
                                        child: Text(
                                          "Time: ${DateFormat.MMMd().add_jm().format(DateTime.parse(e['time'].toDate().toString()))}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                )
          : SpinKitDualRing(
              color: Colors.blue,
              size: 50.0,
            ),
    );
  }
}

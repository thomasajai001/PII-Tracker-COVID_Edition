import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pii_tracker_covid_edition/flutterfire/shopkeeper.dart';
import '../../flutterfire/auth.dart';

class ShopkeeperHomePage extends StatefulWidget {
  @override
  _ShopkeeperHomePageState createState() => _ShopkeeperHomePageState();
}

class _ShopkeeperHomePageState extends State<ShopkeeperHomePage> {
  TextEditingController shopNameC = TextEditingController();
  TextEditingController shopkeeperNameC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController vaccineC = TextEditingController();
  String shopName, shopkeeperName, address, vaccine;

  bool dataExists = false;

  void add({
    String shopName,
    String shopkeeperName,
    String address,
    String vaccineStatus,
  }) async {
    addDeails(
      address: addressC.text,
      shopName: shopNameC.text,
      shopkeeperName: shopkeeperNameC.text,
      vaccineStatus: vaccineC.text,
    );
  }

  void setValues() async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      String uid = FirebaseAuth.instance.currentUser.uid;
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('Shopkeeper').doc(uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        Map<String, Object> data = snapshot.data();

        if (snapshot.exists) {
          setState(() {
            dataExists = true;
            shopName = data['shopName'].toString();
            shopkeeperName = data['shopkeeperName'].toString();
            address = data['address'].toString();
            vaccine = data['vaccineStatus'].toString();
            print(data);
          });
        } else
          setState(() {
            dataExists = false;
            shopName = address = shopkeeperName = vaccine = "";
          });
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopkeeper Page"),
        centerTitle: true,
      ),
      body: (!dataExists)
          ? SafeArea(
              child: Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Shop Name",
                      ),
                      controller: shopNameC,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Shopkeeper Name",
                      ),
                      controller: shopkeeperNameC,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Address",
                      ),
                      controller: addressC,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Vaccine Status",
                      ),
                      controller: vaccineC,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //TODO
                      },
                      child: Text("Upload photo"),
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
                        Navigator.pushNamed(context, '/selectUserType');
                      },
                      child: Text("logout"),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // SizedBox(height: 20),
                // CircleAvatar(
                //   radius: 80,
                //   backgroundImage: NetworkImage(imageUrl),
                // ),
                SizedBox(height: 20),
                ListTile(
                  tileColor: Colors.grey[100],
                  title: Text("Shop Name"),
                  subtitle: Text(shopName),
                ),
                // SizedBox(height: 10),
                // ListTile(
                //   tileColor: Colors.grey[100],
                //   title: Text("Email"),
                //   subtitle: Text(email),
                // ),
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
                SizedBox(height: 10),
                ListTile(
                  tileColor: Colors.grey[100],
                  title: Text("Shopkeeper Name"),
                  subtitle: Text(shopkeeperName),
                ),
                ElevatedButton(
                  onPressed: () {
                    customerSignout();
                    Navigator.pushNamed(context, '/selectUserType');
                  },
                  child: Text("logout"),
                ),
              ],
            ),
    );
  }
}

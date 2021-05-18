import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pii_tracker_covid_edition/flutterfire/shopkeeper.dart';
import '../../flutterfire/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopkeeperHomePage extends StatefulWidget {
  @override
  _ShopkeeperHomePageState createState() => _ShopkeeperHomePageState();
}

class _ShopkeeperHomePageState extends State<ShopkeeperHomePage> {
  void imageUpload() async {
    final _pickr = ImagePicker();
    PickedFile image;

    var permissionstatus = await Permission.photos.request();
    if (permissionstatus.isGranted) {
      image = await _pickr.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        FirebaseStorage _storage = FirebaseStorage.instance;
        var snapshot = _storage.ref().child('images/').putFile(file).snapshot;
        var url = await snapshot.ref.getDownloadURL();
        setState(() {
          i = url;
        });
        Fluttertoast.showToast(
            msg: "Upload Complete",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey[400],
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      print("Grant permission");
    }
  }

  TextEditingController shopNameC = TextEditingController();
  TextEditingController shopkeeperNameC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController vaccineC = TextEditingController();
  String shopName, shopkeeperName, address, vaccine, email, i;

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
    Navigator.pushNamed(context, '/shopkeeperSignIn');
  }

  void setValues() async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map userId = ModalRoute.of(context).settings.arguments;

    email = userId['email'];
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
                    RawMaterialButton(
                      fillColor: Theme.of(context).accentColor,
                      child: Icon(
                        Icons.add_photo_alternate_rounded,
                        color: Colors.white,
                      ),
                      elevation: 8,
                      onPressed: () {
                        imageUpload();
                      },
                      padding: EdgeInsets.all(15),
                      shape: CircleBorder(),
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
                SizedBox(height: 10),
                ListTile(
                  tileColor: Colors.grey[100],
                  title: Text("Shopkeeper Name"),
                  subtitle: Text(shopkeeperName),
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
                  title: Text("Address"),
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
                    Navigator.pushNamed(context, '/selectUserType');
                  },
                  child: Text("logout"),
                ),
              ],
            ),
    );
  }
}

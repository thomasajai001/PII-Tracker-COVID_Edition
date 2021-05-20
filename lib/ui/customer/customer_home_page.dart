import 'package:flutter/material.dart';
import '../../flutterfire/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import './visited_shops.dart';

// import 'package:fluttertoast/fluttertoast.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage _storage;

class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

bool dataFilled = false;
User userId;
Map datas = {};

var list = [];

class _CustomerHomePageState extends State<CustomerHomePage> {
  TextEditingController nameC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController vaccineC = TextEditingController();
  int check = 0;
  String n = "";
  String a = "";
  String v = "";
  String i = " ";
  String uid = "";
  String imageUrl = " ";
  String name = " ";
  String body = " ";
  String email = "";
  DateTime date;
  String address = "";
  String vaccine = "";
  String shopkeeperUid;

  Future<void> scan() async {
    String codeSanner = await BarcodeScanner.scan();
    shopkeeperUid = codeSanner.toString();
    var time = DateTime.now();
    print(shopkeeperUid);
    try {
      var obj = [
        {'shopkeeperUid': shopkeeperUid, 'time': time}
      ];
      String customerUid = FirebaseAuth.instance.currentUser.uid;
      FirebaseFirestore.instance
          .collection("users")
          .doc(customerUid)
          .update({"visitedStores": FieldValue.arrayUnion(obj)});

      var snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(customerUid)
          .get();
      print("<><><><><><><>><><>");
      print(snapshot.data());
      print("<><><><><><><>><><>");

      var custObj = [
        {'customerUid': customerUid.toString(), 'time': time}
      ];
      FirebaseFirestore.instance
          .collection("Shopkeeper")
          .doc(shopkeeperUid)
          .update({"customers": FieldValue.arrayUnion(custObj)});

      var snapshotOfShopkeeper = await FirebaseFirestore.instance
          .collection("Shopkeeper")
          .doc(shopkeeperUid)
          .get();
      print("<><><><><><><>><><>");
      print(snapshotOfShopkeeper.data());
      print("<><><><><><><>><><>");
    } catch (e) {
      print("<>\n<><>><><><\n\n${e.toString()}\n\n<><><><><>\n<");
    }
  }

  void add() {
    n = nameC.text.toString();
    a = addressC.text.toString();
    v = vaccineC.text.toString();
    setState(() {
      email = userId.email;
      date = userId.metadata.lastSignInTime;
    });

    print(date);

    CollectionReference users = firestore.collection('users');
    users.doc(uid).set({
      'name': n,
      'address': a,
      'vaccine': v,
      'imageUrl': i,
    }).then((value) => print("added"));
    setState(() {
      dataFilled = true;
    });
    firestore
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          datas = documentSnapshot.data();
          imageUrl = datas['imageUrl'].toString();
          name = datas['name'].toString();
          address = datas['address'].toString();
          vaccine = datas['vaccine'].toString();
          dataFilled = true;
          print("$imageUrl   $name    $address     $vaccine");
        });
      } else {
        setState(() {
          dataFilled = false;
        });
      }
    });
  }

  void imageUpload() async {
    final _pickr = ImagePicker();
    PickedFile image;
//handle permission
    var permissionstatus = await Permission.photos.request();
    if (permissionstatus.isGranted) {
      image = await _pickr.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        _storage = FirebaseStorage.instance;
        var snapshot = _storage.ref().child('images/').putFile(file).snapshot;
        var url = await snapshot.ref.getDownloadURL();
        setState(() {
          i = url;
        });
        //   Fluttertoast.showToast(
        //       msg: "Upload Complete",
        //       toastLength: Toast.LENGTH_SHORT,
        //       gravity: ToastGravity.CENTER,
        //       timeInSecForIosWeb: 1,
        //       backgroundColor: Colors.grey[400],
        //       textColor: Colors.white,
        //       fontSize: 16.0);
      }
    } else {
      print("Grant permission");
    }
//select image
// upload to storage
  }

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser;
    uid = userId.uid;

    firestore
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          datas = documentSnapshot.data();
          list = datas.values.toList();
          print(list);
          // imageUrl = list[2];
          imageUrl = datas['imageUrl'];
          // name = list[3];
          name = datas['name'];
          // address = list[1];
          address = datas['address'];
          // vaccine = list[0];
          vaccine = datas['vaccine'];
          dataFilled = true;
          print("$imageUrl   $name    $address     $vaccine");
        });
      } else {
        setState(() {
          dataFilled = false;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return (!dataFilled)
        ? Scaffold(
            appBar: AppBar(
              title: Text("Customer page"),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.all(15),
                child: SingleChildScrollView(
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
                        onPressed: imageUpload,
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
                          Navigator.pushNamed(context, '/registration');
                        },
                        child: Text("logout"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Customer page"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  SizedBox(height: 20),
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
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                    onPressed: scan,
                    icon: Icon(Icons.camera_alt),
                    label: Text("Scan QR"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VisitedShops()));
                    },
                    icon: Icon(Icons.list_rounded),
                    label: Text("View visited shops"),
                  ),
                  SizedBox(height: 30),
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
          );
  }
}

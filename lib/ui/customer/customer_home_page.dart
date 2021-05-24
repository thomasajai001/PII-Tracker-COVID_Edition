import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pii/ui/customer/customerUpdate.dart';
import 'package:pii/ui/select_user_type.dart';
import '../../flutterfire/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import './visited_shops.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
ScrollController _scrollController = ScrollController();

class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

bool dataFilled = false;
User userId;
Map datas = {};

var list = [];

class _CustomerHomePageState extends State<CustomerHomePage> {
  PageController _pageController = PageController();
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
  bool imagePicked = false, loading = true;

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
    if (imagePicked) {
      CollectionReference users = firestore.collection('users');
      users.doc(uid).set({
        'name': n,
        'address': a,
        'vaccine': v,
        'imageUrl': i,
      }).then((value) => print("added"));
    } else {
      i = "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg";
      CollectionReference users = firestore.collection('users');
      users.doc(uid).set({
        'name': n,
        'address': a,
        'vaccine': v,
        'imageUrl': i,
      }).then((value) => print("added"));
    }

    firestore
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          datas = documentSnapshot.data();
          email = userId.email;
          date = userId.metadata.lastSignInTime;
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
    var url;
    final _pickr = ImagePicker();
    PickedFile image;
//handle permission
    var permissionstatus = await Permission.photos.request();
    if (permissionstatus.isGranted) {
      image = await _pickr.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        imagePicked = true;
        Reference reference =
            FirebaseStorage.instance.ref().child('Customer/').child(uid);
        UploadTask uploadTask = reference.putFile(file);
        await uploadTask.whenComplete(() async {
          url = await uploadTask.snapshot.ref.getDownloadURL();
        });

        print(url);
        i = url;
        print(i);
        Alert(
          type: AlertType.success,
          context: context,
          title: "Successfully Uploaded",
          image: Image.asset('assets/correct.png'),
          buttons: [
            DialogButton(
              child: Text(
                "Continue",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: Color.fromRGBO(0, 179, 134, 1.0),
            ),
          ],
        ).show();
        print("image added");
      } else {
        i = "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg";
      }
    } else {
      print("Grant permission");
    }
  }

  @override
  void initState() {
    super.initState();
    new Timer(Duration(milliseconds: 1000), () {
      setState(() {
        loading = false;
      });
    });

    userId = FirebaseAuth.instance.currentUser;
    uid = userId.uid;

    firestore
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          email = userId.email;
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
          print("Details$imageUrl   $name    $address     $vaccine");
        });
      } else {
        setState(() {
          print("new form");
          dataFilled = false;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
            appBar: AppBar(
              title: Text("Customer page"),
              centerTitle: true,
            ),
            body: Center(
                child: Container(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator())))
        : (!dataFilled)
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
                              Navigator.pushReplacementNamed(
                                  context, '/registration');
                            },
                            child: Text("logout"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : PageView(controller: _pageController, children: [
                Scaffold(
                  appBar: AppBar(
                    title: Text("Customer page"),
                    centerTitle: true,
                  ),
                  drawer: Drawer(
                    child: ListView(
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          accountName: Text(name),
                          accountEmail: Text(email),
                          currentAccountPicture: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.camera_alt),
                          title: Text("Scan QR"),
                          onTap: () {
                            scan();
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.list_rounded),
                          title: Text("View visited shops"),
                          onTap: () {
                            setState(() {
                              _pageController.jumpToPage(1);
                            });
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.update_sharp),
                          title: Text("Update Fields"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomerUpdate()));
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: Text("Logout"),
                          onTap: () {
                            customerSignout();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SelectUserType()));
                          },
                        ),
                      ],
                    ),
                  ),
                  body: Scrollbar(
                    thickness: 15,
                    isAlwaysShown: true,
                    controller: _scrollController,
                    showTrackOnHover: true,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: ListTile(
                              tileColor: Colors.grey[100],
                              title: Text("Name"),
                              subtitle: Text(name),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: ListTile(
                              tileColor: Colors.grey[100],
                              title: Text("Email"),
                              subtitle: Text(email),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: ListTile(
                              tileColor: Colors.grey[100],
                              title: Text("Address"),
                              subtitle: Text(address),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: ListTile(
                              tileColor: Colors.grey[100],
                              title: Text("Vaccine Status"),
                              subtitle: Text(vaccine),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Column(
                      children: [
                        FloatingActionButton(
                          child: Icon(
                            Icons.qr_code_scanner_rounded,
                            size: 30,
                          ),
                          onPressed: scan,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                  bottomSheet: Container(
                    height: 20,
                    margin: EdgeInsets.only(
                      bottom: 20,
                      right: MediaQuery.of(context).size.width / 10,
                    ),
                    child: Text(
                      "<< Swipe left to view visited shops",
                      style: TextStyle(color: Colors.grey),
                    ),
                    alignment: Alignment.bottomRight,
                  ),
                ),
                VisitedShops()
              ]);
  }
}

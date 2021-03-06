import 'dart:async';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../flutterfire/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import './view_customers.dart';
import '../../qr/qrGenerator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ShopkeeperHomePage extends StatefulWidget {
  @override
  _ShopkeeperHomePageState createState() => _ShopkeeperHomePageState();
}

class _ShopkeeperHomePageState extends State<ShopkeeperHomePage> {
  PageController _pageController = PageController(
    initialPage: 0,
  );
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User shopkeeper;
  TextEditingController shopNameC = TextEditingController();
  TextEditingController shopkeeperNameC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController vaccineC = TextEditingController();
  Map datas = {};
  String email, uid;
  String shopName, shopkeeperName, address, vaccine;
  DateTime date;
  String imageUrl;
  String i = "";
  bool dataExists = false, imageExists = false, imageLoading = false;
  bool imageUploaded = false, loading = true;

  void add() {
    shopName = shopNameC.text.toString();
    shopkeeperName = shopkeeperNameC.text.toString();
    address = addressC.text.toString();
    vaccine = vaccineC.text.toString();
    if (imageUploaded) {
      CollectionReference users = firestore.collection('Shopkeeper');
      users.doc(uid).set({
        'shopName': shopName,
        'shopkeeperName': shopkeeperName,
        'address': address,
        'imageUrl': i,
        'vaccine': vaccine,
      }).then((value) => print("added"));
    } else {
      i = "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg";
      CollectionReference users = firestore.collection('Shopkeeper');
      users.doc(uid).set({
        'shopName': shopName,
        'shopkeeperName': shopkeeperName,
        'address': address,
        'imageUrl': i,
        'vaccine': vaccine,
      }).then((value) => print("added"));
    }

    firestore
        .collection("Shopkeeper")
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          datas = documentSnapshot.data();
          email = shopkeeper.email;
          date = shopkeeper.metadata.lastSignInTime;
          imageUrl = datas['imageUrl'].toString();
          shopName = datas['shopName'].toString();
          shopkeeperName = datas['shopkeeperName'].toString();
          address = datas['address'].toString();
          vaccine = datas['vaccine'].toString();
          dataExists = true;
        });
      } else {
        setState(() {
          dataExists = false;
        });
      }
    });
  }

  void imageUpload() async {
    final _pickr = ImagePicker();
    PickedFile image;
    var permissionstatus = await Permission.photos.request();
    if (permissionstatus.isGranted) {
      image = await _pickr.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        imageUploaded = true;
        Reference reference =
            FirebaseStorage.instance.ref().child('Shopkeeper/').child(uid);
        UploadTask uploadTask = reference.putFile(file);
        await uploadTask.whenComplete(() async {
          var url = await uploadTask.snapshot.ref.getDownloadURL();

          print(url);
          i = url;
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
          print(i);
          print("image added");
        });
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

    shopkeeper = FirebaseAuth.instance.currentUser;
    uid = shopkeeper.uid;
    email = shopkeeper.email;

    FirebaseFirestore.instance
        .collection("Shopkeeper")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          datas = documentSnapshot.data();

          imageUrl = datas['imageUrl'];
          shopName = datas['shopName'];
          address = datas['address'];
          shopkeeperName = datas['shopkeeperName'];
          vaccine = datas['vaccine'];
          dataExists = true;
        });
      } else {
        setState(() {
          dataExists = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
            appBar: AppBar(
              title: Text("Shopkeeper page"),
              centerTitle: true,
            ),
            body: Center(
                child: Container(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator())))
        : PageView(controller: _pageController, children: [
            (!dataExists)
                ? Scaffold(
                    appBar: AppBar(
                      title: Text("Shopkeeper Page"),
                      centerTitle: true,
                    ),
                    body: SafeArea(
                      child: Container(
                        margin: EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          controller: _scrollController,
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
                                  Navigator.pushNamed(
                                      context, '/selectUserType');
                                },
                                child: Text("logout"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                : Scaffold(
                    appBar: AppBar(
                      title: Text("Shopkeeper page"),
                      centerTitle: true,
                    ),
                    drawer: Drawer(
                      child: ListView(
                        children: <Widget>[
                          UserAccountsDrawerHeader(
                            accountName: Text(shopkeeperName),
                            accountEmail: Text(email),
                            currentAccountPicture: imageUrl == null &&
                                    imageExists == false
                                ? CircleAvatar(
                                    radius: 40,
                                  )
                                : imageLoading
                                    ? SpinKitRotatingCircle(
                                        color: Colors.white,
                                        size: 50.0,
                                      )
                                    : CircleAvatar(
                                        radius: 40,
                                        backgroundImage: NetworkImage(imageUrl),
                                      ),
                          ),
                          ListTile(
                            leading: Icon(Icons.qr_code_outlined),
                            title: Text("Generate QR"),
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                builder: (context) => QrGenerator(),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.list_rounded),
                            title: Text("View customers"),
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
                              Navigator.pushNamed(context, '/shopkeeperUpdate');
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.logout),
                            title: Text("Logout"),
                            onTap: () {
                              customerSignout();
                              Navigator.pushNamed(context, '/selectUserType');
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
                            imageUrl == null && imageExists == false
                                ? CircleAvatar(
                                    radius: 80,
                                  )
                                : imageLoading
                                    ? SpinKitRotatingCircle(
                                        color: Colors.white,
                                        size: 50.0,
                                      )
                                    : CircleAvatar(
                                        radius: 80,
                                        backgroundImage: NetworkImage(imageUrl),
                                      ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                tileColor: Colors.grey[100],
                                title: Text("Shop Name"),
                                subtitle: Text(shopName),
                              ),
                            ),
                            // SizedBox(height: 10),
                            // ListTile(
                            //   tileColor: Colors.grey[100],
                            //   title: Text("Email"),
                            //   subtitle: Text(email),
                            // ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ListTile(
                                tileColor: Colors.grey[100],
                                title: Text("Address"),
                                subtitle: Text(address),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ListTile(
                                tileColor: Colors.grey[100],
                                title: Text("Vaccine Status"),
                                subtitle: Text(vaccine),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ListTile(
                                tileColor: Colors.grey[100],
                                title: Text("Shopkeeper Name"),
                                subtitle: Text(shopkeeperName),
                              ),
                            ),
                            SizedBox(height: 20),

                            SizedBox(
                              height: 20,
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
                            child: Icon(Icons.qr_code_rounded),
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (context) => QrGenerator(),
                              );
                            },
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
                        "<< Swipe left to view customers",
                        style: TextStyle(color: Colors.grey),
                      ),
                      alignment: Alignment.bottomRight,
                    ),
                  ),
            ViewCustomers()
          ]);
  }
}

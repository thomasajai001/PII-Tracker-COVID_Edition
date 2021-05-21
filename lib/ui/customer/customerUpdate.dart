import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:fluttertoast/fluttertoast.dart';

bool defaultData = false;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage _storage;

class CustomerUpdate extends StatefulWidget {
  @override
  _CustomerUpdateState createState() => _CustomerUpdateState();
}

bool dataFilled = false;

User userId;
Map datas = {};

var list = [];

class _CustomerUpdateState extends State<CustomerUpdate> {
  TextEditingController nameC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController vaccineC = TextEditingController();
  int check = 0;
  String n = "";
  String a = "";
  String u = "";
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
  bool imageChanged = false;

  void cancel() {
    Navigator.pushReplacementNamed(context, '/customerHomePage');
  }

  void update() {
    n = nameC.text.toString();
    a = addressC.text.toString();
    v = vaccineC.text.toString();

    email = userId.email;
    date = userId.metadata.lastSignInTime;

    print(date);
    if (imageChanged) {
      CollectionReference users = firestore.collection('users');
      users.doc(uid).update({
        'name': n,
        'address': a,
        'vaccine': v,
        'imageUrl': i,
      }).then((value) => print("added"));
    } else {
      CollectionReference users = firestore.collection('users');
      users.doc(uid).update({
        'name': n,
        'address': a,
        'vaccine': v,
        'imageUrl': u,
      }).then((value) => print("added"));
    }

    Navigator.pushReplacementNamed(context, '/customerHomePage');
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

        imageChanged = true;
        i = url;

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
          email = userId.email;
          datas = documentSnapshot.data();
          list = datas.values.toList();
          print(list);
          // imageUrl = list[2];
          imageUrl = datas['imageUrl'];
          u = imageUrl;
          // name = list[3];
          name = datas['name'];
          // address = list[1];
          address = datas['address'];
          // vaccine = list[0];
          vaccine = datas['vaccine'];
          print(imageUrl);
          defaultData = true;
          print("Details  $imageUrl   $name    $address     $vaccine");
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return (defaultData != false)
        ? Scaffold(
            appBar: AppBar(
              title: Text("Customer Update"),
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
                        controller: nameC..text = name,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Address",
                        ),
                        controller: addressC..text = address,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Vaccine Status",
                        ),
                        controller: vaccineC..text = vaccine,
                      ),
                      ElevatedButton(
                        onPressed: imageUpload,
                        child: Text("Upload photo"),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: update,
                            child: Text("Update"),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          ElevatedButton(
                            onPressed: cancel,
                            child: Text("Cancel Update"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Customer Update"),
              centerTitle: true,
            ),
            body: SpinKitRotatingCircle(color: Colors.blue),
          );
  }
}

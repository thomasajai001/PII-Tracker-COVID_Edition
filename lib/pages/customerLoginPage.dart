import 'package:flutter/material.dart';
import 'package:pii_tracker_covid_edition/imageHandler.dart';
import '../auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage _storage;

class CustomerLoginPage extends StatefulWidget {
  @override
  _CustomerLoginPageState createState() => _CustomerLoginPageState();
}

bool dataFilled = false;
Map Userid = {};
Map datas = {};

var list = [];

class _CustomerLoginPageState extends State<CustomerLoginPage> {
  TextEditingController nameC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController vaccineC = TextEditingController();
  String n = "";
  String a = "";
  String v = "";
  String i = " ";
  String imageUrl = " ";
  String name = " ";
  String body = " ";
  String email = "";
  DateTime date;
  String address = "";
  String vaccine = "";
  void add() {
    n = nameC.text.toString();
    a = addressC.text.toString();
    v = vaccineC.text.toString();
    email = Userid['email'];
    date = Userid['date'].creationTime;
    print(date);

    CollectionReference users = firestore.collection('users');
    users.doc(Userid['id']).set({
      'name': n,
      'address': a,
      'vaccine': v,
      'imageUrl': i,
    }).then((value) => print("added"));
    setState(() {
      dataFilled = true;
    });
  }

  void imageUpload() async {
    final _pickr = ImagePicker();
    PickedFile Image;
//handle permission
    var permissionstatus = await Permission.photos.request();
    if (permissionstatus.isGranted) {
      Image = await _pickr.getImage(source: ImageSource.gallery);
      var file = File(Image.path);
      if (Image != null) {
        _storage = FirebaseStorage.instance;
        var snapshot =
            await _storage.ref().child('images/').putFile(file).snapshot;
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
//select image
// upload to storage
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    setState(() {
      Userid = ModalRoute.of(context).settings.arguments;

      email = Userid['email'];
      firestore
          .collection("users")
          .doc(Userid['id'])
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            datas = documentSnapshot.data();
            list = datas.values.toList();
            print(list);
            imageUrl = list[2];
            name = list[3];
            address = list[1];
            vaccine = list[0];
            dataFilled = true;
          });
        } else {
          setState(() {
            dataFilled = false;
          });
        }
      });
    });

    return (!dataFilled)
        ? Scaffold(
            appBar: AppBar(
              title: Text("Customer page"),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Container(
                margin: EdgeInsets.all(15),
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
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Customer page"),
              centerTitle: true,
            ),
            body: Column(
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
                ElevatedButton(
                  onPressed: () {
                    customerSignout();
                    Navigator.pushNamed(context, '/registration');
                  },
                  child: Text("logout"),
                ),
              ],
            ),
          );
  }
}

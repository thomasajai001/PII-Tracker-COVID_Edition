import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

FirebaseStorage _storage;

class ImageHandler extends StatefulWidget {
  @override
  _ImageHandlerState createState() => _ImageHandlerState();
}

class _ImageHandlerState extends State<ImageHandler> {
  String ImageUrl = " ";

  void uploadImage() async {
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
          ImageUrl = url;
        });
        AlertDialog(
          title: Text("Upload Complete"),
        );
        Navigator.pushReplacementNamed(context, '/customerLoginPAge',
            arguments: {
              'url': ImageUrl,
            });
      }
    } else {
      print("Grant permission");
    }
//select image
// upload to storage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Placeholder(
              strokeWidth: 5,
              color: Colors.indigo[900],
              fallbackHeight: 200,
              fallbackWidth: double.infinity,
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: uploadImage,
              child: Text("Upload Image"),
            )
          ],
        ),
      ),
    );
  }
}

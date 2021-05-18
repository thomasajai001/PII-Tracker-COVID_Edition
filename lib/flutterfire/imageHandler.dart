import 'dart:io';
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
  String imageUrl = " ";

  void uploadImage() async {
    final _pickr = ImagePicker();
    PickedFile image;
//handle permission
    var permissionstatus = await Permission.photos.request();
    if (permissionstatus.isGranted) {
      image = await _pickr.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      if (image != null) {
        _storage = FirebaseStorage.instance;
        var snapshot =
            _storage.ref().child('images/').putFile(file).snapshot;
        var url = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = url;
        });
        AlertDialog(
          title: Text("Upload Complete"),
        );
        Navigator.pushReplacementNamed(context, '/customerLoginPAge',
            arguments: {
              'url': imageUrl,
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

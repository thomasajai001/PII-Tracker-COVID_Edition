import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

void addDeails({
  String shopName,
  String shopkeeperName,
  String address,
  String vaccineStatus,
}) async {
  try {
    String uid = FirebaseAuth.instance.currentUser.uid;
    print(uid);
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Shopkeeper').doc(uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({
          'shopName': shopName,
          'shopkeeperName': shopkeeperName,
          'address': address,
          'vaccineStatus': vaccineStatus,
        });
      }
    });
  } catch (e) {
    print(e.toString());
  }
}


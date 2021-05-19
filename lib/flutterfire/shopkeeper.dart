import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

// // Future<Map<String, Object>> getDetails() async {
// void getDetails() async {
//   void getDetails() async {
//     try {
//       String uid = FirebaseAuth.instance.currentUser.uid;
//       DocumentReference documentReference =
//           FirebaseFirestore.instance.collection('Shopkeeper').doc(uid);

//       FirebaseFirestore.instance.runTransaction((transaction) async {
//         DocumentSnapshot snapshot = await transaction.get(documentReference);
//         print("\n\n<><><><><>" +
//             snapshot.data().toString() +
//             "\n\n<><><><><>\n\n");
//       });
//     } catch (e) {
//       print("\n\n<><><><><>" + e.toString() + "\n\n<><><><><>\n\n");
//     }
//   }
// }

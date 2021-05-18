import 'package:firebase_auth/firebase_auth.dart';

Future<String> userRegistration(String email, String password) async {
  String displayMsg = "";
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    print(email);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      displayMsg = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      displayMsg = 'The account already exists for that email.';
    }
  } catch (e) {
    return e.toString();
  }
  return displayMsg;
}

Future<User> userSignIn(String email, String password) async {
  User user;
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password);
    user = FirebaseAuth.instance.currentUser;
    print(user.email);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      throw ('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      throw ('Wrong password provided for that user.');
    }
  }
  return user;
}


void customerSignout() async {
  await FirebaseAuth.instance.signOut();
  print("Signed Out");
}

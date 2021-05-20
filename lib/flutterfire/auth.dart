import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
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

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<User> googleSignIn() async {
  final GoogleSignInAccount account = await _googleSignIn.signIn();
  final GoogleSignInAuthentication authentication =
      await account.authentication;

  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      idToken: authentication.idToken, accessToken: authentication.accessToken);

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);
  final User currentUser = _auth.currentUser;
  assert(currentUser.uid == user.uid);
  return user;
}

void signoutGoogle() async {
  await _googleSignIn.signOut();
}

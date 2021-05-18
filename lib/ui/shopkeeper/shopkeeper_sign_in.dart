import 'package:flutter/material.dart';
import '../../flutterfire/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShopkeeperSignIn extends StatefulWidget {
  @override
  _ShopkeeperSignInState createState() => _ShopkeeperSignInState();
}

class _ShopkeeperSignInState extends State<ShopkeeperSignIn> {
  TextEditingController emailC = TextEditingController();
  TextEditingController pswdC = TextEditingController();

  String email = " ";
  String pswd = " ";
  String errorEmail = " ";
  String errorPass = " ";
  String displayMsg = " ";

  void login() async {
    email = emailC.text.toString();
    pswd = pswdC.text.toString();
    if (email == " ") {
      setState(() {
        errorEmail = "Please provide an email";
      });
    } else {
      setState(() {
        errorEmail = " ";
      });
    }
    if (pswd == " ") {
      setState(() {
        errorPass = "Please provide an password";
      });
    } else {
      setState(() {
        errorPass = " ";
      });
    }

    if (errorEmail == " " && errorPass == " ") {
      User user = await userSignIn(email, pswd).catchError((e) {
        setState(() {
          displayMsg = e;
        });
      });
      setState(() {
        if (user != null) {
          Navigator.pushNamed(context, '/shopkeeperHomePage', arguments: {
            'id': user.uid,
            'email': user.email,
            'date': user.metadata,
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopkeeper login"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  errorText: '$errorEmail',
                  hintText: "something@email.com",
                ),
                controller: emailC,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: "password", errorText: '$errorPass '),
                controller: pswdC,
              ),
              ElevatedButton(
                onPressed: login,
                child: Text("Login"),
              ),
              SizedBox(
                height: 30,
              ),
              Text(displayMsg),
            ],
          ),
        ),
      ),
    );
  }
}

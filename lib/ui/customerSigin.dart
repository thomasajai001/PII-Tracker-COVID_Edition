import 'package:flutter/material.dart';
import '../auth.dart';

class CustomerSignIn extends StatefulWidget {
  @override
  _CustomerSignInState createState() => _CustomerSignInState();
}

class _CustomerSignInState extends State<CustomerSignIn> {
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
      displayMsg = await customerSignIn(email, pswd);
      setState(() {
        if (displayMsg == " ") {
          displayMsg = "Login Succesfull";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer registration"),
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

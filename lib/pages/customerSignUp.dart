import 'package:flutter/material.dart';

class CustomerSignUp extends StatefulWidget {
  @override
  _CustomerSignUpState createState() => _CustomerSignUpState();
}

class _CustomerSignUpState extends State<CustomerSignUp> {
  TextEditingController emailC = TextEditingController();
  TextEditingController pswdC = TextEditingController();
  TextEditingController cpswdC = TextEditingController();

  String email = " ";
  String pswd = " ";
  String cpswd = " ";
  String errorcpswd = " ";
  String errorEmail = " ";

  void submit() {
    email = emailC.text.toString();

    pswd = pswdC.text.toString();
    cpswd = cpswdC.text.toString();

    if (pswd != cpswd) {
      setState(() {
        errorcpswd = "Password not MAtchig";
      });
    } else {
      setState(() {
        errorcpswd = " ";
      });
    }
    if (email == "") {
      setState(() {
        errorEmail = "Please provide an email";
      });
    } else {
      setState(() {
        errorEmail = " ";
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
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                errorText: '$errorEmail',
                hintText: "email",
              ),
              controller: emailC,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "password",
              ),
              controller: pswdC,
            ),
            TextField(
              decoration: InputDecoration(
                errorText: '$errorcpswd',
                hintText: "renter password",
              ),
              controller: cpswdC,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: submit,
                child: Text("Register"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

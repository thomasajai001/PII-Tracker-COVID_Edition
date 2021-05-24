import 'package:flutter/material.dart';
import '../../flutterfire/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  bool _passwordVisible;

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
        Alert(
          type: AlertType.error,
          context: context,
          title: e,
          buttons: [
            DialogButton(
              child: Text(
                "Back",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: Colors.red,
            ),
          ],
        ).show();
      });
      setState(() {
        if (user != null) {
          Navigator.pushReplacementNamed(
            context,
            '/customerHomePage',
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer login"),
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
                  labelText: "Email",
                  errorText: errorEmail == " " ? null : '$errorEmail',
                  hintText: "something@email.com",
                ),
                controller: emailC,
              ),
              TextField(
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  labelText: "Password",
                  errorText: errorPass == " " ? null : '$errorPass',
                ),
                controller: pswdC,
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: login,
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

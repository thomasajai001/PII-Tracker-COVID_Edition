import 'package:flutter/material.dart';
import '../flutterfire/auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UserRegister extends StatefulWidget {
  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  TextEditingController emailC = TextEditingController();
  TextEditingController pswdC = TextEditingController();
  TextEditingController cpswdC = TextEditingController();

  String email = "";
  String pswd = "";
  String cpswd = "";
  String errorcpswd = "";
  String errorEmail = "";
  String displayMsg = "";
  bool _passwordVisible;

  void register() async {
    email = emailC.text.toString();
    pswd = pswdC.text.toString();
    cpswd = cpswdC.text.toString();
    if (pswd.isEmpty || cpswd.isEmpty)
      setState(() {
        errorcpswd = "Password cannot be empty";
      });
    else if (pswd != cpswd) {
      setState(() {
        errorcpswd = "Password not Matching";
      });
    } else {
      setState(() {
        errorcpswd = "";
      });
    }
    if (email == "") {
      setState(() {
        errorEmail = "Please provide an email";
      });
    } else {
      setState(() {
        errorEmail = "";
      });
    }

    if (errorEmail == "" && errorcpswd == "") {
      displayMsg = await userRegistration(email, pswd);
      setState(() {
        if (displayMsg == "") {
          Alert(
            type: AlertType.success,
            context: context,
            title: "Registration Complete",
            image: Image.asset('assets/correct.png'),
            buttons: [
              DialogButton(
                child: Text(
                  "Back To Home Page",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, '/selectUserType'),
                color: Color.fromRGBO(0, 179, 134, 1.0),
              ),
            ],
          ).show();
        } else {
          Alert(
            type: AlertType.error,
            context: context,
            title: displayMsg,
            buttons: [
              DialogButton(
                child: Text(
                  "Please Reregister",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                color: Colors.red,
              ),
            ],
          ).show();
        }
      });
    }
  }

  Future<String> getDisplayMessage() async =>
      await userRegistration(email, pswd);

  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox.fromSize(
                  size: Size.fromHeight(60),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    errorText: errorEmail == "" ? null : '$errorEmail',
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
                    labelText: 'Password',
                  ),
                  controller: pswdC,
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
                    errorText: errorcpswd == "" ? null : '$errorcpswd',
                    labelText: "Confirm password",
                  ),
                  controller: cpswdC,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: register,
                  child: Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      )),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

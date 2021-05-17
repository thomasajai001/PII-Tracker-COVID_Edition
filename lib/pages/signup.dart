import 'package:flutter/material.dart';

// page for sign up for both customer and shopkeeper

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  void customerReg() {
    Navigator.pushNamed(context, '/customerRegister');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: customerReg,
            child: Text("Customer Sign Up"),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: null,
            child: Text("shopkeeper Sign Up"),
          )
        ],
      ),
    );
  }
}

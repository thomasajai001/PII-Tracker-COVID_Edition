import 'package:flutter/material.dart';

// page for login for both customer and shopkeeper

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: null,
            child: Text("Sign Up"),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: null,
            child: Text("Login"),
          )
        ],
      ),
    );
  }
}

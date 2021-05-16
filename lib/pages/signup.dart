import 'package:flutter/material.dart';

// page for sign up for both customer and shopkeeper

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: null,
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

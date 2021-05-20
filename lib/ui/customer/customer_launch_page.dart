import 'package:flutter/material.dart';

// page for sign up for both customer and shopkeeper

class CustomerLaunchPage extends StatefulWidget {
  @override
  _CustomerLaunchPageState createState() => _CustomerLaunchPageState();
}

class _CustomerLaunchPageState extends State<CustomerLaunchPage> {
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
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 1.6,
              height: 60,
              child: Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () => {Navigator.pushNamed(context, '/customerSignIn')},
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 1.6,
              height: 60,
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

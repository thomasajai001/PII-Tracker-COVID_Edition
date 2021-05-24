import 'package:flutter/material.dart';
import 'package:pii/Themes/theme2.dart';
import 'package:pii/loading/Cloginloading.dart';
import 'package:pii/loading/Sloading.dart';
import 'package:pii/loading/gCustomerloading.dart';
import 'package:pii/loading/gSloading.dart';
import 'package:pii/ui/customer/customerUpdate.dart';
import 'package:pii/ui/shopkeeper/shopkeeperUpdate.dart';
import './qr/qrGenerator.dart';
import 'ui/customer/customer_sign_in.dart';
import './ui/user_register.dart';
import 'ui/select_user_type.dart';
import 'ui/customer/customer_home_page.dart';
import 'flutterfire/imageHandler.dart';
import 'package:firebase_core/firebase_core.dart';
import './ui/customer/customerGoogleHomePage.dart';
import 'ui/shopkeeper/shopkeeper_sign_in.dart';
import 'ui/shopkeeper/shopkeeper_home_page.dart';
import './ui/shopkeeper/shopkeeperGoogleHomePage.dart';
import './loading/gSloading.dart';
import './Themes/theme3.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Themes/themes.dart';

void main() {
  runApp(MyApp());
}

// ThemeData themeData(ThemeData theme) {
//   // return theme.copyWith(
//   //   textTheme: GoogleFonts.sourceSansProTextTheme(
//   //     theme.textTheme,
//   //   ),
//   // );
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(
      //   scaffoldBackgroundColor: Colors.grey.shade300,
      //   primarySwatch: Colors.red,
      //   accentColor: Colors.indigo,
      // ),
      // theme: themeData(ThemeConfig.lightTheme),
      // darkTheme: themeData(ThemeConfig.darkTheme),
      // darkTheme: darkThemeData(context),
      // theme: theme(),
      // theme: ThemeData(
      //   accentColor: Color(0xff2B7EFF),
      //   primaryColor: Colors.white,
      // ),
      title: "PII Tracker - COVID Edition", home: MyHomePage(),
      // routes for naviagting to different pages
      routes: {
        // page route for login/registration page
        '/selectUserType': (context) => SelectUserType(),
        '/customerRegister': (context) => UserRegister(),
        '/shopkeeperRegister': (context) => UserRegister(),
        '/customerSignIn': (context) => CustomerSignIn(),
        '/shopkeeperSignIn': (context) => ShopkeeperSignIn(),
        '/customerHomePage': (context) => CustomerHomePage(),
        '/customerGoogleHomePage': (context) => CustomerGoogleHomePage(),
        '/shopkeeperHomePage': (context) => ShopkeeperHomePage(),
        '/shopkeeperGoogleHomePage': (context) => ShopkeeperGoogleHomePage(),
        '/imageUpload': (context) => ImageHandler(),
        '/qrGenerator': (context) => QrGenerator(),
        '/customerUpdate': (context) => CustomerUpdate(),
        '/shopkeeperUpdate': (context) => ShopkeeperUpdate(),
        '/cloginloader': (context) => CLoginLoading(),
        '/gcloginloader': (context) => GCLoginLoading(),
        '/sloginloader': (context) => SLoginLoading(),
        '/gsloginloader': (context) => GSLoginLoading(),
      },
    );
  }
}

// route : /  (this is the default home page)
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // initstate invoked at the begining when the app is rebuilt
  void initState() {
    super.initState();

    // FIREBASE INITIALIZATION
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });

    //after delay of 2 seconds it will push to registration.dart in pages folder
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.pushReplacementNamed(context, '/selectUserType');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PII Tracker"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("WELCOME"),
      ),
    );
  }
}

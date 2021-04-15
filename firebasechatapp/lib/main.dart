import 'package:firebase_core/firebase_core.dart';
import 'package:firebasechatapp/helper/authentiance.dart';
import 'package:firebasechatapp/views/chatroomscreen.dart';
import 'package:flutter/material.dart';

import 'helper/helperfunctions.dart';
import 'bildirim.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PushNotificationsManager manager;
  bool userIsLoggedIn = false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      if (value == true) {
        setState(() {
          userIsLoggedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn
          ? ChatRoom()
          : Authenticate(), //  In Authenticate the user is automatically directed to the SignIn Screen if he clicks on
      //  Register Now then the user is send to the SignUp screen by toggling the widgets through signin.dart file
    );
  }
}

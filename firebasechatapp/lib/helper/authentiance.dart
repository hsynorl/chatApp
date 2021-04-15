import 'package:firebasechatapp/views/signin.dart';
import 'package:firebasechatapp/views/signup.dart';
import 'package:flutter/material.dart';

//  Authenticate.dart is used to toggle screens between signUp and signIn screens on pressing Register Now and SignIn Now.

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true; //  At first the user will be shown the signIn screen.

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView);
    } else {
      return SignUp(toggleView);
    }
  }
}

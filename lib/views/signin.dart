import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasechatapp/helper/helperfunctions.dart';
import 'package:firebasechatapp/services/auth.dart';
import 'package:firebasechatapp/services/database.dart';
import 'package:firebasechatapp/views/chatroomscreen.dart';
import 'package:firebasechatapp/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);

      databaseMethods
          .getUserByUserEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(
            snapshotUserInfo.docs[0].data()["name"]);
      });

      setState(() {
        isLoading = true;
      });

      /// 3/4 --> 51:30 changes made not clear??
      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });

      // HelperFunctions.saveUserLoggedInSharedPreference(true);
      // Navigator.pushReplacement(context, MaterialPageRoute(
      //   builder: (context) => ChatRoom()
      // ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              50, // It is used to get rid of the space above in the container and rise below from a height of 50.
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // It means inside this container the contents should be at min(bottom) end.
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)
                                ? null
                                : "Please provide a valid emailid";
                          },
                          controller: emailTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("email")),
                      TextFormField(
                          obscureText: true,
                          validator: (val) {
                            return val.length > 6
                                ? null
                                : "Please provide more than 6 characters";
                          },
                          controller: passwordTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("password")),
                    ],
                  ),
                ),

                SizedBox(height: 8),

                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Forgot Password?", style: simpleTextStyle()),
                  ),
                ),

                SizedBox(height: 8),

                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                      alignment: Alignment
                          .center, //  It centralise the Sign In in the blue box.
                      width: MediaQuery.of(context)
                          .size
                          .width, //  It sets the width of the blue box as the width of the phone.
                      padding: EdgeInsets.symmetric(
                          vertical:
                              20), //  It gives vertical spacing in the blue box around Sign In button.

                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A75BC)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30)),
                      child: Text("Sign In", style: mediumTextStyle())),
                ),

                SizedBox(height: 16),

                Container(
                    alignment: Alignment
                        .center, //  It centralise the Sign In in the blue box.
                    width: MediaQuery.of(context)
                        .size
                        .width, //  It sets the width of the blue box as the width of the phone.
                    padding: EdgeInsets.symmetric(
                        vertical:
                            20), //  It gives vertical spacing in the blue box around Sign In button.

                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Text("Sign In with Google",
                        style: TextStyle(color: Colors.black87, fontSize: 17))),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account? ", style: mediumTextStyle()),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Register now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                    height:
                        50), // It is used to give a space of 50 from bottom.
              ],
            ),
          ),
        ),
      ),
    );
  }
}

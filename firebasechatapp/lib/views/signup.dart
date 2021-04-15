import 'package:firebasechatapp/helper/helperfunctions.dart';
import 'package:firebasechatapp/services/auth.dart';
import 'package:firebasechatapp/services/database.dart';
import 'package:firebasechatapp/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chatroomscreen.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods =
      new AuthMethods(); //  To use the AuthMethods automatic functionality like signUpWithEmailAndPassword(email, password) by passing the correct arguments.
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();

  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signMeUP() {
    if (formKey.currentState.validate()) {
      //  It goes to the key of form and check its current state and validate conditions of text field.

      Map<String, String> userInfoMap = {
        //  It creates a Map datatype of fields name & email fetching from textfields so we can store this in "cloud firestore".
        "name": userNameTextEditingController.text,
        "email": emailTextEditingController.text
      };

      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(
          userNameTextEditingController.text);

      setState(() {
        /// It recreates the whole screen after updating the data.
        isLoading =
            true; //  After validating all the text field isLoading is set to be true to load to the new screen.
      });

      authMethods
          .signUpWithEmailAndPassword(
              emailTextEditingController.text,
              passwordTextEditingController
                  .text) //  AuthMethods inbuilt func. handles signUp details in "firebase athentication."
          .then((val) {
        if (val != null) {
          databaseMethods.uploadUserInfo(
              userInfoMap); // The data input by the user in the textfields are passed as a "Map" to the database.dart file's uploadUserInfo() which uploads it to the cloud firestore.
          //  The name and email values will not be available in the texteditingcontoller once the data is uploaded from the above line.

          HelperFunctions.saveUserLoggedInSharedPreference(true);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  //  It replaces the screen after signup i.e. user cannot go back again to the signup screen.
                  builder: (context) =>
                      ChatRoom() //  In MaterialPageRoute we provided the context of this screen and moved to the ChatRoomScreen.
                  ));
        }
        print(
            "${val.userId}"); //  It will print the value of userId(i.e. UID) present in the firebase console authentication in the android studio's console.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
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
                        key:
                            formKey, // It is like some kind of sort of key for TextFormField
                        child: Column(
                          children: [
                            TextFormField(
                                validator: (val) {
                                  return val.isEmpty || val.length < 2
                                      ? "Please provide a valid username"
                                      : null;
                                },
                                controller: userNameTextEditingController,
                                style: simpleTextStyle(),
                                decoration:
                                    textFieldInputDecoration("Username")),
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
                                decoration:
                                    textFieldInputDecoration("password")),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text("Forgot Password?",
                              style: simpleTextStyle()),
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          signMeUP();
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
                            child: Text("Sign Up", style: mediumTextStyle())),
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
                          child: Text("Sign Up with Google",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 17))),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Already have an account? ",
                              style: mediumTextStyle()),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "Sign In now",
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

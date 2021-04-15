import 'package:shared_preferences/shared_preferences.dart';

// What is shared_preferences??? :- It is used for storing key-value pair in the Android & IOS.
//
// Suppose you wanna save a small value (a flag probably) that you wanna refer later sometime when a
// user launches the application. Then shared preference comes into action.
//
// Shared Preference let you read and write key-value pair in a couple of lines easily.
// It is not a solution to keep complex relational data.

// It is used to save the logged in state of the user, once user had logged in he will be prompted to the last logged in stage only using this shared_preference.
class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEDKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  //  saving data to SharedPreference

  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  //  getting data from SharedPreference

  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserNameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey);
  }
}

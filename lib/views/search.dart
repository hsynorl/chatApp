import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasechatapp/helper/constants.dart';
import 'package:firebasechatapp/services/database.dart';
import 'package:firebasechatapp/views/conversetionscreen.dart';
import 'package:firebasechatapp/widgets/widget.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot
      searchSnapshot; //  In the database.dart file the .getDocuments is fetching the data as Future of type QuerySnapshot.

  initiateSearch() {
    databaseMethods
        .getUserByName(searchTextEditingController
            .text) //  On clicking the search button it will go to the database.dart file's getUserByName() method and will get us the results.
        .then((val) {
      //  The value fetched after clicking the search button from "cloud_firestore" through database.dart file.
      setState(() {
        //  It recreates the whole screen with the updated data like if we searched for something so it will show us all the search results on the screen.
        searchSnapshot =
            val; //  searchSnapshot getting the value of search results(name & email) from the "cloud_firestore" through database.dart file/
      });
    });
  }

  /// create chatroom, send user to conversation screen, pushreplacement
  createChatroomAndStartConversation({String userName}) {
    print("${userName}");
    print("${Constants.myName}");

    /// Don't know what this condition is upto and why this is working just opposite to what i have thought???
    if (userName != Constants.myName) {
      // This if-else is used so that the user does not send message to himself.
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        //  Map of String type key and dynamic value of type array, String etc..
        "users": users,
        "chatroomId": chatRoomId
      };

      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print("You cannot send message to yourself");
    }
  }

  Widget SearchTile({String userName, String userEmail}) {
    //  This is building a container which will show the search result of user (userName & userEmail) with a Message option besides it.
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: mediumTextStyle()),
              Text(userEmail, style: mediumTextStyle())
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30.0)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message", style: mediumTextStyle()),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    /// What does this initState() does??? and what is the difference between initState() and setState()???
    super.initState();
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            //  If the searchSnapshot value is not null then the search list will be build.
            shrinkWrap:
                true, //  Whenever we use ListView inside a column use a shrinkWrap
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                  userName: searchSnapshot.docs[index].data()[
                      "name"], // From here the value of userName and userEmail goes to the SearchTile class constructor.
                  userEmail: searchSnapshot.docs[index].data()["email"]);
            })
        : Container();
  } //  If the searchSnapshot value is null it will show a empty Container as view.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "search username...",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(40)),
                      padding: EdgeInsets.all(12),
                      child: Image.asset("assets/images/search_white.png"),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  //  Everytime any side of the user clicks on "Message" button the RoomId generated should be same.
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    //  This line kind of computes whethere username is sending the message or username2 is sending the message.
    return "$b\_$a"; //  So this function is kind of comparing u of username and u of username2 (username_username2 -> It is an unique RoomId).
  } else {
    return "$a\_$b";

    /// Little bit of confusion.
  }
}

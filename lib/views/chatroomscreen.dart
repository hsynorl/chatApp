import 'package:firebasechatapp/helper/authentiance.dart';
import 'package:firebasechatapp/helper/constants.dart';
import 'package:firebasechatapp/helper/helperfunctions.dart';
import 'package:firebasechatapp/services/auth.dart';
import 'package:firebasechatapp/services/database.dart';
import 'package:firebasechatapp/views/conversetionscreen.dart';
import 'package:firebasechatapp/views/search.dart';
import 'package:firebasechatapp/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomStream;

  Widget chatRoomList() {
    //  This is used to generate a list of chatrooms just like whatsapp
    return StreamBuilder(
      //  We are using stream and snapshot to build a ListView and
      stream: chatRoomStream, //  showing the chatrooms according to a ListTile.
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                   snapshot.data.docs[index].data()["chatroomId"]
                          .toString()
                          .replaceAll("_",
                              "") //  To show the name of the other user in the chatRoomList like whatsapp.
                          .replaceAll(Constants.myName, ""),
                      snapshot.data.docs[index].data()["chatroomId"]);
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        if (value != null) {
          chatRoomStream = value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png", height: 50),
        actions: [
          GestureDetector(
            onTap: () {
              HelperFunctions.saveUserLoggedInSharedPreference(false);
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  //  This generates ListTile of "ChatRooms" on chatroomscreen.
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(40)),
              child: Text("${userName.substring(0, 1).toUpperCase()}",
                  style: simpleTextStyle()),
            ),
            SizedBox(width: 8),
            Text(userName, style: mediumTextStyle())
          ],
        ),
      ),
    );
  }
}

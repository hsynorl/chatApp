import 'package:firebasechatapp/helper/constants.dart';
import 'package:firebasechatapp/services/database.dart';
import 'package:firebasechatapp/widgets/widget.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  Stream chatMessagesStream;

  Widget ChatMessageList() {
    return Container(
      child: StreamBuilder(
        // To show our messages in listview and "Stream" is used whenever we want to display our data in the realtime.
        stream: chatMessagesStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  padding: EdgeInsets.only(bottom: 70),
                  height: MediaQuery.of(context).size.height - 80,
                  child: ListView.builder(
                      //  If it does not have any data so it do not have to build a ListView instead show a blank container.
                      reverse: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return MessageTile(
                            snapshot.data.docs[index].data()[
                                "message"], //  It is fetching the "Message" and the "Sender's name" and returning to the MessageTile() method below.
                            snapshot.data.docs[index].data()["sendBy"] ==
                                Constants.myName);
                      }),
                )
              : Container();
        },
      ),
    );
  }

  sendMessage() {
    //  This is actually sending and adding our messages to the "cloud firestore".

    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };

      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "send message...",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
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
                        child: Image.asset("assets/images/send.png"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  //  Providing the messages in the form of "tiles".
  final String message;
  final bool isSendByMe;
  MessageTile(this.message,
      this.isSendByMe); //  This constructor fetches the "Message" and "Sender".

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe
          ? Alignment.centerRight
          : Alignment.centerLeft, //  To align the messages left or right.
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                    : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)]),
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23))),
        child:
            Text(message, style: TextStyle(color: Colors.white, fontSize: 17)),
      ),
    );
  }
}

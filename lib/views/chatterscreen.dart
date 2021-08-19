import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helperFunctions/sharedpref_helper.dart';
import 'package:flutter_chat_app/servises/database.dart';
import 'package:flutter_chat_app/views/profilepage.dart';
//import 'package:flutter_chat_app/views/homepage.dart';
import 'package:random_string/random_string.dart';
import './homepage.dart';

class ChatterPage extends StatefulWidget {
  final String chatWirhUsername, name;
  ChatterPage(this.chatWirhUsername, this.name);
  @override
  _ChatterPageState createState() => _ChatterPageState();
}

class _ChatterPageState extends State<ChatterPage> {
  late String chatRoomId, messageId = "";
  late Stream<QuerySnapshot<Object?>> messageStream;
  late String? myName, myProfilePic, myEmail, myUsername;
  late String username = "", name = "", email = "", profilePicUrl = "";
  late String currentTime;
  late bool isInstantMessaging;
  TextEditingController controller = TextEditingController();

  getMyInfoFromSharedprefs() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getProfileKey();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    myUsername = await SharedPreferenceHelper().getUsername();

    chatRoomId = getChatRoomIdByUsername(widget.chatWirhUsername, myUsername!);
  }

  String getChatRoomIdByUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else
      return "$a\_$b";
  }

  void getUserProfile(String username) async {
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username);
    email = "${querySnapshot.docs[0]["email"]}";
    username = "${querySnapshot.docs[0]["username"]}";
    name = "${querySnapshot.docs[0]["name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["imgUrl"]}";
    setState(() {});
  }

  void getInstantMessageBool() async
  {
    isInstantMessaging = await SharedPreferenceHelper().getInstantMessages() as bool;
    setState(() {});
  }

  void funkForNothing(){

  }

  addMessage(bool sendclicked) {
    if (controller.text != "") {
      String message = controller.text;
      var lastMessageTime = DateTime.now();
      Map<String, dynamic> messageinfoMap = {
        "message": message,
        "sendBy": myUsername,
        "ts": lastMessageTime,
        "imgUrl": myProfilePic,
      };

      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageinfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "message": message,
          "lastMessageSendTS": lastMessageTime,
          "lsatMessageSendBy": myUsername
        };

        DatabaseMethods().updateLastMessageSent(chatRoomId, lastMessageInfoMap);

        if (sendclicked) {
          controller.text = "";
          messageId = "";
        }
      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe, String timeSent) {
    return Row(
      children: [
        Container(
          child: Container(
            //color: Colors.blue[800],
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.85),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft:
                        sendByMe ? Radius.circular(20) : Radius.circular(0),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    topRight:
                        sendByMe ? Radius.circular(0) : Radius.circular(20)),
                color: sendByMe ? Colors.blue[900] : Colors.white54),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 18,
                    color: sendByMe ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  timeSent,
                  style: TextStyle(
                      color: sendByMe ? Colors.white : Colors.black,
                      fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
    );
  }

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
        stream: messageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.only(bottom: 75, top: 12),
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    Timestamp dd = ds["ts"] as Timestamp;
                    return chatMessageTile(
                        ds["message"],
                        myUsername == ds["sendBy"],
                        dd.toDate().hour.toString() +
                            ":" +
                            dd.toDate().minute.toString());
                  })
              : Center(child: CircularProgressIndicator());
        });
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisonLaunch() async {
    await getMyInfoFromSharedprefs();
    getAndSetMessages();
    getInstantMessageBool();
    getUserProfile(widget.chatWirhUsername);
  }

  @override
  void initState() {
    doThisonLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Row(
          children: [
            profilePicUrl != ""
                ? GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(name, username, profilePicUrl, email, false)));
                  },
                  child: ClipRRect(
                      child: Image.network(
                        profilePicUrl,
                        height: 40,
                        width: 40,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                )
                : Container(
                    width: 40,
                    height: 40,
                  ),
            SizedBox(width: 8),
            Text(widget.name),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.blue[800]?.withOpacity(0.4),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                            // onChanged: (value) {
                            //   isInstantMessaging ? addMessage(false) : funkForNothing();
                            // },
                        controller: controller,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "enter message...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white54.withOpacity(0.5)),
                        ),
                      )),
                      SizedBox(width:  8,),
                      GestureDetector(
                        onTap: () {
                          addMessage(true);
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

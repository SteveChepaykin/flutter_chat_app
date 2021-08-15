// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_chat_app/servises/auth.dart';
import 'package:flutter_chat_app/servises/database.dart';
// import 'package:flutter_chat_app/views/chatterscreen.dart';
import 'package:flutter_chat_app/views/signin.dart';
import 'package:flutter_chat_app/helperFunctions/sharedpref_helper.dart';

import './searchuserslist.dart';
// import './chatroomlist.dart';
import './chatslist.dart';
import './profilepage.dart';
import 'package:flutter_chat_app/servises/pushnotifications.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  TextEditingController textedit = TextEditingController();
  String? myName, myProfilePic, myEmail, myUsername;
  late Stream<QuerySnapshot> chatRoomsStream;
  late Stream<QuerySnapshot> usersStream;

  Future onSearchBtnClick() async {
    isSearching = true;
    usersStream = await DatabaseMethods().getUserByUsername(textedit.text);
    setState(() {});
  }

  Future getMyInfoFromSharedprefs() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getProfileKey();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    myUsername = await SharedPreferenceHelper().getUsername();
  }

  Future getChatRooms() async {
    chatRoomsStream = await DatabaseMethods().getYourChatRooms();
    setState(() {});
  }

  Future onScreenLoaded() async {
    await getMyInfoFromSharedprefs();
    await getChatRooms();
  }

  void setStateOnQuit(){
    setState(() {});
  }

  @override
  void initState() {
    // onScreenLoaded().then((value) => setState(() {}));
    onScreenLoaded().then((value){});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return myUsername != null ?
    Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text("Milky"),
        backgroundColor: Colors.blue[800],
        actions: [
          // InkWell(
          //   onTap: () {
          //     // NotificationApi.showNotification(title: myName, body: "you have a new message from", payload: 'my.name');
          //   },
          //   child: Container(
          //     child: Icon(Icons.download),
          //     //color: Colors.grey[850],
          //     padding: EdgeInsets.symmetric(
          //       horizontal: 16,
          //     ),
          //   ),
          // ),
          // InkWell(
          //   onTap: () {
          //     AuthMethods().signOut().then((s) {
          //       Navigator.pushReplacement(
          //           context, MaterialPageRoute(builder: (context) => SignIn()));
          //     });
          //   },
          //   child: Container(
          //     child: Icon(Icons.exit_to_app),
          //     //color: Colors.grey[850],
          //     padding: EdgeInsets.symmetric(
          //       horizontal: 16,
          //     ),
          //   ),
          // ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(myName.toString(), myUsername.toString(), myProfilePic.toString(), myEmail.toString())));
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,),
              child: Icon(Icons.person,
              //color: Colors.grey[850],
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          Row(
            children: [
              isSearching
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          isSearching = false;
                          textedit.text = "";
                        });
                      },
                      child: Padding(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white54,
                        ),
                        padding: EdgeInsets.only(right: 10),
                      ))
                  : Container(),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(top: 16, bottom: 30),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      border: Border.all(
                          color: Colors.blue.shade800,
                          width: 2.0,
                          style: BorderStyle.solid),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: textedit,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          decoration: InputDecoration(
                            labelText: "username",
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.white54),
                          ),
                        )),
                        GestureDetector(
                            onTap: () {
                              if (textedit.text != "") {
                                onSearchBtnClick();
                              }
                            },
                            child: Icon(
                              Icons.search,
                              color: Colors.white54,
                            )),
                      ],
                    )),
              ),
            ],
          ),
          isSearching ? SearchUsersList(myUsername!, usersStream) : ChatsList(myUsername!, chatRoomsStream),
        ]),
      ),
    ) :
    Container();
  }
}

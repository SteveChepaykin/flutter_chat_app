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

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool blackTheme = true;
  bool showMessagesInstant = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text("settings"),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        margin: EdgeInsets.all(12),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "black theme",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Switch(
                    value: blackTheme,
                    onChanged: (value) {
                      setState(() {
                        blackTheme = value;
                      });
                    },
                    activeColor: Colors.blue[800],
                    activeTrackColor: Colors.blue[400],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "show messages instantly",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Switch(
                    value: showMessagesInstant,
                    onChanged: (value) {
                      setState(() {
                        showMessagesInstant = value;
                      });
                    },
                    activeColor: Colors.blue[800],
                    activeTrackColor: Colors.blue[400],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

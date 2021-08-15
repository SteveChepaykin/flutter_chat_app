import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/servises/auth.dart';
import 'package:flutter_chat_app/views/signin.dart';
import 'package:flutter_chat_app/helperFunctions/sharedpref_helper.dart';
import 'package:flutter_chat_app/servises/database.dart';
//import 'package:flutter_chat_app/views/homepage.dart';
import 'package:random_string/random_string.dart';

class ProfilePage extends StatefulWidget {
  final String myName, myUsername, myProfilepic, myEmail;
  ProfilePage(this.myName, this.myUsername, this.myProfilepic, this.myEmail);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              AuthMethods().signOut().then((s) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              });
            },
            child: Row(
              children: [
                Text("quit", style: TextStyle(fontSize: 20),),
                Container(
                  child: Icon(Icons.exit_to_app),
                  //color: Colors.grey[850],
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
        title: Text(
          "Your profile",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 100),
        child: Center(
          child: Column(
            children: [
              ClipRRect(
                child: Image.network(
                  widget.myProfilepic,
                  width: 100,
                  height: 100,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                widget.myName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "username: " + widget.myUsername,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "email: " + widget.myEmail,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

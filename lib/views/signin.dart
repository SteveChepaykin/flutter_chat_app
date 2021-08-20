//import 'dart:ui';

import "package:flutter/material.dart";
import 'package:flutter_chat_app/servises/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text("Milky"),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.blue.shade800,), borderRadius: BorderRadius.circular(12)),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                padding: EdgeInsets.only(left: 12),
            child: Expanded(
              child: TextField(
                style: TextStyle(color: Colors.white, fontSize: 20),
                controller: editingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                    hintText: "enter your username",
                    hintStyle:
                        TextStyle(color: Colors.white54, fontSize: 16)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (editingController.text != "") {
                AuthMethods().signInWithGoogle(context, editingController.text);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue[800]),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "sign in with Google",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

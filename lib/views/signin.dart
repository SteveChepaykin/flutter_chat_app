import "package:flutter/material.dart";
import 'package:flutter_chat_app/servises/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
          child: GestureDetector(
            onTap: (){
              AuthMethods().signInWithGoogle(context);
            },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.blue[800]),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "sign in with Google",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      )),
    );
  }
}

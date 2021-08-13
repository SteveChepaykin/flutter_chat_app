import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

import './chatroomlist.dart';

class ChatsList extends StatelessWidget {
  final Stream<QuerySnapshot> chatRoomsStream;
  final String myUsername;

  ChatsList(this.myUsername, this.chatRoomsStream);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return ChatRoomList(
                      ds["message"], ds.id, myUsername.toString());
                },
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length)
            : Center(
                child: Text(
                "No contacts yet!",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 30,
                ),
              ));
      },
    );
  }
}

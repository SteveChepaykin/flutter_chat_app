import "package:flutter/material.dart";
import 'package:flutter_chat_app/servises/database.dart';
import 'package:flutter_chat_app/views/chatterscreen.dart';

class SearchListTile extends StatelessWidget {

final String myUsername, profileUrl, name, username, email;

SearchListTile(this.myUsername, this.name, this.username, this.email, this.profileUrl);

@override
Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          var chatRoomId = getChatRoomIdByUsername(myUsername, username);
          Map<String, dynamic> chatRoomInfoMap = {
            "users": [myUsername, username],
          };

          DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatterPage(username, name)));
        },
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(style: BorderStyle.none),
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      profileUrl,
                      width: 70,
                      height: 70,
                    )),
                SizedBox(
                  width: 12,
                ),
                Column(
                  children: [
                    Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Text(
                      email,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ],
            )));
  }

  String getChatRoomIdByUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else
      return "$a\_$b";
  }
}
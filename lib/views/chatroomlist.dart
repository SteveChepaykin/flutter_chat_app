import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
// import 'package:flutter_chat_app/servises/auth.dart';
import 'package:flutter_chat_app/servises/database.dart';
import 'package:flutter_chat_app/views/chatterscreen.dart';
// import 'package:flutter_chat_app/views/signin.dart';
// import 'package:flutter_chat_app/helperFunctions/sharedpref_helper.dart';

class ChatRoomList extends StatefulWidget {
  final String lastMessageSent, chatRoomId, myUsername, timeSent;
  ChatRoomList(
      this.lastMessageSent, this.chatRoomId, this.myUsername, this.timeSent,
      {Key? key})
      : super(key: key);
  @override
  _ChatRoomListState createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  late String profilePicUrl = "", name = "", username = "";

  Future getThisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username);
    name = "${querySnapshot.docs[0]["name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["imgUrl"]}";
  }

  Future getThisUserInfoAsync() async {
    await getThisUserInfo();
  }

  @override
  void initState() {
    getThisUserInfoAsync().then((value) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return profilePicUrl != ""
    //     ? GestureDetector(
    //         onTap: () {
    //           Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => ChatterPage(username, name)));
    //         },
    //         child: Container(
    //           margin: EdgeInsets.only(bottom: 12),
    //           decoration: BoxDecoration(
    //             border: Border.all(style: BorderStyle.none),
    //             borderRadius: BorderRadius.circular(12),
    //           ),

    return profilePicUrl != ""
        ? ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Image.network(
                profilePicUrl,
                width: 60,
                height: 60,
              ),
            ),
            title: Text(
              name,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "> " + widget.lastMessageSent,
              style: TextStyle(color: Colors.white, fontSize: 20),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            trailing: Text(
                widget.timeSent,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatterPage(username, name)));
            },
          )

        //     child: Row(
        //       children: [
        //         ClipRRect(
        //             borderRadius: BorderRadius.all(Radius.circular(12)),
        //             child: Image.network(
        //               profilePicUrl,
        //               width: 70,
        //               height: 70,
        //             )),
        //         SizedBox(
        //           width: 16,
        //         ),
        //         Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text(
        //               name,
        //               style: TextStyle(
        //                   fontSize: 24,
        //                   color: Colors.white,
        //                   fontWeight: FontWeight.bold),
        //             ),
        //             SizedBox(
        //               height: 4,
        //             ),
        //             Container(
        //               child: Container(
        //                 constraints: BoxConstraints(
        //                     maxWidth:
        //                         MediaQuery.of(context).size.width * 0.5),
        //                 child: Text(
        //                   "> " + widget.lastMessageSent,
        //                   style: TextStyle(color: Colors.white, fontSize: 20),
        //                   overflow: TextOverflow.ellipsis,
        //                   maxLines: 2,
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //         SizedBox(
        //           width: 8,
        //         ),
        //         Expanded(
        //           child: Container(
        //             height: 55,
        //             alignment: Alignment.bottomRight,
        //             child: Text(
        //               widget.timeSent,
        //               style: TextStyle(color: Colors.white, fontSize: 18),
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // )
        : Container();
  }
}

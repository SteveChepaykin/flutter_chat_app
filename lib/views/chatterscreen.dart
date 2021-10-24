import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helperFunctions/sharedpref_helper.dart';
import 'package:flutter_chat_app/servises/database.dart';
import 'package:flutter_chat_app/views/profilepage.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:flutter_chat_app/views/homepage.dart';
import 'package:random_string/random_string.dart';

class ChatterPage extends StatefulWidget {
  final String chatWirhUsername, name;
  ChatterPage(this.chatWirhUsername, this.name);
  @override
  _ChatterPageState createState() => _ChatterPageState();
}

class _ChatterPageState extends State<ChatterPage> {
  late String chatRoomId, messageId = "";
  late Stream<QuerySnapshot<Object?>> messageStream =
      Stream<QuerySnapshot<Object?>>.empty();
  late String? myName, myProfilePic, myEmail, myUsername;
  late String username = "",
      name = "",
      email = "",
      profilePicUrl = "",
      token = "";
  late String currentTime;
  late bool isInstantMessaging;
  String messageTitle = "Empty";
  String notificationAlert = "alert";
  //bool answering = false;
  String midReplyMessage = "";
  String replyMessage = "";
  String pictureUrl = "";
  String replyPictureUrl = "";
  late XFile? pictureFile;
  late Uint8List? pictureAsBytes = null;

  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
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
    this.username = "${querySnapshot.docs[0]["username"]}";
    name = "${querySnapshot.docs[0]["name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["imgUrl"]}";
    token = "${querySnapshot.docs[0]["token"]}";
    setState(() {});
  }

  void getInstantMessageBool() async {
    isInstantMessaging = (await SharedPreferenceHelper().getInstantMessages())!;
    setState(() {});
  }

  void funkForNothing() {}

  Future<void> pickImage(ImageSource source) async {
    XFile? selected = await ImagePicker().pickImage(source: source);
    if (selected != null) {
      var data = await selected.readAsBytes();
      await FirebaseStorage.instance.ref(selected.name).putData(data);
      pictureUrl =
          await FirebaseStorage.instance.ref(selected.name).getDownloadURL();
      setState(() {
        pictureFile = selected;
        pictureAsBytes = data;
      });
    }
  }

  addMessage(bool sendclicked) {
    if (controller.text != "" || pictureUrl != "") {
      String message = controller.text;
      var lastMessageTime = DateTime.now();
      Map<String, dynamic> messageinfoMap = {
        "message": message,
        "sendBy": myUsername,
        "ts": lastMessageTime,
        "imgUrl": myProfilePic,
        "toToken": token,
        "reply": replyMessage != "" ? replyMessage : "",
        "pictureUrl": pictureUrl != "" ? pictureUrl : "",
        "replyPicture": replyPictureUrl != "" ? replyPictureUrl : ""
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
          "lsatMessageSendBy": myName
        };

        DatabaseMethods().updateLastMessageSent(chatRoomId, lastMessageInfoMap);

        if (sendclicked) {
          setState(() {
            controller.text = "";
            messageId = "";
            replyMessage = "";
            //replyPictureUrl = "";
            pictureUrl = "";
            pictureAsBytes = null;
          });
        }
      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe, String timeSent,
      {String replyMessage = "",
      String pictureUrl = "",
      }) {
    return GestureDetector(
      onLongPressUp: () {
        setState(() {
          midReplyMessage = message;
          //replyPictureUrl = replyPictureurl;
        });
      },
      child: Row(
        children: [
          Container(
            child: Container(
              //color: Colors.blue[800],
              constraints: BoxConstraints(
                  maxWidth: pictureUrl == "" ? MediaQuery.of(context).size.width * 0.85 : MediaQuery.of(context).size.width * 0.6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft:
                          sendByMe ? Radius.circular(12) : Radius.circular(0),
                      bottomRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      topRight:
                          sendByMe ? Radius.circular(0) : Radius.circular(12)),
                  color: sendByMe ? Colors.blue[900] : Colors.white54),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  replyMessage != ""
                      ? Container(
                          margin: EdgeInsets.only(bottom: 4),
                          padding: EdgeInsets.all(6),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: sendByMe
                                  ? Colors.indigo[800]
                                  : Colors.white54),
                          child: 
                              replyMessage != ""
                                  ? Text(
                                      replyMessage,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: sendByMe
                                              ? Colors.white70
                                              : Colors.black87),
                                    )
                                  : Container(
                                      width: 0,
                                    ),
                              // replyPictureurl != ""
                              //     ? Image.network(
                              //         replyPictureurl,
                              //         height: 60,
                              //         width: 60,
                              //       )
                              //     : Container(
                              //         width: 0,
                              //       )
                            
                          // child: RichText(text: TextSpan(
                          //   style: DefaultTextStyle.of(context).style,
                          //   children: [TextSpan(text: "replying: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          //   TextSpan(text: replyMessage, style: TextStyle(fontSize: 12))],

                          // )),
                        )
                      : Container(
                          width: 0,
                        ),
                  pictureUrl != ""
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            pictureUrl,

                            // width: 200,
                            // height: 200,
                          ),
                        )
                      : Container(
                          width: 0,
                        ),
                  SizedBox(
                    height: 2,
                  ),
                  Linkify(
                    onOpen: (link) async {
                      if (await canLaunch(link.url)) {
                        await launch(link.url);
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                    text: message,
                    //linkifiers: [UrlLinkifier()],
                    options: LinkifyOptions(looseUrl: true, humanize: false),
                    style: TextStyle(
                      fontSize: 20,
                      color: sendByMe ? Colors.white : Colors.black,
                    ),
                    linkStyle: TextStyle(
                        color: sendByMe ? Colors.white : Colors.black,
                        decoration: TextDecoration.underline),
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
      ),
    );
  }

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
        stream: messageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.only(bottom: 90, top: 12),
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    Map<String, dynamic> dsm =
                        ds.data() as Map<String, dynamic>;
                    Timestamp dd = ds["ts"] as Timestamp;
                    return chatMessageTile(
                      ds["message"],
                      myUsername == ds["sendBy"],
                      dd.toDate().minute.toString().length > 1
                          ? dd.toDate().hour.toString() +
                              ":" +
                              dd.toDate().minute.toString()
                          : dd.toDate().hour.toString() +
                              ":0" +
                              dd.toDate().minute.toString(),
                      replyMessage: dsm.containsKey("reply") ? ds["reply"] : "",
                      pictureUrl:
                          dsm.containsKey("pictureUrl") ? ds["pictureUrl"] : "",
                      //replyPictureurl: dsm.containsKey("replyPictrure") ? ds["replyPicture"] : "",
                    );
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
    // _firebaseMessaging.configure(
    //   onMessage: (message) async {
    //     setState(() {
    //       messageTitle = message["notification"]["title"];
    //       notificationAlert = "New Notification Alert";
    //     });
    //   },
    //   onResume: (message) async {
    //     setState(() {
    //       messageTitle = message["data"]["title"];
    //       notificationAlert = "Application opened from Notification";
    //     });
    //   },
    // );
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            name,
                            username,
                            profilePicUrl,
                            email,
                            false,
                          ),
                        ),
                      );
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
            midReplyMessage == "" ? Text(widget.name) : Text(""),
            midReplyMessage != ""
                ? Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // SizedBox(
                        //   width: ,
                        // ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              Clipboard.setData(
                                  new ClipboardData(text: midReplyMessage));
                              midReplyMessage = "";
                            });
                          },
                          child: Container(
                            child: Icon(Icons.copy_all_outlined),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              replyMessage = midReplyMessage;
                              midReplyMessage = "";
                            });
                          },
                          child: Container(
                            child: Icon(Icons.call_missed_outgoing),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              midReplyMessage = "";
                            });
                          },
                          child: Container(
                            child: Icon(Icons.close_outlined),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
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
                  color: Colors.blue[800]?.withOpacity(0.6),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    replyMessage != "" || pictureAsBytes != null
                        ? Row(
                            children: [
                              Expanded(
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.85),
                                  child: Text(
                                    "reply: $replyMessage",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white60),
                                    maxLines: pictureAsBytes != null ? 4 : 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              pictureAsBytes != null
                                  ? Image.memory(pictureAsBytes!,
                                      height: 100, width: 100)
                                  : Container(
                                      width: 0,
                                    ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    replyMessage = "";
                                    pictureAsBytes = null;
                                    replyPictureUrl = "";
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Icon(
                                    Icons.close_outlined,
                                    color: Colors.white70,
                                  ),
                                  padding: EdgeInsets.only(left: 12,),
                                ),
                              ),
                              SizedBox(width: 12,)
                            ],
                          )
                        : Container(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: TextField(
                          // onChanged: (value) {
                          //   isInstantMessaging ? addMessage(false) : funkForNothing();
                          // },
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          minLines: 1,
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
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            addMessage(true);
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            pickImage(ImageSource.gallery);
                          },
                          child: Icon(
                            Icons.image_outlined,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            pickImage(ImageSource.camera);
                          },
                          child: Icon(
                            Icons.photo_camera,
                            color: Colors.white,
                          ),
                        )
                        //IconButton(onPressed: () {}, icon: Icon(Icons.image_outlined))
                      ],
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

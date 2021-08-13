import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/helperFunctions/sharedpref_helper.dart';
// import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  addUserInfoToDB(String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSent(
      String chatRoomId, Map<String, Object?> messageinfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(messageinfoMap);
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapShot.exists)
      return true;
    else
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getYourChatRooms() async {
    String? myName = await SharedPreferenceHelper().getUsername();
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageSendTS", descending: true)
        .where("users", arrayContains: myName)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getUserByUsername(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }
}

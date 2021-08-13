import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helperFunctions/sharedpref_helper.dart';
import 'package:flutter_chat_app/servises/database.dart';
import 'package:flutter_chat_app/views/homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods{

  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = 
       await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
    UserCredential result = await _firebaseAuth.signInWithCredential(credential);
    User? userDetails = result.user;

    if (userDetails != null) {
      if (userDetails.email is String) SharedPreferenceHelper().saveUserEmail(userDetails.email!);
      SharedPreferenceHelper().saveId(userDetails.uid);
      if (userDetails.displayName is String) SharedPreferenceHelper().saveDisplayName(userDetails.displayName!);
      if (userDetails.photoURL is String) SharedPreferenceHelper().saveProfileKey(userDetails.photoURL!);
      SharedPreferenceHelper().saveUsername(userDetails.email!.replaceAll("@gmail.com", ""));

      Map<String, dynamic> userInfoMap = {"email": userDetails.email, "username": userDetails.email!.replaceAll("@gmail.com", ""), "name": userDetails.displayName, "imgUrl": userDetails.photoURL};

      DatabaseMethods().addUserInfoToDB(userDetails.uid, userInfoMap).then((value){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));});
    }
  }

  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await auth.signOut();
  }
}
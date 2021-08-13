import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{

  static String userIdKey = "USERKEY";
  static String usernameKey = "USERNAMEKEY";
  static String displayNameKey = "DISPLAYNAMEKEY";
  static String userMailKey = "USERMAILKEY";
  static String userProfileKey = "USERPROFILEKEY";

  Future<bool> saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(usernameKey, username);
  }
  Future<bool> saveUserEmail(String useremail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userMailKey, useremail);
  }
  Future<bool> saveId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, id);
  }
  Future<bool> saveDisplayName(String displayname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(displayNameKey, displayname);
  }
  Future<bool> saveProfileKey(String profilekey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfileKey, profilekey);
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }
  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userMailKey);
  }
  Future<String?> getIdKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }
  Future<String?> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(displayNameKey);
  }
  Future<String?> getProfileKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfileKey);
  }
}
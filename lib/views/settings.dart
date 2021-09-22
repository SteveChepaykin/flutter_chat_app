import "package:flutter/material.dart";
// import 'package:flutter_chat_app/views/chatterscreen.dart';
import 'package:flutter_chat_app/helperFunctions/sharedpref_helper.dart';

// import './chatroomlist.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool blackTheme = true;
  bool showMessagesInstant = false;

  void initState() {
    getSwitchValues();
    super.initState();
  }

  void getSwitchValues() async {
    blackTheme = await SharedPreferenceHelper().getDarkMode() as bool;
    showMessagesInstant = await SharedPreferenceHelper().getInstantMessages() as bool;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text("settings"),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        margin: EdgeInsets.all(12),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "black theme",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Switch(
                    value: blackTheme,
                    onChanged: (value) {
                      setState(() {
                        blackTheme = value;
                        SharedPreferenceHelper().saveDarkMode(blackTheme);
                      });
                    },
                    activeColor: Colors.blue[800],
                    activeTrackColor: Colors.blue[400],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "show messages instantly",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Switch(
                    value: showMessagesInstant,
                    onChanged: (value) {
                      setState(() {
                        showMessagesInstant = value;
                        SharedPreferenceHelper().saveInstantMessages(value);
                      });
                    },
                    activeColor: Colors.blue[800],
                    activeTrackColor: Colors.blue[400],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

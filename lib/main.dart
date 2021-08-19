import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helperFunctions/sharedpref_helper.dart';
import 'package:flutter_chat_app/servises/auth.dart';
import 'package:flutter_chat_app/views/homepage.dart';
import 'package:flutter_chat_app/views/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_app/views/myTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //bool ddrkModeOn = SharedPreferenceHelper().getDarkMode() as bool;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Milky',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder(
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return SignIn();
          }
        },
        future: AuthMethods().getCurrentUser(),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

import './searchlisttile.dart';

class SearchUsersList extends StatelessWidget {

  final Stream<QuerySnapshot> usersStream;
  final String myUsername;

  SearchUsersList(this.myUsername, this.usersStream);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
            stream: usersStream,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data!.docs[index];
                        return SearchListTile(myUsername, ds["name"], ds["username"], ds["email"], ds["imgUrl"]);
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
          );
  }
}
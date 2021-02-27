import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discourse/pages/ChatRoom.dart';
import 'package:discourse/pages/CreateDebate.dart';
import 'package:discourse/pages/LoginScreen.dart';
import 'package:discourse/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  final Services services = Services();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final User user;

  HomePage({Key key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'Discourse',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.power_settings_new_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                widget._auth
                    .signOut()
                    .then((value) => widget._googleSignIn.signOut())
                    .then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        ((Route route) => false)));
              })
        ],
      ),
      body: Container(
        color: Colors.yellow,
        child: StreamBuilder<QuerySnapshot>(
            stream: widget.db.collection("groups").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              return snapshot.data.size > 0
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              snapshot.data.docs.elementAt(index)["title"]),
                          subtitle: Text(snapshot.data.docs
                              .elementAt(index)["description"]),
                          trailing: Icon(
                            Icons.arrow_right_alt,
                            color: Colors.black,
                          ),
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => ChatRoom(
                                title: snapshot.data.docs
                                    .elementAt(index)["title"],
                                id: snapshot.data.docs.elementAt(index)["id"],
                                user: widget.user,
                              ),
                            ));
                          },
                        );
                      })
                  : Center(
                      child: Text(
                        'Nothing Here',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        label: Text("Create a Discussion"),
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => CreateDebate(),
          ));
        },
      ),
    );
  }
}

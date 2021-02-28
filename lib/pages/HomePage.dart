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

  HomePage({this.user});

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
                            final navigate = () =>
                                Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => ChatRoom(
                                    title: snapshot.data.docs
                                        .elementAt(index)["title"],
                                    id: snapshot.data.docs
                                        .elementAt(index)["id"],
                                    user: widget.user,
                                  ),
                                ));
                            widget.db
                                .collection("groups")
                                .doc(snapshot.data.docs.elementAt(index)["id"])
                                .collection("users")
                                .doc(widget.user.uid)
                                .get()
                                .then((value) {
                              if (!value.exists) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    String _selected;
                                    return Dialog(
                                      child: StatefulBuilder(
                                        builder: (BuildContext context,
                                            void Function(void Function())
                                                setState) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0, bottom: 16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "What's your Inclination?",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Wrap(
                                                    children: [
                                                      ChoiceChip(
                                                        avatar: Icon(
                                                          Icons.done,
                                                          color: Colors.green,
                                                        ),
                                                        label: Text(
                                                          'For',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                        selected:
                                                            _selected == "for",
                                                        onSelected:
                                                            (bool selected) {
                                                          setState(() {
                                                            if (selected) {
                                                              _selected = "for";
                                                            } else
                                                              _selected = '';
                                                          });
                                                        },
                                                        selectedColor:
                                                            Colors.black,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      ChoiceChip(
                                                        label: Text('Neutral',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueAccent)),
                                                        selected: _selected ==
                                                            "neutral",
                                                        onSelected:
                                                            (bool selected) {
                                                          setState(() {
                                                            if (selected) {
                                                              _selected =
                                                                  "neutral";
                                                            } else
                                                              _selected = '';
                                                          });
                                                        },
                                                        selectedColor:
                                                            Colors.black,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      ChoiceChip(
                                                        avatar: Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        ),
                                                        label: Text('Against',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red)),
                                                        selected: _selected ==
                                                            "against",
                                                        onSelected:
                                                            (bool selected) {
                                                          setState(() {
                                                            if (selected) {
                                                              _selected =
                                                                  "against";
                                                            } else
                                                              _selected = '';
                                                          });
                                                        },
                                                        selectedColor:
                                                            Colors.black,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                MaterialButton(
                                                    minWidth: 200,
                                                    color: Colors.black,
                                                    child: Icon(
                                                      Icons.arrow_right_alt,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      widget.services.setStatus(
                                                          widget.user,
                                                          snapshot.data.docs
                                                              .elementAt(
                                                                  index)["id"],
                                                          _selected);
                                                      Navigator.of(context)
                                                          .pop();
                                                      navigate();
                                                    })
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              } else {
                                navigate();
                              }
                            });
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

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discourse/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  final Services services = Services();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final String title;
  final String id;
  final User user;

  ChatRoom({Key key, this.title, this.id, this.user}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(widget.title, style: TextStyle(color: Colors.black)),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.yellow,
                child: StreamBuilder<QuerySnapshot>(
                    stream: widget.db
                        .collection("groups")
                        .doc(widget.id)
                        .collection("chats")
                        .orderBy("date")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      return snapshot.data.size > 0
                          ? ListView.builder(
                              controller: widget._scrollController,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                    title: Text(
                                      snapshot.data.docs
                                          .elementAt(index)
                                          .data()["sender"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: snapshot.data.docs
                                                      .elementAt(index)
                                                      .data()["status"] ==
                                                  "for"
                                              ? Colors.green
                                              : snapshot.data.docs
                                                          .elementAt(index)
                                                          .data()["status"] ==
                                                      "against"
                                                  ? Colors.red
                                                  : Colors.blueAccent),
                                    ),
                                    subtitle: Text(
                                      snapshot.data.docs
                                          .elementAt(index)
                                          .data()["content"],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    trailing: Text(
                                      readTimestamp(snapshot.data.docs
                                          .elementAt(index)
                                          .data()["date"]),
                                    ));
                              },
                            )
                          : Center(
                              child: Text(
                                'Nothing Here',
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                    }),
              ),
            ),
            ListTile(
              title: TextField(
                controller: widget._controller,
                decoration: InputDecoration(hintText: "Type Something..."),
              ),
              trailing: IconButton(
                onPressed: () {
                  widget.services
                      .send(widget.id, widget._controller.text, widget.user);
                  widget._controller.text = '';
                },
                icon: Icon(
                  Icons.send,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ));
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat.jm('en_IN');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }
}

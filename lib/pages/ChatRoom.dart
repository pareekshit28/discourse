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

  ChatRoom({this.title, this.id, this.user});

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
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontFamily: "Source Sans Pro",
              fontWeight: FontWeight.w700),
        ),
        bottomOpacity: 0,
        shadowColor: Colors.white10,
      ),
      backgroundColor: Colors.yellow,
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(7, 18, 5, 5),
                child: StreamBuilder<QuerySnapshot>(
                    stream: widget.db
                        .collection("groups")
                        .doc(widget.id)
                        .collection("chats")
                        .orderBy("date")
                        .snapshots(),
                    builder: (context, snapshot) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (widget._scrollController.hasClients) {
                          widget._scrollController.jumpTo(widget
                              ._scrollController.position.maxScrollExtent);
                        }
                      });
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      return snapshot.data.size > 0
                          ? ListView.builder(
                              controller: widget._scrollController,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 7),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(15),
                                                topLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15)),
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
                                                    : Colors.blueAccent,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                snapshot.data.docs
                                                    .elementAt(index)
                                                    .data()["sender"],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  letterSpacing: 1.1,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 1.5,
                                              ),
                                              Text(
                                                snapshot.data.docs
                                                    .elementAt(index)
                                                    .data()["content"],
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 7),
                                            child: Text(
                                              readTimestamp(snapshot.data.docs
                                                  .elementAt(index)
                                                  .data()["date"]),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          flex: 1)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(),
                                );
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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40)),
                  color: Colors.yellow //.fromRGBO(118, 4, 158, 0.78),
                  ),
            ),
          ),
          Container(
            color: Colors.yellow, //.fromRGBO(118, 4, 158, 0.78),
            padding: EdgeInsets.fromLTRB(16, 10, 10, 10),
            child: ClipRRect(
              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(-20, 0, -20, 0),
                title: TextField(
                  onTap: () {
                    widget._scrollController.jumpTo(
                        widget._scrollController.position.maxScrollExtent);
                  },
                  controller: widget._controller,
                  maxLines: 5,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  buildCounter: null,
                  decoration: InputDecoration(
                      hintText: "Type Something...",
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      counterText: "",
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(28))),
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
              ),
            ),
          )
        ],
      ),
    );
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

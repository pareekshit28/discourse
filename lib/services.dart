import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Services extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Uuid uuid = Uuid();

  void send(String id, String content, User user) {
    db
        .collection("groups")
        .doc(id)
        .collection("users")
        .doc(user.uid)
        .get()
        .then((value) {
      db.collection("groups").doc(id).collection("chats").add({
        "content": content,
        "sender": user.displayName,
        "sid": user.uid,
        "status": value.data()["status"],
        "date": DateTime.now().millisecondsSinceEpoch
      });
    });
  }

  void create(String title, String description) {
    String id = uuid.v4();
    db.collection("groups").doc(id).set({
      "title": title,
      "description": description,
      "date": DateTime.now().millisecondsSinceEpoch,
      "id": id
    });
  }

  void setStatus(User user, String gid, String status) {
    db
        .collection("groups")
        .doc(gid)
        .collection("users")
        .doc(user.uid)
        .set({"status": status});
  }
}

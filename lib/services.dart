import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Services extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Uuid uuid = Uuid();

  void send(String id, String content, String name) {
    db.collection("groups").doc(id).collection("chats").add({
      "content": content,
      "sender": name,
      "date": DateTime.now().millisecondsSinceEpoch
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
}
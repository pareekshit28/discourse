import 'package:discourse/services.dart';
import 'package:flutter/material.dart';

class CreateDebate extends StatelessWidget {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();
  final Services services = Services();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Create',
          style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontFamily: "Source Sans Pro",
              fontWeight: FontWeight.w700),
        ),
        bottomOpacity: 0,
        shadowColor: Colors.white10,
      ),
      body: Container(
        color: Colors.yellow,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Topic",
                style: TextStyle(
                    fontSize: 19,
                    fontFamily: "Source Sans Pro",
                    fontWeight: FontWeight.w900),
              ),
              TextField(
                controller: _titlecontroller,
                textCapitalization: TextCapitalization.words,
                buildCounter: null,
                cursorHeight: 25.0,
                decoration: InputDecoration(
                  counterText: "",
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 10, top: 15, left: 0),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Description",
                style: TextStyle(
                    fontSize: 19,
                    fontFamily: "Source Sans Pro",
                    fontWeight: FontWeight.w900),
              ),
              TextField(
                controller: _descriptioncontroller,
                maxLines: 5,
                minLines: 1,
                cursorHeight: 25.0,
                textCapitalization: TextCapitalization.sentences,
                buildCounter: null,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 10, top: 15, left: 0),
                  counterText: "",
                ),
                style: TextStyle(fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        label: Text(
          "Done",
          style: TextStyle(fontSize: 18),
        ),
        icon: Icon(Icons.done),
        onPressed: () {
          services.create(_titlecontroller.text, _descriptioncontroller.text);
          Navigator.of(context).pop();
        },
        elevation: 0,
      ),
    );
  }
}

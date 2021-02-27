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
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.yellow,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Title"),
              TextField(
                controller: _titlecontroller,
              ),
              SizedBox(
                height: 30,
              ),
              Text("Description"),
              TextField(
                controller: _descriptioncontroller,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        label: Text("Done"),
        icon: Icon(Icons.done),
        onPressed: () {
          services.create(_titlecontroller.text, _descriptioncontroller.text);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

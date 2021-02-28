import 'package:flutter/material.dart';

void main() {
  runApp(ProfilePage());
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.yellow,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 160),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.black,
                    // backgroundImage: AssetImage('assets/images/1.png'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'MY FULL NAME',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        // fontFamily: 'Source Sans Pro',
                        letterSpacing: 3.5,
                        fontWeight: FontWeight.w600,
                        height: 1.5),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'A short one line description ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        // fontFamily: 'Source Sans Pro',
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w400,
                        height: 1.5),
                  ),
                  Container(
                    height: 0.5,
                    width: 150,
                    color: Colors.black,
                    margin: EdgeInsets.symmetric(vertical: 20),
                  ),
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      "Your Discussions:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.only(left: 35, right: 35, top: 150),
                    color: Colors.yellow,
                    child: ListTile(
                      leading: Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                      title: Text(
                        "dangerdaniel@git.com",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          // fontFamily: 'Source Sans Pro',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

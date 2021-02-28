import 'package:discourse/pages/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  ProfilePage({this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.yellow,
          title: Text(
            "Profile",
            style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontFamily: "Source Sans Pro",
                fontWeight: FontWeight.w700),
          ),
        ),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.black,
                  child: ClipRRect(
                    child: Image(
                        image: NetworkImage(widget.user.photoURL, scale: 0.63)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  widget.user.displayName,
                  style: TextStyle(
                      fontSize: 35,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Text(
                  widget.user.email,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Source Sans Pro",
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4),
                ),
                SizedBox(height: 70),
                MaterialButton(
                    height: 57,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.power_settings_new_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Sign Out",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: "Source Sans Pro",
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.4),
                        )
                      ],
                    ),
                    onPressed: () {
                      widget._auth
                          .signOut()
                          .then((value) => widget._googleSignIn.signOut())
                          .then((value) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              ((Route route) => false)));
                    },
                    color: Colors.red),
              ],
            ),
          ),
        ));
  }
}

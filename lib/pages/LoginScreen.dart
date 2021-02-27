import 'package:discourse/pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 260.0, left: 10, right: 10),
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Discourse",
                        style: TextStyle(
                          fontSize: 43,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Tune out the noise !!!\nChip in to present your standpoint.",
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.5,
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 250),
            child: MaterialButton(
              height: 57,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/google_logo.png",
                    scale: 40,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Sign in with Google",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              onPressed: () {
                onGoogleSignIn(context);
              },
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    User user = (await _auth.signInWithCredential(credential)).user;

    return user;
  }

  void onGoogleSignIn(BuildContext context) async {
    await signInWithGoogle().then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage(user: value)),
          (route) => false);
    });
  }
}

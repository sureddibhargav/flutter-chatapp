import 'package:chatssey/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import "../components/rounded_button.dart";
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static const String loginRoute = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true;
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: "logo",
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: kTextFieldStyle,
                  onChanged: (value) {
                    email = value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your Email")),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: obscureText,
                // keyboardType: TextInputType.visiblePassword,
                textAlign: TextAlign.center,
                style: kTextFieldStyle,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "Enter your Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    icon: Icon(Icons.remove_red_eye),
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                text: "Log In",
                onPress: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final userSignIn = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (userSignIn != null) {
                      Navigator.pushNamed(context, ChatScreen.chatRoute);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

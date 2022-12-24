import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/rounded_button.dart';
import '../constants.dart';
import "chat_screen.dart";

class RegistrationScreen extends StatefulWidget {
  static const String registerRoute = "register";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool obscureText = true;
  bool showSpinner = false;
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
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
                tag: 'logo',
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
                  onChanged: (String value) {
                    email = value;
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
                onChanged: (String value) {
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
                  color: Colors.blueAccent,
                  text: "Register",
                  onPress: () async {
                    setState(() {
                      showSpinner = !showSpinner;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      print("here $newUser");
                      if (newUser != null) {
                        Navigator.pushNamed(context, ChatScreen.chatRoute);
                      }
                      setState(() {
                        showSpinner = !showSpinner;
                      });
                    } on FirebaseAuthException catch (e) {
                      print("in error");
                      print(e.message);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

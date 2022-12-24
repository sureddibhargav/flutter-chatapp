import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import "../components/rounded_button.dart";
import 'login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String welcomeRoute = "welcome";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: "logo",
                  // flightShuttleBuilder: ,
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                    width: 60.0,
                  ),
                ),
                Expanded(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                    child: AnimatedTextKit(
                      pause: Duration(milliseconds: 1000),
                      isRepeatingAnimation: true,
                      animatedTexts: [WavyAnimatedText('Flash Chat')],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              text: "Log In",
              onPress: () {
                Navigator.pushNamed(context, LoginScreen.loginRoute);
              },
            ),
            RoundedButton(
              color: Colors.blueAccent,
              text: "Register",
              onPress: () {
                Navigator.pushNamed(context, RegistrationScreen.registerRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Colors.blueAccent

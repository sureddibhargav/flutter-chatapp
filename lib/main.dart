import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/chat_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
        ),
      ),
      routes: {
        WelcomeScreen.welcomeRoute: (context) => WelcomeScreen(),
        LoginScreen.loginRoute: (context) => LoginScreen(),
        ChatScreen.chatRoute: (context) => ChatScreen(),
        RegistrationScreen.registerRoute: (context) => RegistrationScreen()
      },
      initialRoute: WelcomeScreen.welcomeRoute,
    );
  }
}

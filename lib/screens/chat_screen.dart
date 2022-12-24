import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'welcome_screen.dart';

late User? user;

class ChatScreen extends StatefulWidget {
  static const String chatRoute = "chat";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  late String messageText;
  late String sender;
  late TextEditingController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
    getUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void getUser() {
    final User? loggedInUser = _auth.currentUser;
    if (loggedInUser != null) {
      user = loggedInUser;
      messagesStream();
    }
  }

  void normalGetMessages() async {
    final messaeg = await _fireStore.collection("messages").get();
    for (var m in messaeg.docs) {
      print(m.data());
    }
  }

  void messagesStream() async {
    await for (var snapshot in _fireStore.collection('messages').snapshots()) {
      // print(_fireStore.collection('messages').snapshots());
      // print(_fireStore.collection('messages').snapshots().length);
      print(snapshot.docs);
      for (var message in snapshot.docs) {
        print("-------------");
        print(message.data());
      }
      print("++++++++++++++++++++++++++");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // normalGetMessages();
                _auth.signOut();
                Navigator.popUntil(
                    context, ModalRoute.withName(WelcomeScreen.welcomeRoute));
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(fireStore: _fireStore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      _controller.clear();
                      final docid = await _fireStore
                          .collection("messages")
                          .add({"text": messageText, "sender": user?.email});
                      print(docid);

                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({
    Key? key,
    required FirebaseFirestore fireStore,
  })  : _fireStore = fireStore,
        super(key: key);

  final FirebaseFirestore _fireStore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection("messages").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs;
          List<MessageBubble> messagesToBeDisplayed = messages.map((message) {
            Map<String, dynamic> oneMessage =
                message.data() as Map<String, dynamic>;
            var sender = oneMessage['sender'];
            return MessageBubble(
              text: oneMessage['text'],
              sender: sender,
              isMe: sender == user!.email,
            );
          }).toList();
          return Expanded(
            child: ListView(
              reverse: true,
              children: messagesToBeDisplayed,
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            color: Colors.greenAccent,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.text, required this.sender, required this.isMe});
  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
              elevation: 5.0,
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: isMe ? Radius.circular(20.0) : Radius.zero,
                  topRight: isMe ? Radius.zero : Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: isMe ? Colors.white : Colors.lightBlueAccent),
                ),
              )),
          Text(
            sender,
            style: TextStyle(fontSize: 13.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

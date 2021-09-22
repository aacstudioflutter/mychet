import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String messageText;
  var loggedInUser;
  String myText='';

  final DocumentReference documentReference1 =FirebaseFirestore.instance.collection('status').doc();

  final DocumentReference documentReference = FirebaseFirestore.instance.doc("massages/1");
  final _firestore = FirebaseFirestore.instance;

  //FirebaseUser currentUser = mAuth.getCurrentUser();

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void _add() {
    Map<String, String> data = <String, String>{
      "name": "Pawan Kumar",
      "desc": "Flutter Developer"
    };
    documentReference.set(data).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));
  }
  void _delete() {
    documentReference.delete().whenComplete(() {
      print("Deleted Successfully");
      setState(() {});
    }).catchError((e) => print(e));
  }
  void _update() {
    Map<String, String> data = <String, String>{
      "name": "Pawan Kumar Updated",
      "desc": "Flutter Developer Updated"
    };
    documentReference.update(data).whenComplete(() {
      print("Document Updated");
    }).catchError((e) => print(e));
  }
  void _fetch() {
    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          myText = datasnapshot['desc'];
        });
      }
    });
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
                _auth.signOut();
                Navigator.pop(context);
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
            //   MessagesStream(),
            Container(
              // decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      //  decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                   /* onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('massages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    },*/
                    onPressed: _add,
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            FlatButton(
              onPressed: _update,
              child: Text(
                'Update',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            FlatButton(
              onPressed: _delete,
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            FlatButton(
              onPressed: _fetch,
              child: Text(
                'Fetch',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),

            Text(
              myText,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

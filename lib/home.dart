import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'loginTabs.dart';

class HomePage extends StatefulWidget{
  HomePage({Key? key, required this.auth});
  final FirebaseAuth auth;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _changedController = TextEditingController();
  final GlobalKey<FormState> _changedKey = GlobalKey<FormState>();

  final List<String> chatRooms = ["Welcome", "GSU Panthers", "Advice Column"];
  final List<Icon> chatIcons = [Icon(Icons.handshake), Icon(Icons.school), Icon(Icons.newspaper)];

  /*Widget _passButton() {
    return ElevatedButton(
      onPressed: () => _changePassword(),
      child: Text("Change Password"),
    );
  }

  void _changePassword() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        String errorMessage = " ";
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Container(
              height: 300,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    controller: _changedController,
                    decoration: InputDecoration(labelText: "New Password"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await user?.updatePassword(_changedController.text);
                        modalSetState(() {
                          errorMessage = "Successfully changed password";
                        });
                      } catch (e) {
                        modalSetState(() {
                          errorMessage = e.toString();
                        });
                      }
                    },
                    child: Text("Confirm"),
                  ),
                  Text(errorMessage),
                ],
              ),
            );
          },
        );
      },
    );
  }*/
  
  void _signOut() async {
    await widget.auth.signOut();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Sign out in progress...'),
    ));
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) =>  LoginTabs()),
      (route) => false,
    );
  }

  void _enterChatRoom (String currentRoom) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(chatroom: currentRoom),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChattyRooms Chat Rooms"),
        actions: <Widget>[
          // NAVBAR
          IconButton(
            onPressed: () { _signOut(); },
            icon: Icon(Icons.menu),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Welcome, ${user!.email}"),
            Text(
              "Select a chatroom below: ",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 20),
            Container( 
              height: 600,
              child: ListView.builder(
                itemCount: chatRooms.length, 
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ElevatedButton( 
                        onPressed: () {_enterChatRoom(chatRooms[index]);},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox( 
                              child: chatIcons[index]
                            ),
                            SizedBox(width: 30),
                            Text(chatRooms[index], style: TextStyle(fontSize: 40)),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  );
                },
              ),
            ),
            //_passButton(),
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.chatroom}) : super(key: key);
  final String chatroom; 

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatPage> {
  final TextEditingController _msgController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  void _sendMessage() async {
    if (_msgController.text.isNotEmpty) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
      try {
        await FirebaseFirestore.instance.collection('messages').add({
          'chatroom': widget.chatroom,
          'username': '${userDoc['role']}',
          'content': _msgController.text,
          'date': FieldValue.serverTimestamp(),
        });
        _msgController.clear();
      } catch (error) {
        print('Unable to send message: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.chatroom} chatroom")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('date', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = snapshot.data!.docs.where((doc) => doc['chatroom'] == widget.chatroom).toList();
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text("${message['username']}: ${message['content']}"),
                      subtitle: Text(
                        message['date'] != null ? message['date'].toDate().toString() : "",
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: 'Enter Message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

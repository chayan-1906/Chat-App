import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';
  late String _userName;

  // String getUserInfo() {
  //   var firebaseUser = FirebaseAuth.instance.currentUser;
  //   return FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(firebaseUser!.uid)
  //       .get()
  //       .toString();
  // }

  // Future<void> _getUserName() async {
  //   FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc((await FirebaseAuth.instance.currentUser)!.uid)
  //       .get()
  //       .then((value) {
  //     setState(() {
  //       _userName = value.data()!['UserName'].toString();
  //     });
  //   });
  // }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send_rounded),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}

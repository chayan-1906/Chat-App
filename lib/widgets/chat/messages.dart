import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          print('messages 20: waiting');
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        print('messages 25: waiting');
        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            // message: chatDocs[index]['text'],
            // username: chatDocs[index]['username'],
            // isMe: chatDocs[index]['userId'] == currentUser!.uid,
            // key: ValueKey(chatDocs[index].id),
            message: chatDocs[index]['text'],
            username: chatDocs[index]['username'],
            userImage: chatDocs[index]['userImage'],
            isMe: chatDocs[index]['userId'] == currentUser!.uid,
            key: ValueKey(chatDocs[index].id),
          ),
        );
      },
    );
  }
}

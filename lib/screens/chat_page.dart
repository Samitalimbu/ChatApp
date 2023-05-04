import 'package:firebase/constants/firebase_instances.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../providers/room_provider.dart';

class ChatPage extends StatefulWidget {
  final types.Room room;
  ChatPage(this.room);
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer(
      builder: ((context, ref, child) {
        final messageStream = ref.watch(messagesStream(widget.room));
        return messageStream.when(
            data: (data) {
              return Chat(
                messages: data,
                onSendPressed: (val) async {
                  FirebaseInstances.fireChat
                      .sendMessage(val.text, widget.room.id);
                },
                showUserAvatars: true,
                showUserNames: true,
                user: types.User(
                    id: FirebaseInstances.firebaseAuth.currentUser!.uid),
              );
            },
            error: (err, stack) => Text('$err'),
            loading: () => Center(child: CircularProgressIndicator()));
      }),
    ));
  }
}

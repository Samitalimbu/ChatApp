import 'dart:io';

import 'package:firebase/constants/firebase_instances.dart';
import 'package:firebase/providers/common_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';

import '../providers/room_provider.dart';

class ChatPage extends StatefulWidget {
  final types.Room room;
  ChatPage(this.room);
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isAttachmentUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer(
      builder: ((context, ref, child) {
        final messageStream = ref.watch(messagesStream(widget.room));
        final image = ref.watch(imageProvider);
        return messageStream.when(
            data: (data) {
              return Chat(
                isAttachmentUploading: _isAttachmentUploading,
                messages: data,
                onAttachmentPressed: () {
                  final ImagePicker _picker = ImagePicker();
                  _picker
                      .pickImage(source: ImageSource.gallery)
                      .then((value) async {
                    if (value != null) {
                      setState(() {
                        _isAttachmentUploading = true;
                      });
                      final ref = FirebaseInstances.fireStorage
                          .ref()
                          .child('chatImage/${value.name}');
                      await ref.putFile(File(value.path));
                      final url = await ref.getDownloadURL();
                      setState(() {
                        _isAttachmentUploading = false;
                      });
                      final ImageMessage = types.PartialImage(
                          name: value.name,
                          uri: url,
                          size: File(value.path).lengthSync());
                      FirebaseChatCore.instance
                          .sendMessage(ImageMessage, widget.room.id);
                    }
                  });
                },
                onSendPressed: (types.PartialText message) {},
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

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }
}

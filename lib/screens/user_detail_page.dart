import 'package:firebase/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDetailPage extends ConsumerWidget {
  final types.User user;
  UserDetailPage(this.user);

  @override
  Widget build(BuildContext context, ref) {
    final postData = ref.watch(postStream);
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.imageUrl!),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(user.firstName!),
                      Text(user.metadata!['email']),
                      ElevatedButton(
                          onPressed: () {}, child: Text('Start Chat'))
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}

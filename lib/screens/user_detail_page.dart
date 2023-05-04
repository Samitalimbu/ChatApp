import 'package:firebase/screens/chat_page.dart';
import 'package:firebase/screens/home.dart';
import 'package:firebase/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../providers/room_provider.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                onTap: () {
                  Get.to(() => HomeScreen());
                },
                child: Icon(Icons.arrow_back_ios, size: 18)),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.imageUrl!),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.firstName!),
                      Text(user.metadata!['email']),
                      ElevatedButton(
                          onPressed: () async {
                            final response =
                                await ref.read(roomProvider).roomCreate(user);
                            if (response != null) {
                              Get.to(() => ChatPage(response));
                            }
                          },
                          child: Text('Start Chat'))
                    ],
                  ),
                )
              ],
            ),
            Expanded(
                child: postData.when(
                    data: (data) {
                      final userPost = data
                          .where((element) => element.userId == user.id)
                          .toList();
                      return GridView.builder(
                          itemCount: userPost.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2 / 3,
                                  mainAxisSpacing: 5),
                          itemBuilder: (context, index) {
                            return Image.network(userPost[index].imageUrl!);
                          });
                    },
                    error: (err, stack) => Text('$err'),
                    loading: () => Center(child: CircularProgressIndicator())))
          ],
        ),
      ),
    ));
  }
}

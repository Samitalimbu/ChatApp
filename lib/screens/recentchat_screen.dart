import 'package:firebase/constants/firebase_instances.dart';
import 'package:firebase/providers/room_provider.dart';
import 'package:firebase/screens/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class RecentChats extends ConsumerWidget {
  final uid = FirebaseInstances.firebaseAuth.currentUser!.uid;
  @override
  Widget build(BuildContext context, ref) {
    final roomData = ref.watch(roomStream);
    return Scaffold(
      body: roomData.when(
          data: (data) {
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {

                  final currentUser =
                      FirebaseInstances.firebaseAuth.currentUser!.uid;
                      
                  final otherUser = data[index]
                      .users
                      .firstWhere((element) => element.id != currentUser);

                  return ListTile(
                    onTap: () {
                      Get.to(() => ChatPage(data[index], otherUser.metadata!['token'],otherUser.firstName!));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data[index].imageUrl!),
                    ),
                    title: Text(data[index].name!),
                  );
                });
          },
          error: (err, stack) => Center(child: Text('$err')),
          loading: () => Center(child: CircularProgressIndicator())),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:division/division.dart';
import 'package:firebase/constants/firebase_instances.dart';
import 'package:firebase/providers/auth_provider.dart';
import 'package:firebase/providers/post_provider.dart';
import 'package:firebase/screens/create_page.dart';
import 'package:firebase/screens/detail_screen.dart';
import 'package:firebase/screens/update_page_screen.dart';
import 'package:firebase/screens/user_detail_page.dart';
import 'package:firebase/services/auth_service.dart';
import 'package:firebase/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class HomeScreen extends ConsumerWidget {
  final userId = FirebaseInstances.firebaseAuth.currentUser!.uid;
  late types.User user;
  // late types.User user;
  @override
  Widget build(BuildContext context, ref) {
    final userData = ref.watch(userStream(userId));
    final users = ref.watch(usersStream);
    final postData = ref.watch(postStream);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Hello"),
        ),
        drawer: Drawer(
          child: userData.when(
              data: (data) {
                user = data;
                return ListView(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(data.imageUrl!))),
                      child: Text(data.firstName!),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(data.metadata!['email']),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(() => CreatePageScreen());
                      },
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text("Create Post"),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        ref.read(authProvider.notifier).userLogout();
                      },
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text("Signout"),
                    )
                  ],
                );
              },
              error: (err, stack) => Text('$err'),
              loading: () => const Center(child: CircularProgressIndicator())),
        ),
        body: Column(
          children: [
            Container(
              height: 140,
              color: const Color.fromARGB(255, 201, 196, 196),
              child: users.when(
                  data: (data) {
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                onTap:
                                () {
                                  Get.to(
                                    () => UserDetailPage(data[index]),
                                  );
                                };
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        NetworkImage(data[index].imageUrl!),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(data[index].firstName!)
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  error: (err, stack) => Center(child: Text('$err')),
                  loading: () => Center(child: CircularProgressIndicator())

                  //
                  ),
            ),
            Expanded(
                child: postData.when(
                    data: (data) {
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 300,
                                        child: Text(
                                          data[index].title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (data[index].userId == userId)
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                            onPressed: () {
                                              Get.defaultDialog(
                                                  title: 'Customize Post',
                                                  titleStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  content: const Text(
                                                      'Edit or Remove Post'),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Parent(
                                                          style: ParentStyle()
                                                            ..height(40)
                                                            ..borderRadius(
                                                                topLeft: 6,
                                                                topRight: 6)
                                                            ..width(90)
                                                            ..alignmentContent
                                                                .center(true)
                                                            ..elevation(3)
                                                            ..background.color(
                                                                const Color(
                                                                    0xffAECBD6)),
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Get.to(() =>
                                                                  UpdatePage(data[
                                                                      index]));
                                                            },
                                                            child: const Text(
                                                              "Edit",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                        Parent(
                                                          style: ParentStyle()
                                                            ..height(40)
                                                            ..borderRadius(
                                                                topLeft: 6,
                                                                topRight: 6)
                                                            ..width(90)
                                                            ..alignmentContent
                                                                .center(true)
                                                            ..elevation(3)
                                                            ..background.color(
                                                                const Color(
                                                                    0xffAECBD6)),
                                                          child: const Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ]);
                                            },
                                            icon: const Icon(
                                                Icons.more_horiz_rounded))
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() =>
                                          DetailPageScreen(data[index], user));
                                    },
                                    child: CachedNetworkImage(
                                      height: 200,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      imageUrl: data[index].imageUrl,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 300,
                                        child: Text(
                                          data[index].detail,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (data[index].userId != userId)
                                        IconButton(
                                            onPressed: () {
                                              if (data[index]
                                                  .like
                                                  .usernames
                                                  .contains(user.firstName)) {
                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentSnackBar();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        duration: Duration(
                                                            seconds: 1),
                                                        content: Text(
                                                            'You have already like this post')));
                                              } else {
                                                ref
                                                    .read(postProvider.notifier)
                                                    .addLike([
                                                  ...data[index].like.usernames,
                                                  user.firstName!
                                                ], data[index].postId,
                                                        data[index].like.likes);
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.thumb_up_alt_outlined)),
                                      if (data[index].like.likes != 0)
                                        Text('${data[index].like.likes}')
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    error: (err, stack) => Center(child: Text('$err')),
                    loading: () =>
                        const Center(child: CircularProgressIndicator())))
          ],
        ));
  }
}

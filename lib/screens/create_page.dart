import 'dart:io';

import 'package:firebase/common_widgets/snack_show.dart';
import 'package:firebase/constants/firebase_instances.dart';
import 'package:firebase/providers/common_provider.dart';
import 'package:firebase/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class CreatePageScreen extends ConsumerWidget {
  final detailController = TextEditingController();
  final titleController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final uid = FirebaseInstances.fireChat.firebaseUser!.uid;

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(postProvider, (previous, next) {
      if (next.isError) {
        SnackShow.showFailure(context, next.errMessage);
      } else if (next.isSuccess) {
        Get.back();
        SnackShow.showSuccess(context, "sucess");
      }
    });
    final post = ref.watch(postProvider);
    final image = ref.watch(imageProvider);
    final mod = ref.watch(mode);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Form(
            key: _form,
            autovalidateMode: mod,
            child: Stack(
              children: [
                Container(
                  height: 430,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                ),
                Positioned(
                  left: 150,
                  top: 230,
                  child: Center(
                    child: const Text(
                      'Create Post',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                        .animate()
                        .fadeIn() // uses `Animate.defaultDuration`
                        .scale() // inherits duration from fadeIn
                        .move(delay: 300.ms, duration: 600.ms),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 360),
                  height: 460,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white24),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextFormField(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please provide title';
                                }
                                return null;
                              },
                              controller: titleController,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.mail),
                                  border: InputBorder.none,
                                  hintText: "title"),
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn() // uses `Animate.defaultDuration`
                          .scale() // inherits duration from fadeIn
                          .move(delay: 300.ms, duration: 600.ms),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white24),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextFormField(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please provide detail';
                                }
                              },
                              controller: detailController,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.password_outlined),
                                  border: InputBorder.none,
                                  hintText: "Detail"),
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn() // uses `Animate.defaultDuration`
                          .scale() // inherits duration from fadeIn
                          .move(delay: 300.ms, duration: 600.ms),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () {
                            Get.defaultDialog(
                                title: 'Select',
                                content: const Text("Choose form"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        ref
                                            .read(imageProvider.notifier)
                                            .ImagePick(true);
                                      },
                                      child: const Text("Camera")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();

                                        ref
                                            .read(imageProvider.notifier)
                                            .ImagePick(false);
                                      },
                                      child: const Text("Gallery")),
                                ]);
                          },
                          child: Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white24),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Center(
                                child: image == null
                                    ? Center(
                                        child: Text("Please select and image"),
                                      )
                                    : Image.file(File(image.path))),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: post.isLoad
                            ? null
                            : () {
                                _form.currentState!.save();
                                FocusScope.of(context).unfocus();

                                if (_form.currentState!.validate()) {
                                  if (image == null) {
                                    SnackShow.showFailure(
                                        context, "please upload an image");
                                  } else {
                                    ref.read(postProvider.notifier).postAdd(
                                        title: titleController.text.trim(),
                                        detail: detailController.text.trim(),
                                        userId: uid,
                                        image: image);
                                  }
                                } else {
                                  ref.read(mode.notifier).toogle();
                                }
                              },
                        child: post.isLoad
                            ? Center(child: CircularProgressIndicator())
                            : Text(
                                'Submit',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

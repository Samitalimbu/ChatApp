import 'package:firebase/providers/auth_provider.dart';
import 'package:firebase/screens/home.dart';
import 'package:firebase/screens/signup_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusPage extends ConsumerWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final authData = ref.watch(authStream);
    return Scaffold(
      body: authData.when(
          data: (data) {
            return data == null
                ? SignUpScreen()
                : HomeScreen(); //null xaina vaney homepage ma janxa
          },
          error: (err, stack) => Center(
                child: Text('$err'),
              ),
          loading: () => Center(child: CircularProgressIndicator())),
    );
  }
}

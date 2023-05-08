import 'dart:async';
import 'package:firebase/firebase_options.dart';
import 'package:firebase/screens/home.dart';
import 'package:firebase/screens/status_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class Pos {
  final String title;
  final String body;
  final String id;

  Pos({required this.title, required this.body, required this.id});

  factory Pos.fromJson(Map<String, dynamic> json) {
    return Pos(title: json['title'], body: json['body'], id: json['id']);
  }
}

final postData = FutureProvider((ref) => PostProvider.getPost());

class PostProvider {
  static final dio = Dio();
  static Future<List<Pos>> getPost() async {
    try {
      final response =
          await dio.get('https://jsonplaceholder.typicode.com/posts');
      return (response.data as List).map((e) => Pos.fromJson(e)).toList();
    } on DioError catch (err) {
      throw '${err.message}';
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "High_importance_channel",
  "High_importance_channel",
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
const InitializationSettings initializationSettings =
InitializationSettings(
  android: AndroidInitializationSettings("@mipmap/ic_launcher"),
);
void main() async{
WidgetsFlutterBinding.ensureInitialized();
await Future.delayed(Duration(milliseconds: 500));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(channel);
flutterLocalNotificationsPlugin.initialize(
  initializationSettings,
);
runApp(ProviderScope(child: Home()));
}


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 866),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return const GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: StatusPage(),
        );
      },
    );
  }
}

class Counter extends StatelessWidget {
  StreamController<int> numbers = StreamController();
  int number = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<int>(
        stream: numbers.stream,
        builder: ((context, snapshot) {
          return Center(
              child: Text(
            snapshot.data.toString(),
            style: const TextStyle(fontSize: 29, color: Colors.black),
          ));
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          numbers.sink.add(number++);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

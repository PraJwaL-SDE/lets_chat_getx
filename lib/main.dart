import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lest_chat_5/app/data/storage/group_chatroom_hive_data.dart';
import 'package:lest_chat_5/app/modules/auth/view/auth_screen.dart';

import 'app/data/storage/chatroom_hive_data.dart';
import 'app/data/storage/message_hive_data.dart';
import 'app/data/storage/user_hive_data.dart';

void main() async{
  await Hive.initFlutter();
  await UserHiveData.initialize();
  await MessageHiveData.initialize();
  await ChatroomHiveData.initialize();
  await GroupChatroomHiveData.initialize();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AuthScreen(),
    );
  }
}


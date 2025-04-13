import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lest_chat_5/app/data/models/user_model.dart';
import 'package:lest_chat_5/app/data/storage/chatroom_hive_data.dart';
import 'package:lest_chat_5/app/data/storage/message_hive_data.dart';
import 'package:lest_chat_5/app/data/storage/user_hive_data.dart';
import 'package:lest_chat_5/app/modules/home/view/widgets/home_add_popup.dart';
import 'package:lest_chat_5/app/modules/home/view/widgets/home_screen_tile.dart';

import 'package:lest_chat_5/app/utils/constants/constant_colors.dart';

import '../../../data/models/chat_room.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  final UserModel userModel;

  HomeScreen({super.key, required this.userModel}) {
    final controller = Get.put(HomeScreenController());
    controller.setUser(userModel);
    // controller.initServices();
  }

  @override
  Widget build(BuildContext context) {
    final HomeScreenController controller = Get.find();

    double w = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: ConstantColors.appbar,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Top AppBar


            // Main Content
            Expanded(
              child: GestureDetector(
                onTap: controller.onCrossTap,
                child: Stack(
                  children: [
                    // Chat List
                    Positioned.fill(
                      child: StreamBuilder<List<ChatRoom>>(
                        stream: ChatroomHiveData.getAllChatroom(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return FutureBuilder(
                              future: ChatroomHiveData.getAllChatroomNow(),
                              builder: (context, data) {
                                final chatRooms = data.data ?? [];

                                return ListView.builder(
                                  itemCount: chatRooms.length,
                                  itemBuilder: (context, index) {
                                    return HomeScreenTile(
                                      chatRoom: chatRooms[index],
                                      userModel: userModel,
                                    );
                                  },
                                );
                              },
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)),
                            );
                          }

                          if(snapshot.data == null){
                            return Center(child: Text("No chatroom found"),);
                          }

                          final chatRooms = snapshot.data!;
                          if (chatRooms.isEmpty) {
                            return Center(
                              child: Text(
                                'No chats available,\nclick add to find your friends',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: chatRooms.length,
                            itemBuilder: (context, index) {
                              return HomeScreenTile(
                                chatRoom: chatRooms[index],
                                userModel: userModel,
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // Add Friend Popup

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

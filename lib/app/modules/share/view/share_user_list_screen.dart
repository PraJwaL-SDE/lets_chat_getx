import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lest_chat_5/app/data/models/message_model.dart';
import 'package:lest_chat_5/app/data/provider/message/message_provider.dart';
import 'package:lest_chat_5/app/data/storage/chatroom_hive_data.dart';
import 'package:lest_chat_5/app/data/storage/message_hive_data.dart';
import 'package:lest_chat_5/app/modules/chatting/controller/chatting_controller.dart';
import 'package:lest_chat_5/app/modules/share/controller/share_user_list_controller.dart';
import 'package:lest_chat_5/app/modules/share/view/widgets/share_list_item.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/user_model.dart';
import '../../shell/view/bottom_nav_screen.dart';

class ShareUserListScreen extends StatelessWidget {
  final UserModel userModel;
  final List<MessageModel> messages;

  ShareUserListScreen({
    super.key,
    required this.userModel,
    required this.messages,
  });

  final ShareUserListController controller = Get.put(ShareUserListController());

  @override
  Widget build(BuildContext context) {
    print(messages.length);
    return Scaffold(
      appBar: AppBar(title: const Text('Share Message')),
      body: Stack(
        children: [
          FutureBuilder(
            future: ChatroomHiveData.getAllChatroomNow(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                return const Center(child: Text('No chatrooms available.'));
              } else {
                final chatrooms =
                snapshot.data as List; // Assuming it's a list of chatroom objects.
                return GetBuilder<ShareUserListController>(
                  init: controller,
                  builder: (_) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 70), // Avoid overlap with the button
                      itemCount: chatrooms.length,
                      itemBuilder: (context, index) {
                        final chatroom = chatrooms[index];
                        return StreamBuilder<UserModel?>(
                          stream: controller.streamOtherUser(chatroom, userModel),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const ListTile(title: Text('Loading user...'));
                            } else if (userSnapshot.hasError ||
                                !userSnapshot.hasData) {
                              return const ListTile(
                                title: Text('Error loading user.'),
                              );
                            } else {
                              final targetUser = userSnapshot.data!;
                              return GestureDetector(
                                onTap: () {
                                  if (controller.selectedChatrooms.contains(chatroom)) {
                                    controller.selectedChatrooms.remove(chatroom);
                                  } else {
                                    controller.selectedChatrooms.add(chatroom);
                                  }
                                  controller.update(); // Trigger UI update
                                },
                                child: ShareListItem(
                                  targetUser: targetUser,
                                  isSelected: controller.selectedChatrooms.contains(
                                    chatroom,
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
          Obx(() {
            // Show button only if there are selected chatrooms
            if (controller.selectedChatrooms.isEmpty) return const SizedBox.shrink();
            return Positioned(
              bottom: 16,
              right: 16,
              child: ElevatedButton.icon(
                onPressed: () async {
                  controller.isLoading.value = true; // Show progress bar
                  for (final chatroom in controller.selectedChatrooms) {
                    for (final message in messages) {
                      final otherUserId = chatroom.participants?.keys.firstWhere(
                            (id) => id != userModel.id,
                        orElse: () => '',
                      );
                      if (message.type == "image") {
                        await MessageProvider.uploadFileMessage(
                          userModel.id,
                          otherUserId!,
                          message.filePath!,
                        );
                      } else {
                        MessageProvider.sendMessage(
                          userModel.id,
                          otherUserId!,
                          message.text ?? "",
                        );
                      }
                      print("---------------------------------sharing message to $otherUserId");
                      message.id = Uuid().v6();
                      message.sender = userModel.id;
                      message.receiver = otherUserId;
                      message.createdOn = DateTime.now();

                      MessageHiveData.addMessage(chatroom.id!, message);
                      Get.delete<ChattingController>(force: true);
                    }
                  }
                  controller.isLoading.value = false; // Hide progress bar

                  // Navigate to BottomNavigationBar and clear previous screens
                  Get.offAll(BottomNavigationView(userModel: userModel));
                },
                icon: const Icon(Icons.send),
                label: const Text('Send'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            );
          }),
          Obx(() {
            if (!controller.isLoading.value) return const SizedBox.shrink();
            return Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Semi-transparent background
                  ),
                ),
                const Center(
                  child: CircularProgressIndicator(), // Progress bar
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

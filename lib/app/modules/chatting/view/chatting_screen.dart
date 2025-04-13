import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lest_chat_5/app/modules/chatting/view/chatting_profile_screen.dart';
import 'package:lest_chat_5/app/modules/chatting/view/widgets/attachment_popup.dart';
import 'package:lest_chat_5/app/modules/chatting/view/widgets/chat_list_tile.dart';
import 'package:lest_chat_5/app/modules/share/view/share_user_list_screen.dart';
import '../../../data/models/chat_room.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/storage/local_file_manager.dart';
import '../../../data/storage/message_hive_data.dart';
import '../../common/view/custom_app_bar.dart';
import '../../image/view/edit_image_screen.dart';
import '../controller/chatting_controller.dart';

class ChattingScreen extends StatelessWidget {
  final UserModel userModel;
  final UserModel targetModel;
  final ChatRoom chatRoom;
  late ChattingController controller;

  ChattingScreen({
    required this.userModel,
    required this.targetModel,
    required this.chatRoom,
  }) {
    controller = Get.put(
      ChattingController(
        userModel: userModel,
        targetModel: targetModel,
        chatRoom: chatRoom,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,

      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    final slideInAnimation = Tween<Offset>(
                      begin: const Offset(0.0, -1.0), // Start off-screen from the top
                      end: Offset.zero, // End at its position
                    ).animate(animation);

                    final slideOutAnimation = Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(0.0, 1.0), // Exit off-screen to the bottom
                    ).animate(animation);

                    return SlideTransition(
                      position: animation.status == AnimationStatus.reverse
                          ? slideOutAnimation
                          : slideInAnimation,
                      child: child,
                    );
                  },
                  child: controller.selectedMessages.isEmpty
                      ? Container(
                    key: const ValueKey('appBar'),
                    child: _appBar(),
                  )
                      : Container(
                    key: const ValueKey('chatOptionAppBar'),
                    child: _chatOptionAppBar(),
                  ),
                );
              }),



              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: const Color(0xFFE9EAEB),
      
                        child: _chatList(),
                      ),
                    ),
                    Obx(() {
                      return GestureDetector(
                        onTap: () {
                          // Close the popup regardless of tap location
                          controller.attachmentSelected.value = false;
                        },
                        child: Stack(
                          children: [
                            // Dim Background when Attachment Popup is visible
                            if (controller.attachmentSelected.value)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(
                                    0.5,
                                  ), // Dim background
                                ),
                              ),
      
                            // Animated Popup
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 500),
                              bottom:
                                  controller.attachmentSelected.value
                                      ? 10
                                      : -300, // Animates up from -300 (hidden) to 10
                              left: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  // Close the popup when tapped directly
                                  controller.attachmentSelected.value = false;
                                  print("Tapped on the popup, closing it.");
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  // Ensure the child doesn't block parent taps
                                  child: IgnorePointer(
                                    ignoring: false, // Set to true only if needed
                                    child: AttachmentPopup(
                                      chatRoom: chatRoom,
                                      currentUser: userModel,
                                      targetUser: targetModel,
                                      onTap: (){
                                        controller.attachmentSelected.value = false;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.messageController,
                          onChanged: (value) {
                            controller.messageUpdate(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            suffixIcon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child:
                                  controller.typedMsg.value.isEmpty
                                      ? Row(
                                        mainAxisSize: MainAxisSize.min,

                                        children: [
                                          IconButton(
                                            onPressed: ()async{
                                              File? imageFile = await LocalFileManager.pickImageFromCamera();
                                              if (imageFile == null) {
                                                print("No image selected");
                                                return;
                                              }

                                              Get.to(
                                                EditImageScreen(
                                                  imageFiles: [imageFile],
                                                  userModel: userModel,
                                                  targetModel: targetModel,
                                                  chatRoom: chatRoom,
                                                ),
                                              );
                                              return;
                                            },
                                            icon: Image.asset(
                                              "assets/icons/camera_btn_light.png",
                                              height: 25,
                                              width: 25,
                                              key: const ValueKey('camera_icon'),
                                            ),
                                          ),

                                          IconButton(
                                            onPressed: () {
                                              controller.clickAttachment();
                                            },
                                            icon: Obx(() {
                                              return AnimatedSwitcher(
                                                duration: const Duration(
                                                  milliseconds: 500,
                                                ),
                                                transitionBuilder: (
                                                  child,
                                                  animation,
                                                ) {
                                                  return FadeTransition(
                                                    opacity: animation,
                                                    child: child,
                                                  );
                                                },
                                                child: Image.asset(
                                                  controller
                                                          .attachmentSelected
                                                          .value
                                                      ? "assets/icons/cancel_light.png"
                                                      : "assets/icons/attach_btn_light.png",
                                                  height: 20,
                                                  width: 20,
                                                  // Use a unique key for each state
                                                  key: ValueKey(
                                                    controller
                                                        .attachmentSelected
                                                        .value,
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                          SizedBox(width: 8),
                                        ],
                                      )
                                      : const SizedBox.shrink(), // Empty widget for smooth transition
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          controller.sendMessage();
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: Image.asset(
                            controller.typedMsg.value.isNotEmpty
                                ? "assets/icons/send_btn_light.png"
                                : "assets/icons/mic_btn_light.png",
                            height: 60,
                            width: 60,
                            key: ValueKey(
                              controller.typedMsg.value.isNotEmpty
                                  ? 'send_icon'
                                  : 'mic_icon',
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    var userProfile = targetModel.profilePic;
    return CustomAppBar(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 25),
          ),
          Hero(
            tag: "t_${chatRoom.id}",
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                userProfile.isEmpty
                    ? "https://cdn-icons-png.flaticon.com/128/3177/3177440.png"
                    : userProfile,
              ),
              radius: 20,
            ),
          ),
          SizedBox(width: 10), // Add spacing between avatar and text
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.to(
                  ChatroomProfileScreen(
                    targetUser: targetModel,
                    chatRoom: chatRoom,
                  ),
                );
              },
              child: Text(
                targetModel.name,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/icons/video_call_light.png",
                height: 30,
                width: 30,
                color: Colors.white,
              ),
              SizedBox(width: 20), // Spacing between icons
              Image.asset(
                "assets/icons/autdio_call_light.png",
                height: 30,
                width: 30,
                color: Colors.white,
              ),
              SizedBox(width: 20), // Spacing between icons

            ],
          ),
        ],
      ),
    );
  }

  Widget _chatOptionAppBar() {
    return CustomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close Button
          IconButton(
            onPressed: () {
              controller.selectedMessages.clear();
              controller.update();
            },
            icon: Icon(Icons.close, color: Colors.white),
            tooltip: "Cancel Selection",
          ),

          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete, color: Colors.white),
                tooltip: "Delete",
              ),

              IconButton(
                onPressed: () {
                  Get.to(
                    ShareUserListScreen(
                      userModel: userModel,
                      messages: controller.selectedMessages,
                    ),
                  );

                },
                icon: Icon(Icons.forward, color: Colors.white),
                tooltip: "Forward",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chatList() {
    return StreamBuilder<List<MessageModel>>(
      stream: MessageHiveData.getAllMessage(chatRoom.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _defaultChatList();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No messages yet.'));
        }
        var messages = [];

        WidgetsBinding.instance.addPostFrameCallback((_) {
          messages = snapshot.data!;
        });

        return messages.isNotEmpty
            ? ListView.builder(
              reverse: true,
              cacheExtent: 30000,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isSender = message.sender == userModel.id;

                return ChatListTile(
                  message: message,
                  isSender: isSender,
                  index: index,
                );
              },
            )
            : Stack(children: [Positioned.fill(child: _defaultChatList())]);
      },
    );
  }

  Widget _defaultChatList() {
    controller.loadMessages(chatRoom.id!);

    return GetBuilder<ChattingController>(
      init: controller, // Ensure the controller is properly initialized
      builder: (controller) {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.messages.isEmpty) {
          return const Center(child: Text('No messages yet.'));
        }

        return ListView.builder(
          addAutomaticKeepAlives: true,
          cacheExtent: 10000.0,
          reverse: true,
          itemCount: controller.messages.length,
          itemBuilder: (context, index) {
            final message = controller.messages[index];
            final isSender = message.sender == userModel.id;
            final isSelected = controller.selectedMessages.contains(message);

            return GestureDetector(
              onTap: () {
                print("single press");
                controller.selectMessage(message);
                controller.update(); // Ensure UI updates after state change
              },
              onLongPress: () {
                print("long press");
                controller.longPressSelectMessage(message);
                controller.update(); // Ensure UI updates after state change
              },
              child: ChatListTile(
                message: message,
                isSender: isSender,
                index: index,
                isSelected: isSelected,
                disableGestures: controller.selectedMessages.isNotEmpty,
              ),
            );
          },
        );
      },
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lest_chat_5/app/modules/group/controller/group_chatting_controller.dart';
import 'package:lest_chat_5/app/modules/group/view/widgets/group_attachment_popup.dart';

import '../../../data/models/group_chatroom_model.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/user_model.dart';
import 'package:get/get.dart';

import '../../../data/storage/message_hive_data.dart';
import '../../chatting/view/widgets/chat_list_tile.dart';
import '../../common/view/custom_app_bar.dart';

class GroupChattingScreen extends StatelessWidget {
  UserModel userModel;
  GroupChatroomModel chatroomModel;

  late GroupChattingController controller;
  GroupChattingScreen({
    Key? key,
    required this.userModel,
    required this.chatroomModel,
  }) : super(key: key){
    controller = Get.put(GroupChattingController(userModel: userModel,  chatRoom: chatroomModel));
  }



  @override
  Widget build(BuildContext context) {
    var userProfile = chatroomModel.profilePic;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAppBar(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  Hero(
                    tag: "t_${chatroomModel.id}",
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => chatroomModelProfileScreen(
                        //       targetUser: targetModel,
                        //       chatroomModel: chatroomModel,
                        //     ),
                        //   ),
                        // );
                      },
                      child: Text(
                        chatroomModel.name,
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
                      SizedBox(width: 10), // Spacing between icons
                      Image.asset(
                        "assets/icons/autdio_call_light.png",
                        height: 30,
                        width: 30,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10), // Spacing between icons
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          // Handle menu actions here
                          if (value == 'option1') {
                            // Perform action for Option 1
                          } else if (value == 'option2') {
                            // Perform action for Option 2
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'option1',
                            child: Text('Option 1'),
                          ),
                          PopupMenuItem(
                            value: 'option2',
                            child: Text('Option 2'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: const Color(0xFFE9EAEB),
                      child: StreamBuilder<List<MessageModel>>(
                        stream: MessageHiveData.getAllMessage(
                            chatroomModel.id!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // return Center(child: CircularProgressIndicator());
                            return _defaultChatList();
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No messages yet.'));
                          }
                          var messages = [];
                          // Future.delayed(Duration(milliseconds: 100), () {
                          //   setState(() {
                          //      messages = snapshot.data!;
                          //   });
                          // });
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
                                    final isSender =
                                        message.sender == userModel.id;

                                    return ChatListTile(
                                      message: message,
                                      isSender: isSender,
                                      index: index,
                                    );
                                  },
                                )
                              : Stack(
                                  children: [
                                    Positioned.fill(child: _defaultChatList()),
                                  ],
                                );
                        },
                      ),
                    ),
                  ),
                  Obx(() {
                    return GestureDetector(
                      onTap: () {
                        // Close the popup regardless of tap location
                        controller.attachmentSelected.value =
                            false;
                        print(
                            "Tapped anywhere on the screen, closing the popup.");
                      },
                      child: Stack(
                        children: [
                          // Dim Background when Attachment Popup is visible
                          if (controller.attachmentSelected.value)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black
                                    .withOpacity(0.5), // Dim background
                              ),
                            ),

                          // Animated Popup
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 500),
                            bottom: controller
                                    .attachmentSelected.value
                                ? 10
                                : -300, // Animates up from -300 (hidden) to 10
                            left: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                // Close the popup when tapped directly
                                controller
                                    .attachmentSelected.value = false;
                                print("Tapped on the popup, closing it.");
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
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
                                  child: GroupAttachmentPopup(
                                    groupModel: chatroomModel,
                                    currentUser: userModel,
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
              child: Obx(
                () {
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
                                    scale: animation, child: child);
                              },
                              child: controller
                                      .typedMsg.value.isEmpty
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 5,
                                      children: [
                                        Image.asset(
                                          "assets/icons/camera_btn_light.png",
                                          height: 25,
                                          width: 25,
                                          key: const ValueKey('camera_icon'),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () {
                                            controller
                                                .clickAttachment();
                                          },
                                          icon: Obx(() {
                                            return AnimatedSwitcher(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              transitionBuilder:
                                                  (child, animation) {
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
                                                        .value),
                                              ),
                                            );
                                          }),
                                        ),
                                        SizedBox(width: 8)
                                      ],
                                    )
                                  : const SizedBox
                                      .shrink(), // Empty widget for smooth transition
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
                                opacity: animation, child: child);
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultChatList() {
    return FutureBuilder(
      future: MessageHiveData.getAllMessagesNow(chatroomModel.id!),
      builder: (context, data) {
        if (data.data == null) {
          return const Center(child: Text('No messages yet.'));
        }
        var messages = data.data!;
        return ListView.builder(
          addAutomaticKeepAlives: true,
          cacheExtent: 10000.0,
          reverse: true,
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
        );
      },
    );
  }
}

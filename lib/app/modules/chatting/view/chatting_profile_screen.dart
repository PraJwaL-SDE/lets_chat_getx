import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lest_chat_5/app/modules/chatting/view/widgets/media_link_doc_screen.dart';
import '../../../data/models/chat_room.dart';
import '../../../data/models/user_model.dart';
import '../../../utils/constants/constant_colors.dart';
import '../../common/view/custom_app_bar.dart';
import '../controller/chatting_profile_controller.dart';
class ChatroomProfileScreen extends StatelessWidget {
  final UserModel targetUser;
  final ChatRoom chatRoom;

  ChatroomProfileScreen({super.key, required this.targetUser, required this.chatRoom});

  final ChatroomProfileController controller = Get.put(ChatroomProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 25),
                  ),
                  const Spacer(),
                  Image.asset("assets/icons/video_call_light.png", height: 30, width: 30, color: Colors.white),
                  const SizedBox(width: 10),
                  Image.asset("assets/icons/autdio_call_light.png", height: 30, width: 30, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Hero(
              tag: "t_${chatRoom.id}",
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  targetUser.profilePic.isEmpty
                      ? "https://cdn-icons-png.flaticon.com/128/3177/3177440.png"
                      : targetUser.profilePic,
                ),
                radius: 100,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              targetUser.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(targetUser.email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                IconButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: targetUser.email));
                  },
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),

            const Divider(),

            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Image.asset("assets/icons/media_links_doc_light.png", height: 30, width: 30),
                    title: Hero(
                      tag: "media_links",
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text("Media, Links & Documents"),
                      ),
                    ),
                    trailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("153"),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MediaLinkDocScreen(
                            targetUser: targetUser,
                            chatRoom: chatRoom,
                          ),
                        ),
                      );
                    },
                  ),
                  Obx(() => ListTile(
                    leading: Image.asset("assets/icons/mute_light.png", height: 30, width: 30),
                    title: const Text("Mute Notification"),
                    trailing: Switch(
                      value: controller.muteNotification.value,
                      onChanged: controller.toggleMuteNotification,
                    ),
                  )),
                  ListTile(
                    leading: Image.asset("assets/icons/noti_light.png", height: 30, width: 30),
                    title: const Text("Custom Notification"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  Obx(() => ListTile(
                    leading: Image.asset("assets/icons/protected_chat_light.png", height: 30, width: 30),
                    title: const Text("Protected Chat"),
                    trailing: Switch(
                      value: controller.protectedChat.value,
                      onChanged: controller.toggleProtectedChat,
                    ),
                  )),
                  Obx(() => ListTile(
                    leading: Image.asset("assets/icons/hide_inactive_light.png", height: 30, width: 30),
                    title: const Text("Hide Chat"),
                    trailing: Switch(
                      value: controller.hideChat.value,
                      onChanged: controller.toggleHideChat,
                    ),
                  )),
                  Obx(() => ListTile(
                    leading: Image.asset("assets/icons/hide_inactive_light.png", height: 30, width: 30),
                    title: const Text("Hide Chat History"),
                    trailing: Switch(
                      value: controller.hideChatHistory.value,
                      onChanged: controller.toggleHideChatHistory,
                    ),
                  )),
                  ListTile(
                    leading: Image.asset("assets/icons/bottom_group_inactive.png", height: 30, width: 30),
                    title: const Text("Add To Group"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  ListTile(
                    leading: Image.asset("assets/icons/custom_color_chat_light.png", height: 30, width: 30),
                    title: const Text("Custom Color Chat"),
                    trailing: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(color: ConstantColors.appbar),
                    ),
                  ),
                  ListTile(
                    leading: Image.asset("assets/icons/bg_edit_light.png", height: 30, width: 30),
                    title: const Text("Custom Background Chat"),
                    trailing: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(color: Colors.grey),
                    ),
                  ),
                  ListTile(
                    leading: Image.asset("assets/icons/block_light.png", height: 30, width: 30),
                    title: const Text("Block"),
                  ),
                  ListTile(
                    leading: Image.asset("assets/icons/reposrt_light.png", height: 30, width: 30),
                    title: const Text("Report"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


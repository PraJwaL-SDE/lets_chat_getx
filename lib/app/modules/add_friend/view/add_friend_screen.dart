import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lest_chat_5/app/modules/add_friend/view/widgets/add_friend_list_tile.dart';
import 'package:lest_chat_5/app/modules/chatting/view/chatting_screen.dart';
import '../../../data/models/user_model.dart';
import '../controller/add_friend_controller.dart';

class AddFriendScreen extends StatelessWidget {
  final UserModel userModel;

  AddFriendScreen({super.key, required this.userModel});

  final AddFriendController controller = Get.put(AddFriendController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildAppBar(),
            _buildSearchField(),
            Obx(() {
              if (controller.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                );
              }
              if (controller.errorMessage.value != null) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    controller.errorMessage.value!,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              if (controller.searchedUser.value != null) {
                return Expanded(
                  child: ListView(
                    children: [
                      AddFriendListTile(
                        userModel: controller.searchedUser.value!,
                        onAddFriend: () async {
                          var newChatroom = await controller.createChatroom(
                            controller.searchedUser.value!,
                            userModel,
                          );
                          if (newChatroom != null) {
                            // Get.off(() => ChattingScreen(
                            //       userModel: userModel,
                            //       chatRoom: newChatroom,
                            //       targetModel: controller.searchedUser.value!,
                            //     ));
                            Get.off(ChattingScreen(userModel: userModel, targetModel: controller.searchedUser.value!, chatRoom: newChatroom));
                          }
                        },
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue,
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.blue, size: 30),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Add Friend",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by email",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
              onChanged: (value) {
                controller.searchQuery.value = value.trim();
              },
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => controller.searchUser(controller.searchQuery.value),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}

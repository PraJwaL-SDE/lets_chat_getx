import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lest_chat_5/app/data/provider/auth/auth_provider.dart';
import 'package:lest_chat_5/app/data/storage/chatroom_hive_data.dart';

import '../../../data/models/chat_room.dart';
import '../../../data/models/user_model.dart';


class AddFriendController extends GetxController {
  final AuthProvider authProvider = AuthProvider();

  var searchQuery = ''.obs;
  var searchedUser = Rx<UserModel?>(null);
  var isLoading = false.obs;
  var errorMessage = Rx<String?>(null);

  Future<void> searchUser(String email) async {
    if (email.isEmpty) {
      errorMessage.value = 'Please enter an email to search.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;
    searchedUser.value = null;

    try {
      final user = await authProvider.getUserByEmail(email);
      if (user == null) {
        errorMessage.value = 'No user found with this email.';
      } else {
        searchedUser.value = user;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<ChatRoom?> createChatroom(UserModel friend, UserModel currentUser) async {
    try {
      final newChatroom = ChatRoom(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        participants: {
          currentUser.id: true,
          friend.id: true,
        },
        lastMessage: null,
        type: 'dm',
      );

      ChatroomHiveData.setChatroom(newChatroom);

      Get.snackbar("Success", "Chatroom created successfully!");
      return newChatroom;
    } catch (e) {
      Get.snackbar("Error", "Failed to create chatroom: $e");
      return null;
    }
  }
}

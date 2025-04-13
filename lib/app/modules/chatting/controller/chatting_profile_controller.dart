import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatroomProfileController extends GetxController {
  var muteNotification = false.obs;
  var protectedChat = false.obs;
  var hideChat = false.obs;
  var hideChatHistory = false.obs;
  var scrollOffset = 0.0.obs;

  void updateScrollOffset(double offset) {
    scrollOffset.value = offset.clamp(0.0, 200.0);
  }

  void toggleMuteNotification(bool value) => muteNotification.value = value;
  void toggleProtectedChat(bool value) => protectedChat.value = value;
  void toggleHideChat(bool value) => hideChat.value = value;
  void toggleHideChatHistory(bool value) => hideChatHistory.value = value;
}

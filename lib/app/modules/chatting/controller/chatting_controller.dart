import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lest_chat_5/app/data/provider/message/message_provider.dart';
import 'package:lest_chat_5/app/data/storage/message_hive_data.dart';

import '../../../data/models/chat_room.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/user_model.dart';
class ChattingController extends GetxController{
  final UserModel userModel;
  final UserModel targetModel;
  final ChatRoom chatRoom;


  ChattingController({required this.userModel,required this.targetModel,required this.chatRoom});

  final TextEditingController messageController = TextEditingController();
  var attachmentSelected = false.obs;
  void clickAttachment(){
    attachmentSelected.value = !attachmentSelected.value;
  }
  var typedMsg = "".obs;
  void messageUpdate(String messageText){
    typedMsg.value = messageText;
  }


  @override
  void onInit() {
    MessageProvider.sendMessage(
      userModel.id,
      targetModel.id,
      jsonEncode({
        "STATUS": "SEEN",
        "chatroomId": chatRoom.id!,
      }),
      messageType: "MESSAGE_STATUS",
    );
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isNotEmpty) {
      final newMessage = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: userModel.id!,
          text: messageController.text.trim(),
          createdOn: DateTime.now(),
          seen: true,
          type: "text",
          receiver: targetModel.id,
          chatroomId: chatRoom.id);
      messageController.clear();
      messageUpdate(messageController.text);

      MessageProvider.sendMessage(userModel.id, targetModel.id, newMessage.text!);
      MessageHiveData.addMessage(chatRoom.id!, newMessage);

      // await messageService.sendMessage(newMessage, widget.chatRoom.id!);
      // chatroomService.updateLastMessage(newMessage, widget.chatRoom);
      // try {
      //   if (widget.targetModel.deviceToken.isNotEmpty) {
      //     print("device token found ${widget.targetModel.deviceToken}");
      //     NotificationServices notificationServices = NotificationServices();
      //     notificationServices.sendNotificationToTarget(
      //         widget.targetModel.deviceToken,
      //         RemoteMessage(
      //             notification: RemoteNotification(
      //               title: widget.userModel.name,
      //               body: messageController.text.trim(),
      //             )),
      //         newMessage);
      //   } else {
      //     print("Device token is empty");
      //   }
      // } catch (e) {
      //   print("Error send notification form chatting screen $e");
      // }
    }
  }

  var selectedMessages = <MessageModel>[].obs; // Observable list

  void selectMessage(MessageModel message) {
    if (selectedMessages.isEmpty) return;

    if (selectedMessages.contains(message)) {
      selectedMessages.remove(message);
      print("Message remove: ${message.id}");
    } else {
      selectedMessages.add(message);
      print("Message selected: ${message.id}");
    }


    selectedMessages.refresh(); // Trigger UI update
  }

  void longPressSelectMessage(MessageModel message) {
    if (selectedMessages.isEmpty) {
      selectedMessages.add(message);
      selectedMessages.refresh();

      print("Message selected: ${message.id}");
    }else{
      print("message length :${selectedMessages.length}");
    }
  }

  var messages = <MessageModel>[].obs;
  var isLoading = false.obs;
  void loadMessages(String chatRoomId) async {
    try {
      isLoading.value = true;
      final fetchedMessages = await MessageHiveData.getAllMessagesNow(chatRoomId);
      messages.assignAll(fetchedMessages);

      print("chats found ${messages.length}");
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages: $e');
    } finally {
      isLoading.value = false;
    }
  }


}
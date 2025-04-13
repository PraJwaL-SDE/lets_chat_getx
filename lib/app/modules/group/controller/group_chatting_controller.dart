import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lest_chat_5/app/data/models/group_chatroom_model.dart';
import 'package:lest_chat_5/app/data/provider/message/message_provider.dart';
import 'package:lest_chat_5/app/data/storage/message_hive_data.dart';

import '../../../data/models/chat_room.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/user_model.dart';
class GroupChattingController extends GetxController{
  final UserModel userModel;
  final GroupChatroomModel chatRoom;


  GroupChattingController({required this.userModel,required this.chatRoom});

  final TextEditingController messageController = TextEditingController();
  var attachmentSelected = false.obs;
  void clickAttachment(){
    attachmentSelected.value = !attachmentSelected.value;
  }
  var typedMsg = "".obs;
  void messageUpdate(String messageText){
    typedMsg.value = messageText;
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
          chatroomId: chatRoom.id
      );
      messageController.clear();
      messageUpdate(messageController.text);

      chatRoom.participants.forEach((id,val){
        MessageProvider.sendMessage(userModel.id, id, newMessage.text!);
      });




      MessageHiveData.addMessage(chatRoom.id!, newMessage);


    }
  }
}
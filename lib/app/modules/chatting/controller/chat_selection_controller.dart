import 'package:get/get.dart';

import '../../../data/models/message_model.dart';

class ChatSelectionController extends GetxController{
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
}
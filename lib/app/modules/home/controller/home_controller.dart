import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lest_chat_5/app/data/models/user_model.dart';

import 'package:lest_chat_5/app/data/storage/user_hive_data.dart';

import '../../../data/models/chat_room.dart';
import '../../../services/notification/notification_services.dart';

class HomeScreenController extends GetxController {
  final RxBool searchSelected = false.obs;
  final RxBool addSelected = false.obs;

  late UserModel _userModel;

  final Rx<Stream<List<ChatRoom>>> _chatroomStream = Rx(Stream.empty());

  Stream<List<ChatRoom>> get chatroomStream => _chatroomStream.value;

  void setUser(UserModel user) {
    _userModel = user;
    UserHiveData.setCurrentUser(user);
    // _chatroomStream.value = _chatroomService.getAllChatrooms(user.id!);
  }

  // void initServices() {
  //   NotificationServices notificationServices = NotificationServices();
  //   notificationServices.firebaseInit(Get.context!);
  //   notificationServices.setupInteractMessage(Get.context!);
  //   _updateToken();
  // }

  Future<void> _updateToken() async {
    NotificationServices notificationServices = NotificationServices();
    String? deviceToken = await notificationServices.getDeviceToken();

    if (deviceToken != null) {
      try {
        // await FirebaseFirestore.instance
        //     .collection("user_queue")
        //     .doc(_userModel.id)
        //     .update({'device_token': deviceToken});
      } catch (e) {
        debugPrint('Error updating device token: $e');
      }
    } else {
      debugPrint('Failed to retrieve device token');
    }
  }

  void onCrossTap() {
    searchSelected.value = false;
    addSelected.value = false;
  }

  void onAddTap() {
    addSelected.value = true;
  }

  void enableSearch() {
    searchSelected.value = true;
  }
}

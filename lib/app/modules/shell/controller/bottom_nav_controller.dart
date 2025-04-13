import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lest_chat_5/app/data/models/user_model.dart';

import '../../../data/provider/message/message_provider.dart';

class BottomNavController extends GetxController {
  final UserModel userModel;
  BottomNavController({required this.userModel});
  RxInt currentIdx = 0.obs;
  late PageController pageController;

  void initController(int initialIdx) {
    currentIdx.value = initialIdx;
    pageController = PageController(initialPage: initialIdx);
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    MessageProvider.connect(userModel.id);
    MessageProvider.listenMessages();

  }

  void onItemTapped(int index) {
    currentIdx.value = index;
    pageController.jumpToPage(index);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

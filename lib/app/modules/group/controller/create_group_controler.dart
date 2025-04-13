import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lest_chat_5/app/data/provider/message/message_provider.dart';
import 'package:lest_chat_5/app/data/storage/group_chatroom_hive_data.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/group_chatroom_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/storage/user_hive_data.dart';

class CreateGroupController extends GetxController {
  final UserModel userModel;

  late final ScrollController scrollController;
  late final PanelController panelController;
  late final TextEditingController groupNameEditingController;

  /// Members selected from panel
  RxList<UserModel> members = <UserModel>[].obs;

  /// Confirmed group members (shown in main screen)
  RxList<UserModel> conformMembers = <UserModel>[].obs;

  /// All users loaded from local
  RxList<UserModel> users = <UserModel>[].obs;

  /// Search query
  RxString searchText = ''.obs;

  CreateGroupController({required this.userModel});

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    panelController = PanelController();
    groupNameEditingController = TextEditingController();
    _findLocalUsers();
  }

  void _findLocalUsers() async {
    final fetchedUsers = await UserHiveData.getAllUsers();
    users.value = fetchedUsers;
  }

  void toggleMemberSelection(UserModel user) {
    if (members.contains(user)) {
      members.remove(user);
    } else {
      members.add(user);
    }
  }

  void confirmMembers() {
    conformMembers.addAll(members.where((user) => !conformMembers.contains(user)));
    members.clear();
  }

  void removeConfirmedMember(UserModel user) {
    conformMembers.remove(user);
  }

  void createNewGroup() {
    if (groupNameEditingController.text.trim().isEmpty) return;

    final uuid = Uuid();
    conformMembers.addIf(!conformMembers.contains(userModel), userModel);

    GroupChatroomModel groupChatroomModel = GroupChatroomModel(
      id: uuid.v6(),
      name: groupNameEditingController.text.trim(),
      participants: {},
      profilePic: "https://cdn-icons-png.flaticon.com/128/4140/4140048.png",
      createdOn: DateTime.now(),
      creator: userModel.id,
      admin: [userModel.id],
    );

    for (var user in conformMembers) {
      groupChatroomModel.participants[user.id] = true;
      MessageProvider.sendMessage(userModel.id, user.id, groupChatroomModel.toJson(),messageType: "CREATEGROUP");
    }

    GroupChatroomHiveData.setGroupChatroom(groupChatroomModel);
  }

  @override
  void onClose() {
    groupNameEditingController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

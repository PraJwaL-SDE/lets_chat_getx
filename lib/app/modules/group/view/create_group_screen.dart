import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lest_chat_5/app/modules/group/controller/create_group_controler.dart';
import 'package:lest_chat_5/app/modules/group/view/widgets/add_user_item.dart';
import 'package:lest_chat_5/app/modules/group/view/widgets/panel_user_item.dart';

import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/user_model.dart';
import '../../../utils/constants/constant_colors.dart';
import '../../common/view/continue_btn.dart';
import '../../common/view/custom_app_bar.dart';

class CreateGroupScreen extends StatelessWidget {
  final UserModel userModel;
  final CreateGroupController controller;

  CreateGroupScreen({super.key, required this.userModel})
      : controller = Get.put(CreateGroupController(userModel: userModel));

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SlidingUpPanel(
          snapPoint: .5,
          header: _panelHeader(context),
          body: _body(),
          maxHeight: h * 0.95,
          minHeight: 0,
          controller: controller.panelController,
          scrollController: controller.scrollController,
          panelBuilder: () => _panel(context),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18.0),
            topRight: Radius.circular(18.0),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomAppBar(
          child: Row(
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    "Create New Group",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Group Name", style: TextStyle(color: Colors.grey, fontSize: 17)),
                TextField(
                  controller: controller.groupNameEditingController,
                  decoration: const InputDecoration(
                    hintText: "Enter Group Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Members", style: TextStyle(color: Colors.grey, fontSize: 17)),
                Center(
                  child: GestureDetector(
                    onTap: () => controller.panelController.open(),
                    child: Container(
                      height: 60,
                      width: 370,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xFFECF9FF),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 20, color: ConstantColors.primary),
                          Text("Add members to group", style: TextStyle(color: ConstantColors.primary, fontSize: 17)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() => ListView.builder(
                    itemCount: controller.conformMembers.length,
                    itemBuilder: (context, index) {
                      return AddUserItem(
                        userModel: controller.conformMembers[index],
                        onTap: () => controller.conformMembers.removeAt(index),
                      );
                    },
                  )),
                ),

                ContinueBtn(
                  onPressed: () async {
                    controller.createNewGroup();
                    Get.back();
                  },
                  text: "Create Group",
                  backgroundColor: ConstantColors.primary,
                  showArrow: false,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _panelFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 150,
          child: ContinueBtn(
            onPressed: () => controller.panelController.close(),
            text: "Cancel",
            backgroundColor: const Color(0xFFECF9FF),
            textColor: ConstantColors.primary,
            showArrow: false,
          ),
        ),
        SizedBox(
          width: 150,
          child: ContinueBtn(
            onPressed: () {
              controller.conformMembers.addAll(controller.members);
              controller.members.clear();
              controller.panelController.close();
            },
            text: "Add",
            backgroundColor: ConstantColors.primary,
            textColor: Colors.white,
            showArrow: false,
          ),
        ),
      ],
    );
  }

  Widget _panelHeader(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: ForceDraggableWidget(
          child: Container(
            width: 100,
            height: 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12.0),
                Container(
                  width: 30,
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _panel(BuildContext context) {
    return Obx(() {
      final filteredUsers = controller.users
          .where((user) =>
      !controller.conformMembers.contains(user) &&
          (controller.searchText.value.isEmpty ||
              user.name.toLowerCase().contains(controller.searchText.value.toLowerCase()) ||
              user.email.toLowerCase().contains(controller.searchText.value.toLowerCase())))
          .toList();

      return Column(
        children: [
          const SizedBox(height: 30.0),
          const Text("Add members to group", style: TextStyle(color: Colors.black, fontSize: 20)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (val) => controller.searchText.value = val,
              decoration: const InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                var user = filteredUsers[index];
                if (user.id == userModel.id) return const SizedBox.shrink();

                return GestureDetector(
                  onTap: () {
                    if (controller.members.contains(user)) {
                      controller.members.remove(user);
                    } else {
                      controller.members.add(user);
                    }
                    print(controller.members.length);
                  },
                  child: PanelUserItem(
                    userModel: user,
                    isChecked: controller.members.contains(user),
                  ),
                );
              },
            ),
          ),
          _panelFooter(),
        ],
      );
    });
  }
}


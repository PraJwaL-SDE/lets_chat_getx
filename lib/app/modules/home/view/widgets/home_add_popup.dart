import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lest_chat_5/app/modules/add_friend/view/add_friend_screen.dart';
import 'package:lest_chat_5/app/modules/group/view/create_group_screen.dart';
import '../../../../data/models/user_model.dart';
import 'package:get/get.dart';

class HomeAddPopup extends StatelessWidget {
  final UserModel userModel;
  const HomeAddPopup({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 0,
        children: [
          ListTile(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => AddFriendScreen(userModel: userModel),
              //   ),
              // );

              Get.to(AddFriendScreen(userModel: userModel));
            },
            leading: Icon(Icons.person_add),
            title: Text(
              "Add Friend",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateGroupScreen(userModel: userModel)));
              Get.to(CreateGroupScreen(userModel: userModel));

            },
            leading: Image.asset(
              "assets/icons/bottom_group_inactive.png",
              height: 30,
              width: 30,
            ),
            title: Text(
              "Create Group",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

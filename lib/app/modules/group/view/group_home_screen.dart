import 'package:flutter/material.dart';
import 'package:lest_chat_5/app/data/models/user_model.dart';
import 'package:lest_chat_5/app/data/storage/group_chatroom_hive_data.dart';
import 'package:get/get.dart';
import 'package:lest_chat_5/app/modules/group/controller/group_home_controller.dart';
import 'package:lest_chat_5/app/modules/group/view/group_chatting_screen.dart';

import '../../../utils/constants/constant_colors.dart';
class GroupHomeScreen extends StatelessWidget {
  final UserModel userModel;
  late var controller;
   GroupHomeScreen({super.key, required this.userModel}){
     controller = Get.put(GroupHomeController());
   }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [

            Expanded(
              child: StreamBuilder(
                stream: GroupChatroomHiveData.getAllGroupChatrooms(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _savedGroupsData();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error fetching groups : ${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text("No groups found."),
                    );
                  }

                  final groups = snapshot.data!;
                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      return Card(
                        margin:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            foregroundImage: NetworkImage(group.profilePic),
                          ),
                          title: Text(
                            group.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => GroupChattingScreen(
                            //       userModel: widget.userModel,
                            //       groupModel: group,),),);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _savedGroupsData(){
    return FutureBuilder(future: GroupChatroomHiveData.getAllGroupChatroomsNow(), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Center(
          child: Text("Error fetching groups : ${snapshot.error}"),
        );
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(
          child: Text("No groups found."),
        );
      }

      final groups = snapshot.data!;
      return ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return Card(
            margin:
            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                foregroundImage: NetworkImage(group.profilePic),
              ),
              title: Text(
                group.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Get.to(()=> GroupChattingScreen(userModel: userModel,chatroomModel: group,));
              },
            ),
          );
        },
      );
    },);
  }
}

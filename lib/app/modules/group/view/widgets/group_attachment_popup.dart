import 'dart:io';

import 'package:flutter/material.dart';


import '../../../../data/models/group_chatroom_model.dart';
import '../../../../data/models/message_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/storage/local_file_hive.dart';
import '../../../../data/storage/local_file_manager.dart';
import '../../../../data/storage/message_hive_data.dart';
import '../group_chatting_screen.dart';

class GroupAttachmentPopup extends StatelessWidget {
  final UserModel currentUser;
  final GroupChatroomModel groupModel;
  const GroupAttachmentPopup({super.key,required this.currentUser, required this.groupModel}); 
  Future _getImageFromGallery(BuildContext context) async {
    File? imageFile = await LocalFileManager.pickImageFromGallery();
    // String link =
    //     await FirebaseStorageManager.uploadImageToFirebase(imageFile!);
    if (imageFile == null) {
      // Navigator.pop(context);
      print("image not pick");
      return;
    }

    var message = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: currentUser.id!,
        createdOn: DateTime.now(),
        seen: true,
        type: "image",
        receiver: "",
        chatroomId: groupModel.id);

    LocalFileHive.setFile(message.id!, imageFile.path);
    MessageHiveData.addMessage(message.chatroomId!, message);
    print("sending message to local ${message.toString()}");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GroupChattingScreen(
            userModel: currentUser,
            chatroomModel: groupModel,
            ),
      ),
    );
    // Navigator.pop(context);
    // FirebaseChatManager.sendMessage(
    //   message,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _attachmentsItem(
              "attach_camera_light.png",
              "Camera",
              () {},
            ),
            _attachmentsItem(
              "attach_mic_light.png",
              "Record",
              () {},
            ),
            _attachmentsItem(
              "attach_contact_light.png",
              "Contact",
              () {},
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _attachmentsItem(
              "attach_gallery_light.png",
              "Gallery",
              () async {
                await _getImageFromGallery(context);
              },
            ),
            _attachmentsItem(
              "attach_map_light.png",
              "My Location",
              () {},
            ),
            _attachmentsItem(
              "attach_doc_light.png",
              "Document",
              () {},
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _attachmentsItem(
              "attach_video_light.png",
              "Video",
              () async {
          //       var file = await LocalFileManager.pickVideoFromGallery();
          //       if (file == null) {
          //         print("video not pick");
          //         return;
          //       }
          //        Map<String,String> targetUser = {};
          //       for(var it in groupModel.participants.entries){
          //   targetUser[it.key] = await AuthService().getDeviceTokenById(it.key) as String;
          //
          // }
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => SendVideoScreen(
          //             currentUser: currentUser,
          //             targetUser: targetUser,
          //             chatRoomId: groupModel.id,
          //             file: file!,
          //           ),
          //         ),
          //       );
              },
            ),
            SizedBox(
              width: 40,
            ),
            SizedBox(
              width: 40,
            ),
          ],
        ),
      ],
    );
  }

  Widget _attachmentsItem(
      String imagePath, String title, void Function() onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Image.asset(
            "assets/icons/$imagePath",
            height: 40,
            width: 40,
          ),
        ),
        Text(title),
      ],
    );
  }
}

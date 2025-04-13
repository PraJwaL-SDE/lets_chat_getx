import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lest_chat_5/app/data/storage/message_hive_data.dart';
import 'package:get/get.dart';
import 'package:lest_chat_5/app/modules/image/view/edit_image_screen.dart';
import '../../../../data/models/chat_room.dart';
import '../../../../data/models/message_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/storage/local_file_manager.dart';

class AttachmentPopup extends StatelessWidget {
  final ChatRoom chatRoom;
  final UserModel currentUser;
  final UserModel targetUser;
  final VoidCallback onTap;

  const AttachmentPopup({
    Key? key,
    required this.chatRoom,
    required this.currentUser,
    required this.targetUser,
    this.onTap = _defaultOnTap, // Provide a static default function
  }) : super(key: key);

  static void _defaultOnTap() {
    // Default action when no onTap is provided
  }

  Future<void> _getImageFromGallery(BuildContext context) async {
    File? imageFile = await LocalFileManager.pickImageFromGallery();
    if (imageFile == null) {
      print("No image selected");
      return;
    }

    Get.to(
      EditImageScreen(
        imageFiles: [imageFile],
        userModel: currentUser,
        targetModel: targetUser,
        chatRoom: chatRoom,
      ),
    );
    return;

    var message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: currentUser.id!,
      createdOn: DateTime.now(),
      seen: true,
      type: "image",
      receiver: targetUser.id,
      chatroomId: chatRoom.id,
      filePath: imageFile.path,
    );

    // LocalFileHive.setFile(message.id!, imageFile.path);
    MessageHiveData.addMessage(chatRoom.id!, message);
    print("Sending message to local storage: ${message.filePath}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _attachmentsItem("attach_camera_light.png", "Camera", () {}),
            _attachmentsItem("attach_mic_light.png", "Record", () {}),
            _attachmentsItem("attach_contact_light.png", "Contact", () {}),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _attachmentsItem(
              "attach_gallery_light.png",
              "Gallery",
              () async => await _getImageFromGallery(context),
            ),
            _attachmentsItem("attach_map_light.png", "My Location", () {}),
            _attachmentsItem("attach_doc_light.png", "Document", () {}),
          ],
        ),
      ],
    );
  }

  Widget _attachmentsItem(
    String imagePath,
    String title,
    void Function() onPressed,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            onPressed();
            onTap();
          },
          icon: Image.asset("assets/icons/$imagePath", height: 40, width: 40),
        ),
        Text(title),
      ],
    );
  }
}

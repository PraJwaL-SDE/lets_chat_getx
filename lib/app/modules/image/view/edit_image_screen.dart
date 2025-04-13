import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lest_chat_5/app/modules/chatting/view/chatting_screen.dart';
import 'package:pro_image_editor/core/models/editor_callbacks/pro_image_editor_callbacks.dart';
import 'package:pro_image_editor/features/main_editor/main_editor.dart';

import '../../../data/models/chat_room.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/storage/message_hive_data.dart';

class EditImageScreen extends StatelessWidget {
  final List<File> imageFiles;
  final UserModel userModel;
  final UserModel targetModel;
  final ChatRoom chatRoom;

  EditImageScreen({
    Key? key,
    required this.imageFiles,
    required this.userModel,
    required this.targetModel,
    required this.chatRoom,
  }) : super(key: key);

  Future<File> saveUint8ListToFile(Uint8List imageData) async {
    // Define the target directory
    final downloadsDir = Directory('/storage/emulated/0/Download/Lets Chat');

    // Ensure the directory exists
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }

    // Save the file
    final filePath = '${downloadsDir.path}/edited_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(filePath);
    await file.writeAsBytes(imageData);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (imageFiles.isNotEmpty)
            Positioned.fill(
              child: ProImageEditor.file(
                imageFiles.first,
                callbacks: ProImageEditorCallbacks(
                  onImageEditingComplete: (imageData) async {
                    try {
                      if (imageData is Uint8List) {
                        // Save the Uint8List as a file
                        final editedFile = await saveUint8ListToFile(imageData);

                        // Create the message
                        final message = MessageModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          sender: userModel.id!,
                          createdOn: DateTime.now(),
                          seen: true,
                          type: "image",
                          receiver: targetModel.id,
                          chatroomId: chatRoom.id,
                          filePath: editedFile.path,
                        );

                        // Store the message in local database
                        MessageHiveData.addMessage(chatRoom.id!, message);

                        Get.off(ChattingScreen(userModel: userModel, targetModel: targetModel, chatRoom: chatRoom));
                        print("Saved message: ${message.filePath}");
                      } else {
                        print("Unexpected imageData format: ${imageData.runtimeType}");
                      }
                    } catch (e) {
                      print("Error saving image: $e");
                    }
                  },
                  onCloseEditor: () {
                    Get.back();
                    print("Editor closed without saving.");
                  },
                ),
              ),
            )
          else
            const Center(
              child: Text("No image files to edit."),
            ),
        ],
      ),
    );
  }
}

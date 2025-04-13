import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lest_chat_5/app/data/storage/message_hive_data.dart';
import 'package:lest_chat_5/app/modules/chatting/controller/chat_list_tile_controller.dart';

import '../../../../data/models/message_model.dart';
import '../../../../data/storage/local_image_hive.dart';
import '../../../image/view/show_image_screen.dart';

class ChatListTile extends StatelessWidget {
  final MessageModel message;
  final bool isSender;
  final int index;
  final bool isSelected;
  final bool disableGestures; // New parameter to control gesture disabling

  final controller = Get.put(ChatListTileController());

  ChatListTile({
    Key? key,
    required this.message,
    required this.isSender,
    required this.index,
    this.isSelected = false,
    this.disableGestures = false, // Default to allow gestures
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          key: Key(message.id!),
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSender ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Builder(
                  builder: (context) {
                    if (message.type == "image") {
                      return _imageView(context);
                    }
                    return Text(
                      message.text ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        color: isSender ? Colors.white : Colors.black,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        // Foreground overlay color for selection
        if (isSelected)
          Positioned.fill(
            child: Container(
              color: Colors.blue.withOpacity(0.4),
            ),
          ),
      ],
    );
  }


  Widget _imageView(BuildContext context) {
    final String heroTag = message.id ?? UniqueKey().toString();

    if (isSender) {
      return GestureDetector(
        onTap:
            disableGestures
                ? null
                : () {
                  if (message.filePath != null &&
                      message.filePath!.isNotEmpty) {
                    Get.to(
                      () => ShowImageScreen(
                        imageFile: File(message.filePath!),
                        heroTag: heroTag,
                      ),
                    );
                  }
                },
        child: Hero(
          tag: heroTag,
          child: Container(
            height: 300,
            width: 300,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.file(File(message.filePath!), fit: BoxFit.cover),
                ),
                if (message.fileUrl == null || message.fileUrl!.isEmpty)
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: FutureBuilder(
                      future: controller.uploadFile(
                        message.sender!,
                        message.receiver!,
                        message.filePath!,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            message.fileUrl = "uploaded_file_url";
                            MessageHiveData.updateMessage(
                              message.chatroomId!,
                              message,
                            );
                          });
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    } else {
      if (message.filePath != null && message.filePath!.isNotEmpty) {
        return GestureDetector(
          onTap:
              disableGestures
                  ? null
                  : () {
                    Get.to(
                      () => ShowImageScreen(
                        imageFile: File(message.filePath!),
                        heroTag: heroTag,
                      ),
                    );
                  },
          child: Hero(
            tag: heroTag,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: FileImage(File(message.filePath!)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      } else if (message.fileUrl != null && message.fileUrl!.isNotEmpty) {
        return FutureBuilder(
          future: controller.downloadFile(message.fileUrl!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 300,
                width: 300,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                message.filePath = snapshot.data!; // Replace with actual path
                MessageHiveData.updateMessage(message.chatroomId!, message);
              });
              return GestureDetector(
                onTap:
                    disableGestures
                        ? null
                        : () {
                          Get.to(
                            () => ShowImageScreen(
                              imageFile: File(snapshot.data!),
                              heroTag: heroTag,
                            ),
                          );
                        },
                child: Hero(
                  tag: heroTag,
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: FileImage(File(snapshot.data!)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          },
        );
      } else {
        return Container(
          height: 300,
          width: 300,
          alignment: Alignment.center,
          child: Text(
            "Image not available",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        );
      }
    }
  }
}

class CustomClipperRight extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double arrowSize = 10;
    double radius = 15;
    // bottom left
    path.lineTo(0, size.height - radius);
    path.quadraticBezierTo(0, size.height, radius, size.height);

    // bottom right

    path.lineTo(size.width - radius - arrowSize, size.height);
    path.quadraticBezierTo(
      size.width - arrowSize,
      size.height,
      size.width - arrowSize,
      size.height - radius,
    );

    path.lineTo(size.width - arrowSize, arrowSize);
    path.lineTo(size.width, 0);

    path.lineTo(arrowSize, 0);
    path.quadraticBezierTo(0, 0, 0, radius);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomClipperLeft extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double arrowSize = 10; // Size of the arrow pointer
    double radius = 15; // Corner radius

    path.lineTo(arrowSize, arrowSize);
    path.lineTo(arrowSize, size.height - radius);
    path.quadraticBezierTo(
      arrowSize,
      size.height,
      arrowSize + radius,
      size.height,
    );

    path.lineTo(size.width - radius, size.height);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height - radius,
    );

    path.lineTo(size.width, radius);
    path.quadraticBezierTo(size.width, 0, size.width - radius, 0);

    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

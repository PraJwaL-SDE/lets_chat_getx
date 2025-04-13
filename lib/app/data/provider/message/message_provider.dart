import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lest_chat_5/app/data/models/chat_room.dart';
import 'package:lest_chat_5/app/data/models/message_model.dart';
import 'package:lest_chat_5/app/data/provider/auth/auth_provider.dart';
import 'package:lest_chat_5/app/data/storage/chatroom_hive_data.dart';
import 'package:lest_chat_5/app/data/storage/group_chatroom_hive_data.dart';
import 'package:lest_chat_5/app/data/storage/message_hive_data.dart';
import 'package:lest_chat_5/app/data/storage/user_hive_data.dart';
import 'package:mime/mime.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';

import '../../models/group_chatroom_model.dart';

class MessageProvider {
  static IO.Socket? socket;

  static void connect(String userId) {
    try {
      socket = IO.io(
        "https://chatting-backend-j5p5.onrender.com",
        <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': true,
        },
      );

      socket!.connect();

      socket!.onConnect((_) {
        print('Connected to server');
        socket!.emit("identify", userId);
      });

      socket!.onDisconnect((_) => print("Disconnected"));
    } catch (e) {
      print("Socket connection error: $e");
    }
  }

  static void sendMessage(
    String senderId,
    String receiverId,
    String message, {
    String messageType = "text",
  }) {
    try {
      print("Sending : " + message);
      final messageData = {
        "sender": senderId,
        "receiver": receiverId,
        "message": message,
        "messageType": messageType,
      };

      socket?.emit("sendMessage", messageData);
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  static void listenMessages() {
    print("Listening to messages...");
    try {
      socket?.on("receiveMessage", (message) async {
        print("Received message: $message");

        try {
          final senderId = message['sender'];
          final receiverId = message['receiver'];
          final messageId = message['_id'];
          final messageType = message['messageType'];
          final text = message['message'];

          if (messageType == "CREATEGROUP") {
            final groupModel = GroupChatroomModel.fromJson(text);
            if (groupModel != null) {
              GroupChatroomHiveData.setGroupChatroom(groupModel);
            }
          } else if (messageType == "MESSAGE_STATUS") {
            // String _messageId = text["messageId"];
            String _messageStatus = text["STATUS"];
            String _chatroomId = text["chatroomId"];

            final chatroom = await ChatroomHiveData.getChatroom(_chatroomId);
            chatroom!.messageStatus = _messageStatus;
            ChatroomHiveData.setChatroom(chatroom);
          } else {
            final availableChatroom =
                await ChatroomHiveData.getChatroomBySender(senderId);

            // Create chatroom if not found
            ChatRoom chatroom =
                availableChatroom.isEmpty
                    ? await _createNewChatroom(senderId, receiverId)
                    : availableChatroom.first;

            // Save message based on type
            MessageModel messageModel = MessageModel(
              id: messageId,
              sender: senderId,
              receiver: receiverId,
              createdOn: DateTime.now(),
              chatroomId: chatroom.id!,
              text: text,
              type: messageType,
              fileUrl: messageType == "image" ? message['mediaUrl'] : null,
            );
            await MessageHiveData.addMessage(chatroom.id!, messageModel);
            sendMessage(
              senderId,
              receiverId,
              jsonEncode({
                "messageId": messageId,
                "STATUS": "DELIVER",
                "chatroomId": chatroom.id!,
              }),
              messageType: "MESSAGE_STATUS",
            );

            // Save sender if not already in Hive
            if (UserHiveData.getUserModel(senderId) == null) {
              saveUserModel(senderId);
            }
          }

          // Optionally delete the message after handling
          deleteMessage(messageId);
        } catch (e) {
          print("Error handling received message: $e");
        }
      });
    } catch (e) {
      print("Error listening to messages: $e");
    }
  }

  // Helper function to create a new chatroom
  static Future<ChatRoom> _createNewChatroom(
    String senderId,
    String receiverId,
  ) async {
    Uuid uuid = Uuid();
    ChatRoom newChatroom = ChatRoom(
      participants: {senderId: true, receiverId: true},
      id: uuid.v6(),
      createdAt: DateTime.now(),
    );
    print("Chatroom created with ID: ${newChatroom.id}");
    await ChatroomHiveData.setChatroom(newChatroom);
    return newChatroom;
  }

  static void saveUserModel(String id) async {
    AuthProvider authProvider = AuthProvider();
    final userModel = await authProvider.getUserById(id);
    if (userModel != null) {
      UserHiveData.setUserModel(userModel);
    }
  }

  static void deleteMessage(String messageId) {
    try {
      print("Deleting message: $messageId");
      socket?.emit("deleteMessage", {"messageId": messageId});
    } catch (e) {
      print("Error deleting message: $e");
    }
  }

  static Future<void> uploadFileMessage(
    String senderId,
    String receiverId,
    String filepath,
  ) async {
    try {
      // 1. Pick file

      File file = File(filepath);
      Uint8List fileBytes = await file.readAsBytes();
      String fileName =
          file.path.split('/').last; // Extract file name from path
      String fileType = lookupMimeType(fileName) ?? 'application/octet-stream';

      // 2. Base64 encode file
      String base64Data = base64Encode(fileBytes as List<int>);

      // 3. Emit to server
      socket?.emit('uploadFileMessage', {
        "sender": senderId,
        "receiver": receiverId,
        "buffer": base64Data,
        "fileName": fileName,
        "fileType": fileType,
        "messageType": "image",
      });

      print("File upload message sent");
    } catch (e) {
      print("File upload failed: $e");
    }
  }
}

import 'package:hive_flutter/hive_flutter.dart';
import 'package:lest_chat_5/app/data/models/message_model.dart';
import 'package:lest_chat_5/app/data/storage/chatroom_hive_data.dart';


class MessageHiveData {
  static late Box<List<dynamic>> _messageBox;
  static Box<List<dynamic>> getMessageBox() {
    if (!Hive.isBoxOpen('messageBox')) {
      throw Exception("MessageBox is not initialized. Call `init()` first.");
    }
    return _messageBox;
  }

  /// Initialize the Hive box
  static Future<void> initialize() async {
    try {
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(MessageModelAdapter());
      }
      _messageBox = await Hive.openBox<List<dynamic>>('messageBox');
    } catch (e) {
      throw Exception("Message Hive Data: Failed to initialize Hive storage.");
    }
  }

  /// Add a message to the array by `arrayId`
  static Future<void> addMessage(String arrayId, MessageModel message) async {
    try {
      print("adding message : ${message.filePath}");

      final rawMessages = await _messageBox.get(arrayId) ?? <dynamic>[];

      final List<Map<String, dynamic>> currentMessages = rawMessages.map((msg) {
        if (msg is Map<dynamic, dynamic>) {
          return Map<String, dynamic>.from(msg);
        } else {
          throw Exception("Message Hive Data: Invalid message format: $msg");
        }
      }).toList();

      final existingIndex = currentMessages.indexWhere((m) => m["message_id"] == message.id);

      if (existingIndex != -1) {
        currentMessages[existingIndex] = message.toMap();
      } else {
        currentMessages.add(message.toMap());
      }


      await _messageBox.put(arrayId, currentMessages);
      ChatroomHiveData.updateLastMessage(message.chatroomId!, message);
    } catch (e) {
      throw Exception("Message Hive Data: Failed to add/update message.");
    }
  }

  /// Delete a message by `arrayId` and `messageId`
  static Future<void> deleteMessage(String arrayId, String messageId) async {
    try {
      final currentMessages =
          _messageBox.get(arrayId)?.cast<Map<String, dynamic>>() ?? <Map<String, dynamic>>[];
      final updatedMessages = currentMessages.where((msg) => msg['id'] != messageId).toList();
      await _messageBox.put(arrayId, updatedMessages);
    } catch (e) {
      throw Exception("Message Hive Data: Failed to delete message.");
    }
  }

  /// Get all messages as a stream for real-time updates
  static Stream<List<MessageModel>> getAllMessage(String arrayId) {
    try {
      return _messageBox.watch(key: arrayId).map((event) {
        try {
          final List<MessageModel> storedMessages = [];
          final rawMessagesList = event.value as List<dynamic>?;
          if (rawMessagesList == null) return <MessageModel>[];

          rawMessagesList.forEach((msg) {
            if (msg is Map<String, dynamic>) {
              try {
                storedMessages.add(MessageModel(
                    id: msg["message_id"] ?? '',
                    sender: msg["sender"] ?? '',
                    receiver: (msg["receiver"]),
                    text: msg["text"] ?? '',
                    createdOn: DateTime.tryParse(msg['createdOn'] ?? '') ?? DateTime.now(),
                    chatroomId: msg["chatroomId"] ?? '',
                    seen: msg["seen"] ?? false,
                    type: msg["type"],
                    filePath: msg['filePath']??null,
                    fileUrl: msg['fileUrl']??null,

                ));
              } catch (e) {}
            }
          });

          storedMessages.sort((a, b) => b.createdOn!.compareTo(a.createdOn!));
          return storedMessages;
        } catch (e) {
          return <MessageModel>[];
        }
      });
    } catch (e) {
      throw Exception("Message Hive Data: Failed to set up message stream.");
    }
  }


  /// Get all messages immediately
  static Future<List<MessageModel>> getAllMessagesNow(String arrayId) async {
    try {
      final rawMessages = await _messageBox.get(arrayId) ?? <dynamic>[];
      List<MessageModel> currentMessages = [];

      rawMessages.forEach((message) {
        try {
          currentMessages.add(MessageModel(
              id: message["message_id"] ?? '',
              sender: message["sender"] ?? '',
              receiver: message["receiver"],
              text: message["text"] ?? '',
              createdOn: DateTime.tryParse(message['createdOn'] ?? '') ?? DateTime.now(),
              chatroomId: message["chatroomId"] ?? '',
              seen: message["seen"] ?? false,
              type: message["type"],
            filePath: message['filePath']??null,
            fileUrl: message['fileUrl']??null,
          ));
        } catch (e) {}
      });

      currentMessages.sort((a, b) => b.createdOn!.compareTo(a.createdOn!));
      return currentMessages;
    } catch (e) {
      return [];
    }
  }
  /// Update a message by `arrayId` using a `MessageModel`
  static Future<void> updateMessage(String arrayId, MessageModel updatedMessage) async {
    try {

      // Retrieve current messages
      final rawMessages = await _messageBox.get(arrayId) ?? <dynamic>[];

      // Find the index of the message to update
      final int index = rawMessages.indexWhere((msg) => msg["message_id"] == updatedMessage.id);
      if (index == -1) {
        throw Exception("Message Hive Data: Message with ID ${updatedMessage.id} not found in array $arrayId.");
      }

      // Replace the message at the found index
      rawMessages[index] = updatedMessage.toMap();

      // Save the updated list back to the box
      await _messageBox.put(arrayId, rawMessages);
    } catch (e) {
      throw Exception("Message Hive Data: Failed to update message with ID ${updatedMessage.id}. Error: $e");
    }
  }

  static Future<MessageModel> getMessage(String chatroomId, String messageId) async {
    try {
      final messageList = await getAllMessagesNow(chatroomId);
      return messageList.firstWhere((message) => message.id == messageId);
    } catch (e) {
      throw Exception("Message with ID $messageId not found");
    }
  }


}